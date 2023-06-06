FROM python:3.7-alpine3.9

LABEL maintainer="Tapan Halani"
LABEL maintaners="Harsh Mishra"

ENV PYTHONIOENCODING=UTF-8

### Install curl, aws-cli, kubectl
RUN apk add --update --no-cache curl ca-certificates \
    && curl -sL -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && curl -sL -o glibc-2.28-r0.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk \
    && apk add glibc-2.28-r0.apk \
    && curl -sL -o glibc-bin-2.28-r0.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-bin-2.28-r0.apk \
    && apk add glibc-bin-2.28-r0.apk \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -Rf aws/ awscliv2.zip glibc-2.28-r0.apk glibc-bin-2.28-r0.apk \
    && aws --version \
    && curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

ENV HELM_VERSION="v3.3.0"

### Install helm v3.3.0
RUN wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]