#!/bin/bash
set -e

rm -rf model && mkdir model
cd model
wget https://download.01.org/opencv/2020/openvinotoolkit/2020.2/open_model_zoo/models_bin/2/age-gender-recognition-retail-0013/FP32/age-gender-recognition-retail-0013.bin
wget https://download.01.org/opencv/2020/openvinotoolkit/2020.2/open_model_zoo/models_bin/2/age-gender-recognition-retail-0013/FP32/age-gender-recognition-retail-0013.xml
