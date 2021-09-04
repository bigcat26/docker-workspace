FROM ubuntu:21.04
LABEL maintainer="rc.local@qq.com"

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# use aliyun apt mirror
RUN sed -i s/archive\.ubuntu\.com/mirrors\.aliyun\.com/ /etc/apt/sources.list
RUN dpkg --add-architecture i386
RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
    && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
    && apt-get update \
	&& apt-get install -qq -y \
	apt-transport-https bc bzip2 ca-certificates cifs-utils clang-tidy clang-tools cmake cpio \
	cppcheck ctags curl git iputils-ping jq libc6-i386 libgmp-dev locales lzop make net-tools \
	openjdk-8-jdk openssh-server python python-pip python-setuptools rsync scons silversearcher-ag \
	smbclient software-properties-common squashfs-tools sudo tmux unzip vim wget

# Chinese support
RUN locale-gen zh_CN.UTF-8 && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN:zh
ENV LC_ALL zh_CN.UTF-8

# golang
#ADD https://dl.google.com/go/go${GOLANG_VERSION}.linux-amd64.tar.gz /opt/

RUN ln -s /usr/lib/x86_64-linux-gnu/libmpfr.so.6 /usr/lib/x86_64-linux-gnu/libmpfr.so.4

# android sdk
#ADD ${ANDROID_SDK_URL} /opt/

# sdkman
#RUN curl -s "https://get.sdkman.io" | bash
#RUN source "/root/.sdkman/bin/sdkman-init.sh" && sdk install gradle

RUN mkdir -p /var/run/sshd \
    && mkdir -p /run/sshd  \
    && echo 'root:root' | chpasswd \
    && sed -i 's/PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN locale-gen en_US.UTF-8

CMD ["/usr/sbin/sshd", "-D"]
EXPOSE 22
