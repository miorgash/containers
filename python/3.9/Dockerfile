FROM ubuntu:20.04
RUN : "essential" && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install sudo apt-utils vim git -y && \
    : "japanese setting for os" && \
    apt-get install -y language-pack-ja-base language-pack-ja && \
    : "japanese setting for jupyter" && \
    apt-get install -y fonts-ipaexfont
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia
RUN : "python" && \
    apt-get install python3.9 python3.9-venv python3-pip -y && \
    python3.9 -m pip install -U pip && \
    : "required by mecab-python3, Tensorflow etc." && \
    apt install swig -y && \
    python3.9 -m pip install wheel && \
    python3.9 -m pip install -U setuptools && \
    python3.9 -m pip install -U six
ENV LANG=ja_JP.UTF-8
