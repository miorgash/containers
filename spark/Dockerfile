FROM ubuntu:18.04
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
RUN mkdir /tmp/downloads && \
    mkdir /tmp/work
WORKDIR /tmp/downloads
RUN apt install wget -y && \
    apt install openjdk-8-jdk -y && \
    echo 'JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"' >> /etc/environment && \
    echo 'source /etc/environment' >> ~/.bashrc
RUN wget https://dlcdn.apache.org/spark/spark-3.2.0/spark-3.2.0-bin-hadoop3.2.tgz && \
    tar -xvf spark-3.2.0-bin-hadoop3.2.tgz && \
    echo 'export SPARK_HOME=/tmp/downloads/spark-3.2.0-bin-hadoop3.2' >> ~/.bashrc && \
    echo 'export PATH=$PATH:$SPARK_HOME/bin' >> ~/.bashrc && \
    echo 'export PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.9.2-src.zip:$PYTHONPATH' >> ~/.bashrc && \
    echo 'export PYSPARK_PYTHON=python3' >> ~/.bashrc && \
    echo 'export PATH=$PATH:$JAVA_HOME/jre/bin' >> ~/.bashrc
WORKDIR /tmp/work
