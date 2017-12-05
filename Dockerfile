FROM ubuntu:16.04
MAINTAINER bigcat <bigcatfeed@gmail.com>

#
# prepare base enviroument
#
COPY sources.list/mirrors.aliyun.com.xenial /etc/apt/sources.list
RUN dpkg --add-architecture i386
RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
    && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
    #&& apt-get update \
    && apt-get install -y libc6-i386 openssh-server vim vim-nox-py2 sudo net-tools ca-certificates unzip bzip2 git openssh-server python python-setuptools python-pip ctags locales make cmake silversearcher-ag jq

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
