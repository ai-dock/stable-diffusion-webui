#!/bin/false

# This file will be sourced in init.sh

# https://raw.githubusercontent.com/ai-dock/stable-diffusion-webui/main/config/provisioning/get-models-sd-official.sh
printf "\n##############################################\n#                                            #\n#          Provisioning container            #\n#                                            #\n#         This will take some time           #\n#                                            #\n# Your container will be ready on completion #\n#                                            #\n##############################################\n\n"
function download() {
    wget -q --show-progress --progress=dot -e dotbytes="${3:-4M}" -O "$2" "$1"
}
# Download Stable Diffusion official models
webui_dir=/opt/stable-diffusion-webui
models_dir=${webui_dir}/models
sd_models_dir=${models_dir}/Stable-diffusion
extensions_dir=${webui_dir}/extensions
cn_models_dir=${extensions_dir}/sd-webui-controlnet/models
vae_models_dir=${models_dir}/VAE
upscale_models_dir=${models_dir}/ESRGAN

printf "Downloading extensions..."
cd $extensions_dir

# Controlnet
printf "Setting up Controlnet...\n"
if [[ -d sd-webui-controlnet ]]; then
    (cd sd-webui-controlnet && \
        git pull && \
        micromamba run -n webui ${PIP_INSTALL} -r requirements.txt
    )
else
    (git clone https://github.com/Mikubill/sd-webui-controlnet && \
         micromamba run -n webui ${PIP_INSTALL} -r sd-webui-controlnet/requirements.txt
    )
fi

# Dreambooth
printf "Setting up Dreambooth...\n"
if [[ -d sd_dreambooth_extension ]]; then
    (cd sd_dreambooth_extension && \
        git pull && \
        micromamba run -n webui ${PIP_INSTALL} -r requirements.txt
    )
else
    (git clone https://github.com/d8ahazard/sd_dreambooth_extension && \
        micromamba run -n webui ${PIP_INSTALL} -r sd_dreambooth_extension/requirements.txt
    )
fi

# Dynamic Prompts
printf "Setting up Dynamic Prompts...\n"
if [[ -d sd-dynamic-prompts ]]; then
    (cd sd-dynamic-prompts && git pull)
else
    git clone https://github.com/adieyal/sd-dynamic-prompts.git
fi

# Face Editor
printf "Setting up Face Editor...\n"
if [[ -d sd-face-editor ]]; then
    (cd sd-face-editor && git pull)
else
    git clone https://github.com/ototadana/sd-face-editor.git
fi

# Image Browser
printf "Setting up Image Browser...\n"
if [[ -d stable-diffusion-webui-images-browser ]]; then
    (cd stable-diffusion-webui-images-browser && git pull)
else
    git clone https://github.com/yfszzx/stable-diffusion-webui-images-browser
fi

# Regional Prompter
printf "Setting up Regional Prompter...\n"
if [[ -d sd-webui-regional-prompter ]]; then
    (cd sd-webui-regional-prompter && git pull)
else
    git clone https://github.com/hako-mikan/sd-webui-regional-prompter.git
fi

# Regional Prompter
printf "Setting up Ultimate Upscale...\n"
if [[ -d ultimate-upscale-for-automatic1111 ]]; then
    (cd ultimate-upscale-for-automatic1111 && git pull)
else
    git clone https://github.com/Coyote-A/ultimate-upscale-for-automatic1111
fi

printf "Downloading official SD models..."

# v1-5-pruned-emaonly
model_file=${sd_models_dir}/v1-5-pruned-emaonly.ckpt
model_url=https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.ckpt

if [[ ! -e ${model_file} ]]; then
    printf "Downloading Stable Diffusion 1.5...\n"
    download ${model_url} ${model_file}
fi

# v2-1_768-ema-pruned
model_file=${sd_models_dir}/v2-1_768-ema-pruned.ckpt
model_url=https://huggingface.co/stabilityai/stable-diffusion-2-1/resolve/main/v2-1_768-ema-pruned.ckpt

if [[ ! -e ${model_file} ]]; then
    printf "Downloading Stable Diffusion 2.1...\n"
    download ${model_url} ${model_file}
fi

# sd_xl_base_1
model_file=${sd_models_dir}/sd_xl_base_1.0.safetensors
model_url=https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors

if [[ ! -e ${model_file} ]]; then
    printf "Downloading Stable Diffusion XL base...\n"
    download ${model_url} ${model_file} 
fi

# sd_xl_refiner_1
model_file=${sd_models_dir}/sd_xl_refiner_1.0.safetensors
model_url=https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-1.0/resolve/main/sd_xl_refiner_1.0.safetensors

if [[ ! -e ${model_file} ]]; then
    printf "Downloading Stable Diffusion XL refiner...\n"
    download ${model_url} ${model_file}
fi

printf "Downloading a few pruned controlnet models...\n"

model_file=${cn_models_dir}/control_canny-fp16.safetensors
model_url=https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_canny-fp16.safetensors

if [[ ! -e ${model_file} ]]; then
    printf "Downloading Canny...\n"
    download ${model_url} ${model_file}
fi

model_file=${cn_models_dir}/control_depth-fp16.safetensors
model_url=https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_depth-fp16.safetensors

if [[ ! -e ${model_file} ]]; then
    printf "Downloading Depth...\n"
    download ${model_url} ${model_file}
fi

model_file=${cn_models_dir}/control_openpose-fp16.safetensors
model_url=https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_openpose-fp16.safetensors

if [[ ! -e ${model_file} ]]; then
    printf "Downloading Openpose...\n"
    download ${model_url} ${model_file}
fi

model_file=${cn_models_dir}/control_scribble-fp16.safetensors
model_url=https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_scribble-fp16.safetensors

if [[ ! -e ${model_file} ]]; then
    printf "Downloading Scribble...\n"
    download ${model_url} ${model_file}
fi

printf "Downloading VAE...\n"

model_file=${vae_models_dir}/vae-ft-ema-560000-ema-pruned.safetensors
model_url=https://huggingface.co/stabilityai/sd-vae-ft-ema-original/resolve/main/vae-ft-ema-560000-ema-pruned.safetensors

if [[ ! -e ${model_file} ]]; then
    printf "Downloading vae-ft-ema-560000-ema...\n"
    download ${model_url} ${model_file}
fi

model_file=${vae_models_dir}/vae-ft-ema-560000-ema-pruned.safetensors
model_url=https://huggingface.co/stabilityai/sd-vae-ft-ema-original/resolve/main/vae-ft-ema-560000-ema-pruned.safetensors

if [[ ! -e ${model_file} ]]; then
    printf "Downloading vae-ft-ema-560000-ema...\n"
    download ${model_url} ${model_file}
fi

model_file=${vae_models_dir}/vae-ft-mse-840000-ema-pruned.safetensors
model_url=https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors

if [[ ! -e ${model_file} ]]; then
    printf "Downloading vae-ft-mse-840000-ema...\n"
    download ${model_url} ${model_file}
fi

model_file=${vae_models_dir}/sdxl_vae.safetensors
model_url=https://huggingface.co/stabilityai/sdxl-vae/resolve/main/sdxl_vae.safetensors

if [[ ! -e ${model_file} ]]; then
    printf "Downloading sdxl_vae...\n"
    download ${model_url} ${model_file}
fi

printf "Downloading Upscalers...\n"

model_file=${upscale_models_dir}/4x_foolhardy_Remacri.pth
model_url=https://huggingface.co/FacehugmanIII/4x_foolhardy_Remacri/resolve/main/4x_foolhardy_Remacri.pth

if [[ ! -e ${model_file} ]]; then
    printf "Downloading 4x_foolhardy_Remacri...\n"
    download ${model_url} ${model_file}
fi

model_file=${upscale_models_dir}/4x_NMKD-Siax_200k.pth
model_url=https://huggingface.co/Akumetsu971/SD_Anime_Futuristic_Armor/resolve/main/4x_NMKD-Siax_200k.pth

if [[ ! -e ${model_file} ]]; then
    printf "Downloading 4x_NMKD-Siax_200k...\n"
    download ${model_url} ${model_file}
fi

model_file=${upscale_models_dir}/RealESRGAN_x4.pth
model_url=https://huggingface.co/ai-forever/Real-ESRGAN/resolve/main/RealESRGAN_x4.pth

if [[ ! -e ${model_file} ]]; then
    printf "Downloading RealESRGAN_x4...\n"
    download ${model_url} ${model_file}
fi


