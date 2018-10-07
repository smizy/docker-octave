FROM alpine:3.8

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL \
    maintainer="smizy" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.license="Apache License 2.0" \
    org.label-schema.name="smizy/octave" \
    org.label-schema.url="https://github.com/smizy" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-type="Git" \
    org.label-schema.version=$VERSION \
    org.label-schema.vcs-url="https://github.com/smizy/docker-octave"

ENV OCTAVE_VERSION  ${VERSION:-"4.2.0"}

RUN set -x \
    && apk update \
    && apk --no-cache add \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/main/ \
        libgfortran \ 
        readline \
    && apk --no-cache add \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ \
        lapack \ 
    && apk --no-cache add \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
        octave \
    && apk --no-cache add \
        bash \
        fltk \
        ghostscript \
        gnuplot \
        less \
        python3 \
        py3-zmq \
        su-exec \ 
        tini \
        xvfb \
    && pip3 install --upgrade pip \
    && pip3 install ipywidgets \
    && pip3 install jupyter-console \
    && pip3 install octave_kernel \
    && find /usr/lib/python3.6 -name __pycache__ | xargs rm -r \
    && rm -rf /root/.[acpw]* \
    ## dir/user
    && mkdir -p /etc/jupyter \
    && adduser -D  -g '' -s /sbin/nologin -u 1000 docker \
    && adduser -D  -g '' -s /sbin/nologin octave \
    && adduser -D  -g '' -s /sbin/nologin jupyter 

WORKDIR /code

COPY entrypoint.sh  /usr/local/bin/
COPY jupyter_notebook_config.py /etc/jupyter/

EXPOSE 8888

ENTRYPOINT ["/sbin/tini", "--", "entrypoint.sh"]
CMD ["jupyter", "notebook"]