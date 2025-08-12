#!/bin/bash

INPUT_CMAKE_PATH="/input/CMakeLists.txt"
INPUT_SH_PATH="/input/compile.sh"
INPUT_CPP_PATH="/input/main.cpp"
OUTPUT_BINARY_DIR="/opt/devkitpro/portlibs/wiiu"
OUTPUT_BINARY_NAME="wiiu_smb_test.rpx"
OUTPUT_DIR="/output/build"

rm -rf $OUTPUT_DIR
mkdir -p "$OUTPUT_DIR"

cp "$INPUT_CMAKE_PATH" /app/CMakeLists.txt
cp "$INPUT_CPP_PATH" /app/main.cpp

cd /app
rm -rf build
mkdir -p build
cd build/
cmake -DCMAKE_TOOLCHAIN_FILE=/opt/devkitpro/cmake/WiiU.cmake ..
make
make install

cp "$OUTPUT_BINARY_DIR/$OUTPUT_BINARY_NAME" "$OUTPUT_DIR/$OUTPUT_BINARY_NAME"
