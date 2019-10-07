#!/bin/bash -e

curl -L -o opencv.tar.gz "https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.tar.gz"
mkdir build/
tar -xf opencv.tar.gz -C build/
rm opencv.tar.gz

CV_DIR="build/opencv-${OPENCV_VERSION}"

mkdir -p "${CV_DIR}/build"

ls ${CV_DIR}/platforms/linux/arm-gnueabi.toolchain.cmake
cmake -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_TOOLCHAIN_FILE="../platforms/linux/arm-gnueabi.toolchain.cmake" \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D PYTHON3_INCLUDE_PATH=/usr/include/python3.7m \
    -D PYTHON3_LIBRARIES=/usr/lib/arm-linux-gnueabihf/libpython3.7m.so \
    -D PYTHON3_NUMPY_INCLUDE_DIRS=/usr/lib/python3/dist-packages/numpy/core/include \
    -D BUILD_opencv_python3=ON \
    -D PYTHON3_CVPY_SUFFIX='.cpython-37m-arm-linux-gnueabihf.so' \
    -D ENABLE_NEON=ON \
    -D ENABLE_VFPV3=ON \
    -D WITH_GTK=OFF \
    -D BUILD_DOCS=OFF \
    -D BUILD_EXAMPLES=OFF \
    -D BUILD_TESTS=OFF \
    -D BUILD_PERF_TESTS=OFF \
    -D CPACK_BINARY_DEB:BOOL=ON \
    -D CPACK_GENERATOR="DEB" \
    -D CPACK_DEBIAN_PACKAGE_MAINTAINER="Steven Spangler" \
    -D CPACK_DEBIAN_PACKAGE_NAME="OpenCV" \
    -D CPACK_DEBIAN_PACKAGE_VERSION="${OPENCV_VERSION}" \
    -D CPACK_DEBIAN_PACKAGE_ARCHITECTURE="armhf" \
    -D WITH_GSTREAMER=ON \
    -B "${CV_DIR}/build/" \
    -S "${CV_DIR}"

make -j$(nproc) -C "${CV_DIR}/build/"
# https://askubuntu.com/a/1156304
sed -i 's/set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS "TRUE")//' ${CV_DIR}/build/CPackConfig.cmake
make -C "${CV_DIR}/build/" package

mv "${CV_DIR}"/build/OpenCV-*-python* ../packages/opencv-python_${OPENCV_VERSION}_armhf.deb
mv "${CV_DIR}"/build/OpenCV-*-libs* ../packages/opencv-libs_${OPENCV_VERSION}_armhf.deb
