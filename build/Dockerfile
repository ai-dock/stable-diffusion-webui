# For build automation - Allows building from any ai-dock base image
# Use a *cuda*base* image as default because pytorch brings the libs
ARG IMAGE_BASE="ghcr.io/ai-dock/python:3.10-v2-cuda-12.1.1-base-22.04"
FROM ${IMAGE_BASE}

LABEL org.opencontainers.image.source https://github.com/ai-dock/stable-diffusion-webui
LABEL org.opencontainers.image.description "Automatic1111 (A1111) Stable Diffusion Web UI docker images for use in GPU cloud and local environments. Includes AI-Dock base for authentication and improved user experience."
LABEL maintainer="Rob Ballantyne <rob@dynamedia.uk>"

ENV WEBUI_VENV=$VENV_DIR/webui
ENV WEBUI_VENV_PYTHON=$WEBUI_VENV/bin/python
ENV WEBUI_VENV_PIP=$WEBUI_VENV/bin/pip

ENV IMAGE_SLUG="stable-diffusion-webui"
ENV OPT_SYNC=stable-diffusion-webui

# Prepare environment
ARG PYTHON_VERSION="3.10"
ENV PYTHON_VERSION="${PYTHON_VERSION}"
ARG PYTORCH_VERSION="2.4.0"
ENV PYTORCH_VERSION="${PYTORCH_VERSION}"
COPY --chown=0:1111 ./COPY_ROOT_0/ /
ARG IMAGE_BASE
RUN set -eo pipefail && /opt/ai-dock/bin/build/layer0/init.sh | tee /var/log/build.log

# Install software
ARG WEBUI_BUILD_REF
ENV WEBUI_BUILD_REF=${WEBUI_BUILD_REF}
COPY --chown=0:1111 ./COPY_ROOT_1/ /
ARG IMAGE_BASE
RUN set -eo pipefail && /opt/ai-dock/bin/build/layer1/init.sh | tee -a /var/log/build.log

# Copy overrides and models into later layers for fast rebuilds
COPY --chown=0:1111 ./COPY_ROOT_99/ /
RUN set -eo pipefail && /opt/ai-dock/bin/build/layer99/init.sh | tee -a /var/log/build.log

ENV PYTHON_DEFAULT_VENV=webui

# Keep init.sh as-is and place additional logic in /opt/ai-dock/bin/preflight.sh
CMD ["init.sh"]
