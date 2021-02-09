#!/bin/bash
OCCLUM_LINKER=/opt/occlum/glibc/lib/ld-linux-x86-64.so.2

THREADING=TBB
set -e

show_usage() {
    echo
    echo "Usage: $0 [--threading <TBB/OMP>]"
    echo
    exit 1
}

# Build OpenVINO
build_openvino() {
    rm -rf openvino_src && mkdir openvino_src
    pushd openvino_src
    git clone https://github.com/openvinotoolkit/openvino.git .
    git checkout tags/2020.2 -b 2020.2
    git submodule init
    git submodule update --recursive
    mkdir build && cd build
#   Substitute THREADING lib
    cmake ../ \
      -DTHREADING=$THREADING \
      -DENABLE_MKL_DNN=ON \
      -DENABLE_CLDNN=OFF \
      -DENABLE_MYRIAD=OFF \
      -DENABLE_GNA=OFF
    make -j16
    popd
}

while [ -n "$1" ]; do
    case "$1" in
    --threading)    [ -n "$2" ] && THREADING=$2 ; shift 2 || show_usage ;;
    *)
        show_usage
    esac
done

# Tell CMake to search for packages in Occlum toolchain's directory only
export PKG_CONFIG_LIBDIR=$PREFIX/lib

if [ "$THREADING" == "TBB" ] ; then
    echo "Build OpenVINO with TBB threading"
    build_openvino
elif [ "$THREADING" == "OMP" ] ; then
    echo "Build OpenVINO with OpenMP threading"
    build_openvino
else
    echo "Error: invalid threading: $THREADING"
    show_usage
fi
