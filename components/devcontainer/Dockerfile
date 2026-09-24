## Stage: base — default devcontainer image with core CLI tooling (task,
## gh, ctop, uv, Claude/Copilot CLIs).
##
## See <https://hub.docker.com/r/microsoft/devcontainers-base#about-ubuntu>
## `resolute` tracks the current Ubuntu LTS base image published by Microsoft
## Dev Containers.
FROM mcr.microsoft.com/devcontainers/base:resolute AS base
LABEL maintainer="sebastian@sommerfeld.io"

ARG USER=vscode
ARG TARGETARCH

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
RUN curl --proto '=https' --tlsv1.2 -fsSL https://setup.atuin.sh | bash \
    && curl -fsSL https://gh.io/copilot-install | bash \
    && curl -fsSL https://claude.ai/install.sh | bash \
    && gh extension install seachicken/gh-poi

COPY --from=ghcr.io/astral-sh/uv:0.12.5 /uv /uvx /bin/


## Stage: ansible — extends base with ansible-dev-tools (ansible-playbook,
## ansible-lint, ansible-navigator, molecule) on PATH.
FROM base AS ansible
LABEL maintainer="sebastian@sommerfeld.io"

ENV ANSIBLE_DEV_TOOLS_VENV=/opt/venvs/ansible-dev-tools
ARG ANSIBLE_DEV_TOOLS_VERSION=26.7.2

USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        libonig-dev \
        python3-dev \
    && uv venv "${ANSIBLE_DEV_TOOLS_VENV}" \
    && uv pip install --python "${ANSIBLE_DEV_TOOLS_VENV}/bin/python" "ansible-dev-tools==${ANSIBLE_DEV_TOOLS_VERSION}" \
    && apt-get purge -y \
        build-essential \
        libonig-dev \
        python3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && chown -R vscode:vscode "${ANSIBLE_DEV_TOOLS_VENV}"

USER vscode
ENV PATH="${ANSIBLE_DEV_TOOLS_VENV}/bin:${PATH}"


## Stage: go — extends base with the Go toolchain, gopls, dlv, and native
## build dependencies for Go development.
FROM base AS go
LABEL maintainer="sebastian@sommerfeld.io"

ARG GO_VERSION=1.26.6
ARG TARGETARCH

USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz" -o /tmp/go.tar.gz \
    && rm -rf /usr/local/go \
    && tar -C /usr/local -xzf /tmp/go.tar.gz \
    && rm /tmp/go.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOBIN=/usr/local/bin

RUN go install golang.org/x/tools/gopls@latest \
    && go install github.com/go-delve/delve/cmd/dlv@latest

USER vscode
