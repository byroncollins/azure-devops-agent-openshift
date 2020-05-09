# Description

OpenShift manifests and instructions for running Azure Agent on OpenShift

# Documentation

- [running azure agent in Docker](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops#linux)
- based on [azure-pipelines-ephemeral-agents](https://github.com/microsoft/azure-pipelines-ephemeral-agents)

# Build Instructions

## Customisations

- OpenShift Client Binary installed
- Automatic cleanup of agents on container exit
- ephermal agent runs a single job and then exits using --once 
- enable proxy setting

## Create azure-repos pull secret

```bash
# Create azure devops basic auth secret for accessing git repo
# replace <user_name> with your username
# replace <token> with the generated token from azure devops
oc create secret generic azure-repo-secret \
    --from-literal=username=<user_name> \
    --from-literal=password=<token> \
    --type=kubernetes.io/basic-auth
```

## Create build config and imagestream

```bash
# Generate buildconfig and imagestream
 oc process -f manifests/azure-agent-buildconfig.yaml --param=GIT_URL=https://mocatad@dev.azure.com/mocatad/DNZ-269/_git/azure-devops-agent-openshift --param=REPO_SECRET=azure-repo-secret | oc apply -f -
 ```

# Deployment

## Create azure-agent configmap 

```bash
#OpenShift cluster NOT running behind a proxy
oc process -f manifests/azure-agent-configmap.yaml \
    --param=AZP_URL='https://dev.azure.com/mocatad' \
    --param=AZP_POOL="Dev.Container" | oc apply -f -
```

```bash
#OpenShift cluster running behind a proxy
oc process -f manifests/azure-agent-configmap.yaml \
    --param=AZP_URL='https://dev.azure.com/mocatad' \
    --param=AZP_POOL="Dev.Container" \
    --param=HTTP_URL="http://myproxy:3128" \
    --param-HTTP_USERNAME="username to access process" | oc apply -f -
```
```

## Create azure-agent secret with PAT

PAT can be generated as documented [here](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-linux?view=azure-devops#permissions) or extraced from password store

```bash
#OpenShift cluster NOT running behind a proxy
oc process -f manifests/azure-agent-secret.yaml \
    --param=AZP_TOKEN='<TOKEN>' | oc apply -f - 
```

```bash
#OpenShift cluster  running behind a proxy that requires a password
oc process -f manifests/azure-agent-secret.yaml \
    --param=AZP_TOKEN='<TOKEN>' \
    --param=PROXY_PASSWORD="mypassword" | oc apply -f - 
```


## Deploy azure-devops-agent POD

```bash
# Defaults
oc process -f manifests/azure-agent-deploymentconfig.yaml --parameters=true
NAME                DESCRIPTION         GENERATOR           VALUE
IMAGE               Image to use                            azure-devops-agent:latest
CPU_LIMIT           CPU Limit                               200m
MEMORY_LIMIT        Memory limit                            300Mi

# Example
oc process -f manifests/azure-agent-deploymentconfig.yaml | oc apply -f -
```

## Scale agents

The Agents PODs deployed are designed to execute a single job and then exit and then OpenShift will spin up another POD to take over.

Running PODs with multi replicas can improve the availablity of the agents running in OpenShift.

```bash
oc scale dc/azure-devops-agent --replicas=2
```