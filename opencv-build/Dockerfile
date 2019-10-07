FROM opsi-opencv:latest

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture armhf && \
    apt-get -y update && \
    apt-get -y install \
        gstreamer1.0-rtsp:armhf gstreamer1.0-plugins-bad:armhf gstreamer1.0-omx:armhf \
        libgstreamer1.0-dev:armhf libgstrtspserver-1.0-dev:armhf gstreamer-1.0:armhf \
        libgstreamer1.0-0:armhf \
        gstreamer1.0-plugins-base:armhf \
        gstreamer1.0-plugins-good:armhf \
        gstreamer1.0-plugins-bad:armhf \
        gstreamer1.0-plugins-ugly:armhf \
        gstreamer1.0-libav:armhf \
        gstreamer1.0-doc:armhf \
        gstreamer1.0-tools:armhf \
        libgstreamer1.0-dev:armhf \
        libgstreamer-plugins-base1.0-dev:armhf \
    && rm -rf /var/lib/apt/lists/*
