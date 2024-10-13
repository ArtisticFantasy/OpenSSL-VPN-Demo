#!/bin/bash
source $(dirname $0)/env_check.sh || exit 1

# Make trusted directory
if [ ! -d $PROJ_DIR/trusted ]; then
    mkdir $PROJ_DIR/trusted
fi

# Generate certificate files
if [ ! -d $PROJ_DIR/certs ]; then
    $PROJ_DIR/gen_certs.sh
fi

# Build sources
cd $PROJ_DIR
rm -rf build
mkdir build
cd build
cmake -DOPENSSL_DIR=$OPENSSL_DIR .. || exit 1

if [ "$OS_TYPE" == "Linux" ]; then
    make -j`nproc` || exit 1
elif [ "$OS_TYPE" == "Darwin" ]; then
    make -j`sysctl -n hw.ncpu` || exit 1
fi
