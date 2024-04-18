FROM ubuntu:22.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)

ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

ARG ADDITIONAL_PACKAGES
ENV ADDITIONAL_PACKAGES ${ADDITIONAL_PACKAGES:-}
# Also can be "linux-arm", "linux-arm64".
ENV TARGETARCH="linux-x64"

RUN apt-get update \
&& apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        jq \
        git \
        iputils-ping \
        libcurl4 \
        libicu70 \
        libunwind8 \
        netcat \
        zip \
        unzip \
        ${ADDITIONAL_PACKAGES} \
&& rm -rf /var/lib/apt/lists/* \
&& apt-get clean    
        
#Install OpenShift Client binary
ENV OPENSHIFT_VERSION ${OPENSHIFT_VERSION:-4.15.9}
COPY scripts/download-ocp.sh /tmp/download-ocp.sh
RUN /bin/bash /tmp/download-ocp.sh ${OPENSHIFT_VERSION} \
&& rm -rf /tmp/download-ocp.sh \
&& mkdir /azp

COPY ./start.sh .

RUN chmod 755 ./start.sh \
&&  chmod 755 /azp \
&&  chgrp -R 0 /azp \
&&  chmod -R og+rw /azp

USER 1001

ENTRYPOINT [ "./start.sh", "--once" ]