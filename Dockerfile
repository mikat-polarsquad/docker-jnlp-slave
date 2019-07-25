# The MIT License
#
#  Copyright (c) 2015-2017, CloudBees, Inc.
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

FROM alpine:latest
# FROM jenkins/slave:3.29-2
MAINTAINER Mika Tuominen <mika.tuominen@polarsquad.com>
LABEL Description="This is a base image, which allows connecting Jenkins agents via JNLP protocols" Vendor="Jenkins project" Version="3.29"

# Versions: https://pypi.python.org/pypi/awscli#downloads
# ENV AWS_CLI_VERSION 1.16.140
ENV USER=jenkins
ENV KUBE_LATEST_VERSION="v1.15.1"

# RUN apt-get --no-cache update && \
# RUN apk add --no-cache docker && \
# RUN apk add --no-cache py-pip && \
# RUN apk add  --no-cache python-dev libffi-dev openssl-dev gcc libc-dev make curl && \
# RUN pip install docker-compose && \
# RUN curl -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
#     # curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
# RUN chmod +x /usr/local/bin/kubectl && \
# RUN kubectl version

RUN apk update
RUN apk add --no-cache docker
# RUN apk add --no-cache rc-update
# RUN service docker start
# RUN rc-update add docker boot
RUN apk add --no-cache py-pip
RUN apk add  --no-cache python-dev libffi-dev openssl-dev gcc libc-dev make curl
RUN curl -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl
    # curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
RUN chmod +x /usr/local/bin/kubectl

# RUN pip install docker-compose
curl -L https://github.com/docker/compose/releases/download/1.14.0/docker-compose-'uname -s'-'uname -m' > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose


# RUN kubectl version
    # apk --no-cache add ca-certificates groff less && \
    # pip3 --no-cache-dir install awscli==${AWS_CLI_VERSION} && \
    # rm -rf /var/cache/apk/*

RUN mkdir /usr/local/bin/jenkins-slave
COPY jenkins-slave /usr/local/bin/jenkins-slave

ENTRYPOINT ["jenkins-slave"]
RUN addgroup "$USER" \
    && adduser \
    --disabled-password \
    --gecos "" \
    --home "/home/$USER" \
    --ingroup "$USER" \
    --no-create-home \
    "$USER"
WORKDIR "/home/$USER"
USER jenkins
