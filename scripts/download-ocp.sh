#!/bin/bash
# exit when any command fails
set -e

OPENSHIFT_VERSION=$1
OPENSHIFT_3_CLIENT_BINARY_URL=https://mirror.openshift.com/pub/openshift-v3/clients/${OPENSHIFT_VERSION}/linux/oc.tar.gz
OPENSHIFT_4_CLIENT_BINARY_URL=https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OPENSHIFT_VERSION}/openshift-client-linux-${OPENSHIFT_VERSION}.tar.gz


echo "OPENSHIFT_VERSION=${OPENSHIFT_VERSION}"
echo "OPENSHIFT_3_CLIENT_BINARY_URL=${OPENSHIFT_3_CLIENT_BINARY_URL}"
echo "OPENSHIFT_4_CLIENT_BINARY_URL=${OPENSHIFT_4_CLIENT_BINARY_URL}"

# Determine Openshift Major Verison
if [[ $OPENSHIFT_VERSION == 3* ]]
then
    OPENSHIFT_MAJOR_VERSION=3
    OPENSHIFT_BINARY_FILE=oc.tar.gz
elif [[ $OPENSHIFT_VERSION == 4* ]]
then
    OPENSHIFT_MAJOR_VERSION=4
    OPENSHIFT_BINARY_FILE="openshift-client-linux-${OPENSHIFT_VERSION}.tar.gz"
else
    echo "Not a valid OpenShift major version  OPENSHIFT_VERSION=$OPENSHIFT_VERSION"; exit 1
fi

echo "OPENSHIFT_MAJOR_VERSION=${OPENSHIFT_MAJOR_VERSION}"
echo "OPENSHIFT_BINARY_FILE=${OPENSHIFT_BINARY_FILE}"

#Download OpenShift client binary
OPENSHIFT_URL=OPENSHIFT_${OPENSHIFT_MAJOR_VERSION}_CLIENT_BINARY_URL
echo "OPENSHIFT_URL=${!OPENSHIFT_URL}"
curl --silent --show-error --output /tmp/${OPENSHIFT_BINARY_FILE} ${!OPENSHIFT_URL}

#Install OpenShift Client Binary
mkdir -p /usr/local/bin 
tar xzf /tmp/oc.tar.gz -C /usr/local/bin
chmod +x /usr/local/bin/oc
rm -rf /tmp/${OPENSHIFT_BINARY_FILE}