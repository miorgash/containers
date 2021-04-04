FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04
RUN : "essential" && \
    apt update -y && \
    apt upgrade -y && \
    apt install sudo apt-utils vim git -y && \
    : "japanese setting for os" && \
    apt-get install -y language-pack-ja-base language-pack-ja && \
    : "japanese setting for jupyter" && \
    sudo apt-get install -y fonts-ipaexfont && \
    : "python" && \
    apt install python3.7 python3.7-dev python3-pip python3.7-venv -y && \
    python3.7 -m pip install -U pip && \
    : "required by mecab-python3, Tensorflow etc." && \
    apt install swig -y && \
    python3.7 -m pip install wheel && \
    python3.7 -m pip install -U setuptools && \
    python3.7 -m pip install -U six
ENV LANG=ja_JP.UTF-8
RUN : "image peculiar settings" && \
    : "MeCab and dictionaries": && \
    apt install mecab libmecab-dev mecab-ipadic-utf8 -y && \
    apt install unidic-mecab -y && \
    : "update-alternatives --config mecab-dictionary # interactive check command" && \
    apt install git make curl xz-utils file unzip -y && \
    git clone --depth 1 https://github.com/neologd/mecab-unidic-neologd /tmp/mecab-unidic-neologd
WORKDIR /tmp/mecab-unidic-neologd
RUN ./bin/install-mecab-unidic-neologd -n -y
COPY ./requirements.txt /var/requirements.txt
RUN : "Default kernel" && \
    pip install -U pip && \
    pip install -r /var/requirements.txt && \
    pip install git+https://github.com/miurahr/pykakasi
RUN : "jupyter setting" && \
    mkdir -p ~/.jupyter/custom
COPY ./custom.css /root/.jupyter/custom/custom.css
COPY ./matplotlibrc /usr/local/lib/python3.7/dist-packages/matplotlib/mpl-data/matplotlibrc
RUN : "create dir" && \
    mkdir -p /data/
