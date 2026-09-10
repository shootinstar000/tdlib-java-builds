#!/bin/bash
set -e

git clone https://github.com/tdlib/td.git
cd td
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
./bootstrap-vcpkg.bat
./vcpkg.exe install openssl:x64-windows zlib:x64-windows
cd ..
rm -rf build
mkdir build
cd build
cmake -A x64 -DCMAKE_INSTALL_PREFIX:PATH=../example/java/td -DTD_ENABLE_JNI=ON -DCMAKE_TOOLCHAIN_FILE:FILEPATH=../vcpkg/scripts/buildsystems/vcpkg.cmake ..
cmake --build . --target install --config Release
cd ..
cd example/java
rm -rf build
mkdir build
cd build
TD_DIR="$(cd ../../../td/build && pwd)"
cmake -A x64 -DCMAKE_INSTALL_PREFIX:PATH=../../../tdlib -DCMAKE_TOOLCHAIN_FILE:FILEPATH=../../../vcpkg/scripts/buildsystems/vcpkg.cmake -DTd_DIR:PATH="$TD_DIR/td/lib/cmake/Td" ..
cmake --build . --target install --config Release
cd ../../..
cd ..
ls -la td/tdlib
