#!/bin/false

# This file will be sourced in init.sh

# https://raw.githubusercontent.com/ai-dock/stable-diffusion-webui/main/config/provisioning/get-models-sd-official.sh

# Download Stable Diffusion official models

models_dir=/opt/stable-diffusion-webui/models
checkpoints_dir=${models_dir}/Stable-diffusion

# v1-5-pruned-emaonly
model_file=${checkpoints_dir}/v1-5-pruned-emaonly.ckpt
model_url=https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.ckpt

if [[ ! -e ${model_file} ]]; then
    printf "Downloading Stable Diffusion 1.5...\n"
    wget -q -O ${model_file} ${model_url}
fi

# v2-1_768-ema-pruned
model_file=${checkpoints_dir}/v2-1_768-ema-pruned.ckpt
model_url=https://huggingface.co/stabilityai/stable-diffusion-2-1/resolve/main/v2-1_768-ema-pruned.ckpt

if [[ ! -e ${model_file} ]]; then
    printf "Downloading Stable Diffusion 2.1...\n"
    wget -q -O ${model_file} ${model_url}
fi

# sd_xl_base_1
model_file=${checkpoints_dir}/sd_xl_base_1.0.safetensors
model_url=https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors

if [[ ! -e ${model_file} ]]; then
    printf "Downloading Stable Diffusion XL base...\n"
    wget -q -O ${model_file} ${model_url}
fi

# sd_xl_refiner_1
model_file=${checkpoints_dir}/sd_xl_refiner_1.0.safetensors
model_url=https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-1.0/resolve/main/sd_xl_refiner_1.0.safetensors

if [[ ! -e ${model_file} ]]; then
    printf "Downloading Stable Diffusion XL refiner...\n"
    wget -q -O ${model_file} ${model_url}
fi

