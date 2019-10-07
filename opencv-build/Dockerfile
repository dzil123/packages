FROM opsi-opencv-pre:latest

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture armhf
RUN apt-get -y update && \
    apt-get -y install \
        git vim parted \
        quilt coreutils debootstrap qemu-user-static zerofree zip dosfstools \
        bsdtar libcap2-bin rsync grep udev xz-utils curl xxd file kmod\
        python3-dev python3.7-dev python3-numpy libpython3.7-dev:armhf\
        libtiff-dev:armhf zlib1g-dev:armhf libjpeg-dev:armhf libpng-dev:armhf libavcodec-dev:armhf libavformat-dev:armhf libswscale-dev:armhf libv4l-dev:armhf libxvidcore-dev:armhf libx264-dev:armhf \
        crossbuild-essential-armhf gfortran-arm-linux-gnueabihf cmake pkg-config \
        gstreamer1.0-rtsp gstreamer1.0-plugins-bad gstreamer1.0-omx \
        libgstreamer1.0-dev libgstrtspserver-1.0-dev gstreamer-1.0 \
        libgstreamer1.0-0 \
        gstreamer1.0-plugins-base \
        gstreamer1.0-plugins-good \
        gstreamer1.0-plugins-bad \
        gstreamer1.0-plugins-ugly \
        gstreamer1.0-libav \
        gstreamer1.0-doc \
        gstreamer1.0-tools \
        libgstreamer1.0-dev \
        libgstreamer-plugins-base1.0-dev \
    && rm -rf /var/lib/apt/lists/*
