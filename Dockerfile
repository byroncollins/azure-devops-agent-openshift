FROM ubuntu:16.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)

ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update \
&& apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        jq \
        git \
        iputils-ping \
        libcurl3 \
        libicu55 \
        libunwind8 \
        netcat

#Install OpenShift Client binary
ARG OPENSHIFT_VERSION
ENV OPENSHIFT_VERSION ${OPENSHIFT_VERSION:-3.11.188}
ENV OPENSHIFT_CLIENT_BINARY_URL=https://mirror.openshift.com/pub/openshift-v3/clients/${OPENSHIFT_VERSION}/linux/oc.tar.gz
ADD ${OPENSHIFT_CLIENT_BINARY_URL} /tmp/

RUN mkdir -p /usr/local/bin  \
&& tar xzf /tmp/oc.tar.gz -C /usr/local/bin \
&& chmod +x /usr/local/bin/oc \
&& rm -rf /tmp/oc.tar.gz

WORKDIR /azp

COPY ./start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]