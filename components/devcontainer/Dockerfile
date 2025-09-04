FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04
LABEL maintainer="sebastian@sommerfeld.io"

ARG USER=vscode

RUN apt-get update \
    && apt-get install -y --no-install-recommends python3-pip \
    && apt-get install -y --no-install-recommends pre-commit \
    && apt-get install -y --no-install-recommends vim \
    && apt-get install -y --no-install-recommends neofetch \
    && apt-get install -y --no-install-recommends iputils-ping \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ARG TASK_VERSION=3.42.1
ADD https://github.com/go-task/task/releases/download/v${TASK_VERSION}/task_linux_amd64.deb /tmp/task.deb
RUN dpkg -i /tmp/task.deb \
    && rm /tmp/task.deb

COPY configs/etc/login.defs /etc/login.defs
RUN chmod 0444 /etc/login.defs \
    && chmod o-r /etc/shadow \
    && chmod g+r /etc/shadow \
    && chmod go-r /etc/cron.daily \
    && chmod go-r /etc/cron.weekly \
    && chmod go-r /etc/cron.d

USER ${USER}

COPY configs/bash_aliases.txt /home/${USER}/.bash_aliases

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | bash \
    && echo "export TASK_X_REMOTE_TASKFILES=1" >> /home/${USER}/.bashrc
