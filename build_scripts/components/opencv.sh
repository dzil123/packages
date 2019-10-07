#!/bin/bash -e

OPENCV_VERSION="4.1.1"
DOCKER="docker"

if ! ${DOCKER} ps >/dev/null 2>&1; then
        DOCKER="sudo docker"
fi
if ! ${DOCKER} ps >/dev/null; then
        echo "error connecting to docker:"
        ${DOCKER} ps
        exit 1
fi

if [ ! -e "cache/opencv-python_${OPENCV_VERSION}_armhf.deb" ]; then
    ${DOCKER} build --rm=false -t opsi-opencv-new opencv-build
    ${DOCKER} run -t -i --rm --privileged \
        --volume "$(pwd)":/packages \
        --name "opencv-build_work" \
        opsi-opencv-new \
        bash -e -o pipefail -c "cd /packages/opencv-build/; OPENCV_VERSION=${OPENCV_VERSION} ./build.sh"
    mkdir -p cache/
    rm -rf cache/*
    cp "packages/opencv-python_${OPENCV_VERSION}_armhf.deb" "cache/opencv-python_${OPENCV_VERSION}_armhf.deb"
    cp "packages/opencv-libs_${OPENCV_VERSION}_armhf.deb" "cache/opencv-libs_${OPENCV_VERSION}_armhf.deb"
else
    cp "cache/opencv-python_${OPENCV_VERSION}_armhf.deb" "packages/opencv-python_${OPENCV_VERSION}_armhf.deb"
    cp "cache/opencv-libs_${OPENCV_VERSION}_armhf.deb" "packages/opencv-libs_${OPENCV_VERSION}_armhf.deb"
fi
