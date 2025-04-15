FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04
LABEL maintainer="sebastian@sommerfeld.io"

ARG USER=vscode

RUN apt-get update \
    && apt-get install -y --no-install-recommends python3-pip=24.0+dfsg-1ubuntu1 \
    && apt-get install -y --no-install-recommends pre-commit=3.6.2-1 \
    && apt-get install -y --no-install-recommends vim=2:9.1.0016-1ubuntu7.8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ARG TASK_VERSION=3.42.1
RUN curl -L -o /tmp/task.deb https://github.com/go-task/task/releases/download/v${TASK_VERSION}/task_linux_amd64.deb \
    && dpkg -i /tmp/task.deb \
    && rm /tmp/task.deb

COPY configs/etc/login.defs /etc/login.defs
RUN chmod 0444 /etc/login.defs \
    && chmod o-r /etc/shadow \
    && chmod g+r /etc/shadow \
    && chmod go-r /etc/cron.daily \
    && chmod go-r /etc/cron.weekly \
    && chmod go-r /etc/cron.d

USER $USER

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo "alias ls='ls -a --color=auto'" >> /home/$USER/.bashrc \
    && echo "alias ll='ls -alF --color=auto'" >> /home/$USER/.bashrc \
    && curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | bash
