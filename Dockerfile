FROM alpine:3.4
MAINTAINER smizy

ENV OCTAVE_VERSION  4.0.3

# ENV JAVA_HOME   /usr/lib/jvm/default-jvm
# ENV PATH        $PATH:${JAVA_HOME}/bin

RUN set -x \
    && apk update \
    && apk --no-cache add \
        bash \
        su-exec \ 
        wget \
    && wget -q -O - ftp://ftp.gnu.org/gnu/octave/octave-${OCTAVE_VERSION}.tar.gz \
        | tar -xzf - -C /tmp \
    && apk --no-cache add \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
 #       arpack \
        graphicsmagick \
        gnuplot \
        hdf5 \
 #       lapack \
        openblas \        
        x11vnc \
    && apk --no-cache add --virtual .builddeps.edge \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
 #       arpack-dev \
        graphicsmagick-dev \       
 #       lapack-dev \
        openblas-dev \
        hdf5-dev \
    && apk --no-cache add \
        curl \
        fftw \
 #       fltk \
        fontconfig \
        gfortran \
        ghostscript \
        glu \
        gperf \
        pcre \
        qt \
        xvfb \
    && apk --no-cache add --virtual .builddeps \
        autoconf \
        automake \
        bison \
        build-base \    
        curl-dev \
        fftw-dev \
        flex \
#        fltk-dev \
        fontconfig-dev \
        ghostscript-dev \
        glu-dev \        
        libtool \
        linux-headers \
        pcre-dev \
        qt-dev \
        readline-dev \
    && cd /tmp/octave-${OCTAVE_VERSION} \
    && ./configure \
        --disable-docs \
        --disable-java \
        --without-fltk \
        --without-glpk \
    && CPUCOUNT=$(cat /proc/cpuinfo | grep '^processor.*:' | wc -l)  \
    && make -j ${CPUCOUNT} \
    && make install \
    && apk del  \
        .builddeps \  
        .builddeps.edge \
    && rm -rf /tmp/octave-${OCTAVE_VERSION} \
    && adduser -D  -g '' -s /sbin/nologin -u 1000 docker \
    && adduser -D  -g '' -s /sbin/nologin octave \
    && mkdir -p /code 

WORKDIR /code
    