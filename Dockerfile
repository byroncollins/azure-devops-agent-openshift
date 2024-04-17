FROM ubuntu:22.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)

ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

ARG ADDITIONAL_PACKAGES
ENV ADDITIONAL_PACKAGES ${ADDITIONAL_PACKAGES:-}
RUN apt-get update \
&& apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        jq \
        git \
        iputils-ping \
        libcurl4 \
        libicu60 \
        libunwind8 \
        netcat \
        ${ADDITIONAL_PACKAGES}
        
#Install OpenShift Client binary
ENV OPENSHIFT_VERSION ${OPENSHIFT_VERSION:-4.15.9}
COPY scripts/download-ocp.sh /tmp/download-ocp.sh
RUN /bin/bash /tmp/download-ocp.sh ${OPENSHIFT_VERSION} \
&& rm -rf /tmp/download-ocp.sh

WORKDIR /azp

COPY ./start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]