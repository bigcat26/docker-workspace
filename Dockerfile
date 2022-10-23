FROM ubuntu:22.04
LABEL maintainer="rc.local@qq.com"

# Chinese support
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN:zh
ENV LC_ALL zh_CN.UTF-8
ENV TZ=Asia/Shanghai

# Avoid blocking docker build
ARG DEBIAN_FRONTEND=noninteractive

# use aliyun apt mirror
RUN sed -i s/archive\.ubuntu\.com/mirrors\.aliyun\.com/ /etc/apt/sources.list
RUN dpkg --add-architecture i386
RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
    && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
    && apt-get update \
	&& apt-get install -qq -y \
	apt-transport-https bc bzip2 ca-certificates cifs-utils clang-tidy clang-tools cmake cpio \
	curl git git-flow git-lfs iputils-ping jq libc6-i386 libgmp-dev locales lzop make net-tools \
	automake libtool xz-utils openjdk-8-jdk openssh-server python3 python3-pip python3-setuptools \
    silversearcher-ag smbclient software-properties-common squashfs-tools sudo tmux unzip vim manpages \
    libncurses-dev wget gcc bison flex fakeroot gettext cppcheck zlib1g:i386 


# golang
#ADD https://dl.google.com/go/go${GOLANG_VERSION}.linux-amd64.tar.gz /opt/

# android sdk
#ADD ${ANDROID_SDK_URL} /opt/

# sdkman
#RUN curl -s "https://get.sdkman.io" | bash
#RUN source "/root/.sdkman/bin/sdkman-init.sh" && sdk install gradle

RUN mkdir -p /var/run/sshd \
    && mkdir -p /run/sshd  \
    && echo 'root:root' | chpasswd \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && locale-gen zh_CN.UTF-8 && dpkg-reconfigure locales \
    && sed -i 's/#*PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
    && pip3 install --upgrade pip \
    && pip3 install conan

CMD ["/usr/sbin/sshd", "-D"]
EXPOSE 22
