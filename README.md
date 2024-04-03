[![Docker Build](https://github.com/ai-dock/stable-diffusion-webui/actions/workflows/docker-build.yml/badge.svg)](https://github.com/ai-dock/stable-diffusion-webui/actions/workflows/docker-build.yml)

# Stable Diffusion WebUI Docker Image

Run [Automatic1111 WebUI](https://github.com/AUTOMATIC1111/stable-diffusion-webui) in a docker container locally or in the cloud.

>[!NOTE]  
>These images do not bundle models or third-party configurations. You should use a [provisioning script](#provisioning-script) to automatically configure your container. You can find examples in `config/provisioning`.

## Documentation

All AI-Dock containers share a common base which is designed to make running on cloud services such as [vast.ai](https://link.ai-dock.org/vast.ai) and [runpod.io](https://link.ai-dock.org/template) as straightforward and user friendly as possible.

Common features and options are documented in the [base wiki](https://github.com/ai-dock/base-image/wiki) but any additional features unique to this image will be detailed below.


#### Version Tags

The `:latest` tag points to `:latest-cuda`

Tags follow these patterns:

##### _CUDA_
- `:pytorch-[pytorch-version]-py[python-version]-cuda-[x.x.x]-base-[ubuntu-version]`

- `:latest-cuda` &rarr; `:pytorch-2.2.0-py3.10-cuda-11.8.0-base-22.04`

- `:latest-cuda-jupyter` &rarr; `:jupyter-pytorch-2.2.0-py3.10-cuda-11.8.0-base-22.04`

##### _ROCm_
- `:pytorch-[pytorch-version]-py[python-version]-rocm-[x.x.x]-runtime-[ubuntu-version]`

- `:latest-rocm` &rarr; `:pytorch-2.2.0-py3.10-rocm-5.7-runtime-22.04`

- `:latest-rocm-jupyter` &rarr; `:jupyter-pytorch-2.2.0-py3.10-rocm-5.7-runtime-22.04`

##### _CPU_
- `:pytorch-[pytorch-version]-py[python-version]-ubuntu-[ubuntu-version]`

- `:latest-cpu` &rarr; `:pytorch-2.2.0-py3.10-cpu-22.04` 

- `:latest-cpu-jupyter` &rarr; `:jupyter-pytorch-2.2.0-py3.10-cpu-22.04` 

Browse [here](https://github.com/ai-dock/stable-diffusion-webui/pkgs/container/stable-diffusion-webui) for an image suitable for your target environment.

Supported Python versions: `3.10`

Supported Pytorch versions: `2.2.0`, `2.1.2`

Supported Platforms: `NVIDIA CUDA`, `AMD ROCm`, `CPU`

## Additional Environment Variables

| Variable                 | Description |
| ------------------------ | ----------- |
| `AUTO_UPDATE`            | Update A1111 Web UI on startup (default `true`) |
| `WEBUI_BRANCH`           | WebUI branch/commit hash. (default `master`) |
| `WEBUI_FLAGS`            | Startup flags. eg. `--no-half` |
| `WEBUI_PORT_HOST`        | Web UI port (default `7860`) |
| `WEBUI_URL`              | Override `$DIRECT_ADDRESS:port` with URL for Web UI |

See the base environment variables [here](https://github.com/ai-dock/base-image/wiki/2.0-Environment-Variables) for more configuration options.

### Additional Micromamba Environments

| Environment    | Packages |
| -------------- | ----------------------------------------- |
| `webui`        | AUTOMATIC1111 WebUI and dependencies |

This micromamba environment will be activated on shell login.

See the base micromamba environments [here](https://github.com/ai-dock/base-image/wiki/1.0-Included-Software#installed-micromamba-environments).


## Additional Services

The following services will be launched alongside the [default services](https://github.com/ai-dock/base-image/wiki/1.0-Included-Software) provided by the base image.

### Stable Diffusion WebUI

The service will launch on port `7860` unless you have specified an override with `WEBUI_PORT`.

WebUI will be updated to the latest version on container start. You can pin the version to a branch or commit hash by setting the `WEBUI_BRANCH` variable.

You can set startup flags by using variable `WEBUI_FLAGS`.

To manage this service you can use `supervisorctl [start|stop|restart] webui`.

>[!NOTE]
>All services are password protected by default. See the [security](https://github.com/ai-dock/base-image/wiki#security) and [environment variables](https://github.com/ai-dock/base-image/wiki/2.0-Environment-Variables) documentation for more information.


## Pre-Configured Templates

**Vast.​ai**

- [A1111 WebUI:latest](https://link.ai-dock.org/template-vast-sd-webui)

- [A1111 WebUI:latest-jupyter](https://link.ai-dock.org/template-vast-sd-webui-jupyter)

---

**Runpod.​io**

- [A1111 WebUI:latest](https://link.ai-dock.org/template-runpod-sd-webui)

- [A1111 WebUI:latest-jupyter](https://link.ai-dock.org/template-runpod-sd-webui-jupyter)

---

_The author ([@robballantyne](https://github.com/robballantyne)) may be compensated if you sign up to services linked in this document. Testing multiple variants of GPU images in many different environments is both costly and time-consuming; This helps to offset costs_