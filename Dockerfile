FROM ubuntu:19.04
LABEL maintainer="rc.local@qq.com"

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# use aliyun apt mirror
RUN sed -i s/archive\.ubuntu\.com/mirrors\.aliyun\.com/ /etc/apt/sources.list
RUN apt-get update && apt-get install -qq -y \
    apt-transport-https ca-certificates curl software-properties-common \
    git vim tmux locales unzip bc lzop iputils-ping net-tools wget \
    openjdk-8-jdk python python-pip smbclient cifs-utils \
    cmake rsync jq cppcheck clang-tidy clang-tools \
    squashfs-tools libgmp-dev scons cpio openssh-server

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
