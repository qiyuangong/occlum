#!/bin/bash
benchmark=benchmark_app
inference_bin=openvino_src/inference-engine/bin/intel64/Release
occlum_glibc=/opt/occlum/glibc/lib/
set -e

# 1. Init Occlum Workspace
rm -rf occlum_instance
mkdir occlum_instance
cd occlum_instance
occlum init
new_json="$(jq '.resource_limits.user_space_size = "320MB" |
                .process.default_mmap_size = "256MB"' Occlum.json)" && \
echo "${new_json}" > Occlum.json

# 2. Copy files into Occlum Workspace and Build
cp ../$inference_bin/$benchmark image/bin
cp ../$inference_bin/lib/libinference_engine.so image/lib
cp ../$inference_bin/lib/libformat_reader.so image/lib
cp ../$inference_bin/lib/libcpu_extension.so image/lib
cp ../$inference_bin/lib/libHeteroPlugin.so image/lib
cp ../$inference_bin/lib/libMKLDNNPlugin.so image/lib
cp ../$inference_bin/lib/plugins.xml image/lib


cp $occlum_glibc/libz.so.1 image/$occlum_glibc
mkdir image/model
cp -r ../model/* image/model
occlum build

# 3. Run benchmark
occlum run /bin/$benchmark -m /model/age-gender-recognition-retail-0013.xml
