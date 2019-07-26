FROM amazonlinux
# FROM jenkins/slave:3.29-2
# FROM jenkins/jnlp-slave
MAINTAINER Mika Tuominen <mika.tuominen@polarsquad.com>

ENV DOCKER_VERSION=18.09.6-ce DOCKER_COMPOSE_VERSION=1.24.0 KUBECTL_VERSION=v1.13.3
ENV USER=jenkins

USER root

RUN yum update -y
RUN amazon-linux-extras install docker

# RUN apt-get update && \
#     apt-get -y install apt-transport-https \
#     ca-certificates \
#     curl \
#     gnupg2 \
#     software-properties-common && \
#     curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
#     add-apt-repository \
#     # "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
#     "deb [arch=amd64] https://download.docker.com/linux/debian \
#     $(lsb_release -cs) \
#     stable" && \
#     apt-get update && \
#     apt-cache policy docker-ce docker-ce-cli containerd.io && \
#     apt-get -y install libltdl7 && \
#     apt-get -y install docker

# RUN sudo service docker status
# RUN service docker start
# RUN docker version

# RUN systemctl enable docker
RUN chkconfig docker on

# RUN groupadd ${USER}
RUN adduser --home-dir /home/${USER} --groups docker ${USER}
# RUN adduser --home-dir /home/${USER} --gid ${USER} --groups docker ${USER}
    # --disabled-password \
    # --gecos "" \
    # --no-create-home \

# RUN usermod -aG docker $USER

# RUN curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-'uname -s'-'uname -m' | sudo tee /usr/local/bin/docker-compose > /dev/null && \
RUN curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-'uname -s'-'uname -m' -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# RUN docker-compose --version
# RUN curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose \
#     && chmod +x /usr/local/bin/docker-compose

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl


# RUN mkdir /usr/local/bin/jenkins-slave
COPY jenkins-slave /usr/local/bin/jenkins-slave

ENTRYPOINT ["jenkins-slave"]
WORKDIR "/home/$USER"
USER jenkins