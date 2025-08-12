#!/bin/bash

docker build -t cpp-runtime-compiler-image .
docker run --rm \
    -v "$(pwd)/main.cpp:/input/main.cpp" \
    -v "$(pwd)/CMakeLists.txt:/input/CMakeLists.txt" \
    -v "$(pwd):/output" \
    cpp-runtime-compiler-image
