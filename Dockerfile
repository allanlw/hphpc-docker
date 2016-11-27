FROM ubuntu:12.04

RUN apt-get update && apt-get install -y git-core cmake g++ libboost-dev libmysqlclient-dev \
  libxml2-dev libmcrypt-dev libicu-dev openssl build-essential binutils-dev \
  libcap-dev libgd2-xpm-dev zlib1g-dev libtbb-dev libonig-dev libpcre3-dev \
  autoconf libtool libcurl4-openssl-dev libboost-system-dev \
  libboost-program-options-dev libboost-filesystem-dev wget memcached \
  libreadline-dev libncurses-dev libmemcached-dev libbz2-dev \
  libc-client2007e-dev php5-mcrypt php5-imagick libgoogle-perftools-dev \
  libcloog-ppl0 libelf-dev libdwarf-dev libunwind7-dev subversion

COPY source /hphpc

RUN git submodule init && git submodule update --depth=1

ENV CMAKE_PREFIX_PATH=/hphpc HPHP_HOME=/hphpc/hhvm HPHP_LIB=/hphpc/hhvm/bin USE_HHVM=1
WORKDIR /hphpc

RUN cd libevent && \
    patch -p1 < /hphpc/hhvm/hphp/third_party/libevent-1.4.14.fb-changes.diff && \
    ./autogen.sh && \
    ./configure --prefix=$CMAKE_PREFIX_PATH && \
    make && \
    make install

RUN cd curl && \
    ./buildconf && \
    ./configure -prefix=$CMAKE_PREFIX_PATH && \
    make && \
    make install

RUN cd glog && \
    ./configure --prefix=$CMAKE_PREFIX_PATH && \
    make && \
    make install

RUN cd hhvm && \
    git submodule init && \
    git submodule update --depth=1 && \
    cmake . && \
    make


