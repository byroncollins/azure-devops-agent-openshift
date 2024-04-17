#!/bin/bash
# exit when any command fails
set -e

OPENSHIFT_VERSION=$1
OPENSHIFT_URL="https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OPENSHIFT_VERSION}/openshift-client-linux-${OPENSHIFT_VERSION}.tar.gz"
OPENSHIFT_BINARY_FILE="openshift-client-linux-${OPENSHIFT_VERSION}.tar.gz"


echo "OPENSHIFT_VERSION=${OPENSHIFT_VERSION}"
echo "OPENSHIFT_BINARY_FILE=${OPENSHIFT_BINARY_FILE}"
echo "OPENSHIFT_URL=${OPENSHIFT_URL}"

#Download OpenShift client binary
curl --silent --show-error --output "/tmp/${OPENSHIFT_BINARY_FILE}" "${OPENSHIFT_URL}"

#Install OpenShift Client Binary
mkdir -p /usr/local/bin 
tar xzf "/tmp/${OPENSHIFT_BINARY_FILE}" oc kubectl -C /usr/local/bin
chmod +x /usr/local/bin/oc /usr/local/bin/kubectl
rm -rf "/tmp/${OPENSHIFT_BINARY_FILE}"