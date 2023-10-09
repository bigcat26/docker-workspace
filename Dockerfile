FROM ubuntu:22.04
LABEL maintainer="bigcat26@gmail.com"

ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN:zh
ENV LC_ALL zh_CN.UTF-8
ENV TZ=Asia/Shanghai

ARG CMAKE_VERSION=3.27.7
ARG CONAN_VERSION=1.60.2

# Avoid blocking docker build
ARG DEBIAN_FRONTEND=noninteractive

# use aliyun apt mirror
RUN sed -i s/archive\.ubuntu\.com/mirrors\.aliyun\.com/ /etc/apt/sources.list
RUN dpkg --add-architecture i386
RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
    && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
    && apt-get update \
    && apt-get install -qq -y \
    apt-transport-https bc bzip2 ca-certificates cifs-utils clang-tidy clang-tools cpio \
    build-essential curl git git-flow git-lfs iputils-ping jq libc6-i386 libgmp-dev locales lzop make net-tools \
    automake libtool xz-utils openjdk-8-jdk openjdk-11-jdk-headless openjdk-17-jdk-headless \
    openssh-server python3 python3-pip python3-setuptools python-is-python3 \
    silversearcher-ag smbclient software-properties-common squashfs-tools sudo \
    tmux unzip vim wget manpages pkg-config u-boot-tools flex bison gettext \
    gperf libncurses-dev cppcheck zlib1g:i386 telnet docker.io psmisc \
    ninja-build gdb neovim

# golang
#ADD https://dl.google.com/go/go${GOLANG_VERSION}.linux-amd64.tar.gz /opt/

# android sdk
#ADD ${ANDROID_SDK_URL} /opt/

# sdkman
#RUN curl -s "https://get.sdkman.io" | bash
#RUN source "/root/.sdkman/bin/sdkman-init.sh" && sdk install gradle

# add cmake
ADD https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz /opt/
RUN tar -xf /opt/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz -C /opt/ \
    && rm /opt/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz \
    && ln -sf /opt/cmake-${CMAKE_VERSION}-linux-x86_64/bin/cmake /usr/bin/cmake

RUN mkdir -p /var/run/sshd \
    && mkdir -p /run/sshd  \
    && echo 'root:root' | chpasswd \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && locale-gen zh_CN.UTF-8 && dpkg-reconfigure locales \
    && sed -i 's/#*PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
    && pip3 install --upgrade pip \
    && pip install conan==$CONAN_VERSION \
    && conan profile new default --detect \
    && conan profile update settings.compiler.libcxx=libstdc++11 default


CMD ["/usr/sbin/sshd", "-D"]
EXPOSE 22
