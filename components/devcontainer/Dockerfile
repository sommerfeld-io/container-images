# See <https://hub.docker.com/r/microsoft/devcontainers-base#about-ubuntu>
# `resolute` = ubuntu-26.04
FROM mcr.microsoft.com/devcontainers/base:resolute
LABEL maintainer="sebastian@sommerfeld.io"

ARG USER=vscode

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python3-pip \
        pre-commit \
        vim \
        fastfetch \
        iputils-ping \
        nodejs \
        npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ARG TARGETARCH
ARG CTOP_VERSION=0.7.7
ARG CTOP_TARGET=/usr/local/bin/ctop
RUN curl -L https://github.com/bcicen/ctop/releases/download/v${CTOP_VERSION}/ctop-${CTOP_VERSION}-linux-${TARGETARCH} -o ${CTOP_TARGET} \
    && chmod ugo+rx ${CTOP_TARGET}

ARG TASK_VERSION=3.42.1
ARG TASK_TARGET=/tmp/task.deb
RUN curl -fsSL "https://github.com/go-task/task/releases/download/v${TASK_VERSION}/task_linux_${TARGETARCH}.deb" -o ${TASK_TARGET} \
    && dpkg -i ${TASK_TARGET} \
    && rm ${TASK_TARGET}

RUN (type -p wget >/dev/null || (apt update && apt install -y wget)) \
	&& mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat $out | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& apt update \
	&& apt install -y gh

COPY configs/etc/login.defs /etc/login.defs
RUN chmod 0444 /etc/login.defs \
    && chmod o-r /etc/shadow \
    && chmod g+r /etc/shadow \
    && chmod go-r /etc/cron.daily \
    && chmod go-r /etc/cron.weekly \
    && chmod go-r /etc/cron.d

USER ${USER}

COPY --chown=${USER}:${USER} configs/bash_aliases.txt /home/${USER}/.bash_aliases
COPY --chown=${USER}:${USER} claude /home/${USER}/.claude

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | bash \
    && curl -fsSL https://gh.io/copilot-install | bash \
    && curl -fsSL https://claude.ai/install.sh | bash
