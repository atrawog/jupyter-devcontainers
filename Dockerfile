# syntax=docker/dockerfile:1.2

ARG BASE_IMAGE=debian:bookworm-slim
FROM --platform=$BUILDPLATFORM $BASE_IMAGE AS fetch
ARG VERSION=1.5.3

RUN  rm -f /etc/apt/apt.conf.d/docker-*
RUN --mount=type=cache,target=/var/cache/apt,id=apt-deb12 apt-get update && apt-get install -y --no-install-recommends bzip2 ca-certificates curl

RUN if [ "$BUILDPLATFORM" = 'linux/arm64' ]; then \
        export ARCH='aarch64'; \
    else \
        export ARCH='64'; \
    fi; \
    curl -L "https://micro.mamba.pm/api/micromamba/linux-${ARCH}/${VERSION}" | \
    tar -xj -C "/tmp" "bin/micromamba"


FROM --platform=$BUILDPLATFORM $BASE_IMAGE as micromamba

ARG MAMBA_ROOT_PREFIX="/opt/conda"
ARG MAMBA_EXE="/bin/micromamba"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV MAMBA_ROOT_PREFIX=$MAMBA_ROOT_PREFIX
ENV MAMBA_EXE=$MAMBA_EXE
ENV PATH="${PATH}:${MAMBA_ROOT_PREFIX}/bin"

COPY --from=fetch /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=fetch /tmp/bin/micromamba "$MAMBA_EXE"

ARG MAMBA_USER=jovian
ARG MAMBA_USER_ID=1000
ARG MAMBA_USER_GID=1000

ENV MAMBA_USER=$MAMBA_USER
ENV MAMBA_USER_ID=$MAMBA_USER_ID
ENV MAMBA_USER_GID=$MAMBA_USER_GID

RUN groupadd -g "${MAMBA_USER_GID}" "${MAMBA_USER}" && \
    useradd -m -u "${MAMBA_USER_ID}" -g "${MAMBA_USER_GID}" -s /bin/bash "${MAMBA_USER}"
RUN mkdir -p "${MAMBA_ROOT_PREFIX}/environments" && \
    chown "${MAMBA_USER}:${MAMBA_USER}" "${MAMBA_ROOT_PREFIX}"

USER root
ARG CONTAINER_WORKSPACE_FOLDER=/workspaces/jupyter-devcontainers
RUN mkdir -p "${CONTAINER_WORKSPACE_FOLDER}"
WORKDIR "${CONTAINER_WORKSPACE_FOLDER}"

USER $MAMBA_USER
RUN micromamba shell init --shell bash --prefix=$MAMBA_ROOT_PREFIX
SHELL ["/bin/bash", "--rcfile", "/$MAMBA_USER/.bashrc", "-c"]



FROM micromamba AS python

COPY --chown=$MAMBA_USER:$MAMBA_USER environments/env_python.yml /opt/conda/environments/env_python.yml
RUN --mount=type=cache,target=$MAMBA_ROOT_PREFIX/pkgs,id=mamba-pkgs  micromamba install -y -f /opt/conda/environments/env_python.yml


FROM python AS jupyter

COPY --chown=$MAMBA_USER:$MAMBA_USER environments/env_jupyter.yml /opt/conda/environments/env_jupyter.yml 
RUN --mount=type=cache,target=$MAMBA_ROOT_PREFIX/pkgs,id=mamba-pkgs  micromamba install -y -f /opt/conda/environments/env_jupyter.yml 


FROM jupyter AS jupyter-ai

COPY --chown=$MAMBA_USER:$MAMBA_USER environments/env_ai.yml /opt/conda/environments/env_ai.yml 
RUN --mount=type=cache,target=$MAMBA_ROOT_PREFIX/pkgs,id=mamba-pkgs  micromamba install -y -f /opt/conda/environments/env_ai.yml 


FROM jupyter-ai AS jupyter-spatial

COPY --chown=$MAMBA_USER:$MAMBA_USER environments/env_spatial.yml /opt/conda/environments/env_spatial.yml 
RUN --mount=type=cache,target=$MAMBA_ROOT_PREFIX/pkgs,id=mamba-pkgs  micromamba install -y -f /opt/conda/environments/env_spatial.yml 


FROM jupyter-spatial AS jupyter-ansible

COPY --chown=$MAMBA_USER:$MAMBA_USER environments/env_ansible.yml /opt/conda/environments/env_ansible.yml 
RUN --mount=type=cache,target=$MAMBA_ROOT_PREFIX/pkgs,id=mamba-pkgs  micromamba install -y -f /opt/conda/environments/env_ansible.yml 


FROM jupyter-ansible as jupyter-devel

USER root
COPY --chown=$MAMBA_USER:$MAMBA_USER environments/pkgs_devel.txt /opt/conda/environments/pkgs_devel.txt
RUN --mount=type=cache,target=/var/cache/apt,id=apt-deb12 apt-get update && xargs apt-get install -y < /opt/conda/environments/pkgs_devel.txt

RUN touch /var/lib/dpkg/status && install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg
RUN echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && apt-get update
RUN --mount=type=cache,target=/var/cache/apt,id=apt-deb12 apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

RUN usermod -aG sudo $MAMBA_USER
RUN echo "$MAMBA_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY .devcontainer/fix-permissions.sh /bin/fix-permissions.sh
RUN chmod +x /bin/fix-permissions.sh && \
    echo 'export MAMBA_USER_ID=$(id -u)' >> /home/$MAMBA_USER/.bashrc && \
    echo 'export MAMBA_USER_GID=$(id -g)' >> /home/$MAMBA_USER/.bashrc && \
    echo "/bin/fix-permissions.sh" >> /home/$MAMBA_USER/.bashrc && \
    echo "micromamba activate" >> /home/$MAMBA_USER/.bashrc

USER $MAMBA_USER

RUN ansible-galaxy install geerlingguy.docker
RUN pip install molecule-qemu
