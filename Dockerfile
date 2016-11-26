FROM alpine:3.4
MAINTAINER smizy

ENV OCTAVE_VERSION  4.0.3

RUN set -x \
    && apk update \
    && apk --no-cache add \
        bash \
        ghostscript \
        less \
        python3 \
        su-exec \ 
        tini \
        xvfb \
    && apk --no-cache add  \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ \
#        font-noto \
        gnuplot \
        lapack \
        py3-zmq \
    && apk --no-cache add  \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/main/ \
        fltk \
    && apk --no-cache add \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
        octave \
    && pip3 install --upgrade pip \
    && pip3 install ipywidgets \
    && pip3 install jupyter-console \
    && pip3 install octave_kernel \
    && python3 -m octave_kernel.install \
    && find /usr/lib/python3.5 -name __pycache__ | xargs rm -r \
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

ENTRYPOINT ["tini", "--", "entrypoint.sh"]
CMD ["jupyter", "notebook"]