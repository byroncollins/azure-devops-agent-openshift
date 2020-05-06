# azure-devops-agent-openshift
OpenShift manifests and instructions for running Azure Agent on OpenShift

# Build Instructions

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

## Create build config

# Deployment Instructions

## Create azure-agent configmap 

```bash
oc process -f manifests/azure-agent-configmap.yaml \
    --param=AZP_URL=https://mocatad.visualstudio.com/DNZ-269 \
    --param=AZP_AGENT_NAME="Dev.Container" | oc apply -f -

```

## Create azure-agent secret with PAT

```bash
oc process -f manifests/azure-agent-secret.yaml \
    --param=AZP_TOKEN=waz6v2wtxr6r2qalgjnfujkrv6dexaqqy7ygzhm273zsm4676ana | oc apply -f - 
```