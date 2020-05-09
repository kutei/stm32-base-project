#!/usr/bin/env bash
function get_full_path(){
    DIR=$(dirname $1)
    PREFIX=$(cd ${DIR} && pwd)
    echo "${PREFIX}/`basename $1`"
}

function main(){
    SRC_DIR="."
    BUILD_DIR="./build"
    INSTALL_DIR="./install"
    TOOLCHAIN="./cmake/arm-none-eabi-gcc_toolchain.cmake"

    if [ ! -d "${BUILD_DIR}" ]; then
        mkdir ${BUILD_DIR}
    fi
    if [ ! -d "${INSTALL_DIR}" ]; then
        mkdir ${INSTALL_DIR}
    fi

    SRC_PREFIX=$(cd ${SRC_DIR} && pwd)
    BUILD_PREFIX=$(cd ${BUILD_DIR} && pwd)
    INSTALL_PREFIX=$(cd ${INSTALL_DIR} && pwd)
    TOOLCHAIN_PATH=$(get_full_path ${TOOLCHAIN})

    echo "======================================"
    echo "source    :${SRC_PREFIX}"
    echo "build     :${BUILD_PREFIX}"
    echo "install   :${INSTALL_PREFIX}"
    echo "toolchain :${TOOLCHAIN_PATH}"
    echo "======================================"

    cd $BUILD_PREFIX
    cmake ${SRC_PREFIX} -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_PATH} -DCMAKE_BINARY_DIR=${BUILD_PREFIX} -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX}
    make install
}

main $@
