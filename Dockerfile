FROM alpine:3.4
MAINTAINER smizy

ENV OCTAVE_VERSION  4.0.3

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
        less \
        pcre \
        qt-x11 \
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


# install conda/jupyter
ENV CONDA_DIR=/opt/conda CONDA_VER=4.0.5
ENV PATH=$CONDA_DIR/bin:$PATH SHELL=/bin/bash LC_ALL=C LANG=C.UTF-8

RUN set -x \
    && curl -L "https://github.com/andyshinn/alpine-pkg-glibc/releases/download/2.23-r1/glibc-2.23-r1.apk" -o /tmp/glibc.apk \
    && curl -L "https://github.com/andyshinn/alpine-pkg-glibc/releases/download/2.23-r1/glibc-bin-2.23-r1.apk" -o /tmp/glibc-bin.apk \
    && curl -L "https://github.com/andyshinn/alpine-pkg-glibc/releases/download/2.23-r1/glibc-i18n-2.23-r1.apk" -o /tmp/glibc-i18n.apk \
    && apk add --allow-untrusted /tmp/glibc*.apk \
    && /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib \
    && /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 C.UTF-8 \
    && rm -rf /tmp/glibc*apk /var/cache/apk/* \
    && mkdir -p $CONDA_DIR \
    && curl https://repo.continuum.io/miniconda/Miniconda3-${CONDA_VER}-Linux-x86_64.sh  -o mconda.sh \
    && /bin/bash mconda.sh -f -b -p $CONDA_DIR \
    && rm mconda.sh \
    && conda install --yes \
        ipywidgets \
        'notebook=4.0*' \
        terminado \
    && pip install pip --upgrade \
    && pip install octave_kernel \
    && pip install jupyter-console \
    && python -m octave_kernel.install \
    && conda clean --yes --tarballs --packages --source-cache \     
    && find /opt -name __pycache__ | xargs rm -r \
    && rm -rf \
        /opt/conda/pkgs/* \
        /root/.[acpw]* \
    && apk --no-cache add \
        tini 

WORKDIR /code

COPY entrypoint.sh  /usr/local/bin/
COPY jupyter_notebook_config.py ./

EXPOSE 8888

ENTRYPOINT ["tini", "--", "entrypoint.sh"]
CMD ["jupyter", "notebook"]