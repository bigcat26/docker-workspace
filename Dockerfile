FROM ubuntu:19.04
MAINTAINER bigcat <bigcatfeed@gmail.com>

ARG NODEJS_VERSION="11"
ARG GOLANG_VERSION="1.11.4"
ARG ANDROID_SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"
ARG JDK_DOWNLOAD_URL="https://download.java.net/java/GA/jdk11/7/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz"
ARG TOOLCHAIN_BASEURL="http://cylan-tools.oss-cn-shenzhen.aliyuncs.com/toolchain"
#ARG TOOLCHAIN_BASEURL="http://cylan-tools.oss-cn-shenzhen-internal.aliyuncs.com/toolchain"

RUN echo "GOLANG_VERSION: ${GOLANG_VERSION}" && \
    echo "TOOLCHAIN_BASEURL: ${TOOLCHAIN_BASEURL}" && \

#
# prepare base enviroument
#
COPY sources.list/mirrors.aliyun.com.xenial /etc/apt/sources.list
RUN dpkg --add-architecture i386
RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
    && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
    && apt-get update && apt-get install -y \
	apt-transport-https bc bzip2 ca-certificates cifs-utils clang-tidy clang-tools cmake \
	cpio cppcheck ctags curl git iputils-ping jq libc6-i386 libgmp-dev locales lzop make \
	net-tools openjdk-8-jdk openssh-server python python-pip python-setuptools rsync scons \
	silversearcher-ag smbclient software-properties-common squashfs-tools sudo tmux unzip vim \
	vim-nox-py2 wget

# golang
#ADD https://dl.google.com/go/go${GOLANG_VERSION}.linux-amd64.tar.gz /opt/

# rk1108 toolchain depends
#ADD ${TOOLCHAIN_BASEURL}/rk1108-toolchain.tar.bz2 /opt/
RUN ln -s /usr/lib/x86_64-linux-gnu/libmpfr.so.6 /usr/lib/x86_64-linux-gnu/libmpfr.so.4

# cc3200 toolchain
#ADD ${TOOLCHAIN_BASEURL}/cc3200-linux-toolchain.tar.bz2 /opt/

# fh8620 toolchain
#ADD ${TOOLCHAIN_BASEURL}/fh8620-linux-toolchain.tar.bz2 /opt/

# jdk
#ADD ${JDK_DOWNLOAD_URL} /opt/

# android sdk
#ADD ${ANDROID_SDK_URL} /opt/

# sdkman
#RUN curl -s "https://get.sdkman.io" | bash
#RUN source "/root/.sdkman/bin/sdkman-init.sh" && sdk install gradle

#
# setup ssh & root & locales
#
RUN mkdir -p /var/run/sshd \
    && sed -i 's/PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN echo 'root:root' | chpasswd
RUN locale-gen en_US.UTF-8

CMD ["/usr/sbin/sshd", "-D"]
EXPOSE 22
