FROM alpine:3.12

# Latest version of kubectl can be found at:
# https://github.com/kubernetes/kubernetes/releases
ENV KUBE_VERSION="v1.18.6"

# Latest version of helm can be found at:
# https://github.com/helm/helm/releases
ENV HELM_VERSION="v3.3.0"

# Latest version of sops can be found at:
# https://github.com/mozilla/sops/releases
ENV SOPS_VERSION="v3.6.0"

RUN apk add --update --no-cache ca-certificates bash git openssh curl python3 \
    && apk add --update -t deps \
    #&& apk -U add findutils \
    && wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm \
    && wget -q https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux -O /usr/local/bin/sops \
    && chmod +x /usr/local/bin/sops \
    && wget -q https://github.com/kubernetes/kops/releases/download/v1.20.0/kops-linux-amd64 -O /usr/local/bin/kops \
    && chmod +x /usr/local/bin/kops \
    && chmod g+rwx /root \
    && mkdir /config \
    && chmod g+rwx /config

RUN apk add py3-pip \
    && pip3 install awscli

WORKDIR /config
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh
