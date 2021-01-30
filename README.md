## 概要

### 何か
- jupyter/vim を用いた普段使いの分析環境

### 工夫
- 自然言語処理のライブラリと Jupyter, vim 等の設定を共通化する
- 深層学習系のライブラリは，このイメージをベースに version ごとに別途イメージを準備する

### 避けたこと

- Jupyter Kernel によるパッケージの管理（1 つのコンテナ上で複数の環境を保守するとモジュールとして大きくなりすぎる）

## Initialize

### build image

```
$ sudo docker build -t miorgash/nlp:latest .
```

### Run

for ubuntu, osx and other linux
Not working with GPUs (2020.10.5.)

- Using `docker-compose` command:

    ```
    # w/o GPUs
    # docker-compose up -d
    # not yet available

    # w/ GPUs
    # coming soon
    ```

- Using `docker run` command:

    ```
    # w/o GPUs
    # VOLUME はコンテナ内のマウント先ごとに 1 つ用意，1 つずつオプションで指定
    sudo docker run -itd -p 8888:8888 \
        --name nlp \
        --restart=always \
        -v ~/assets:/assets \
        -v sudachipy:/usr/local/lib/python3.7/dist-packages/sudachipy/resources \
        -v livedoor:/data/livedoor \
        -v chive:/data/chive\
        miorgash/nlp:latest

    # w/fever
    # sudo docker run -itd -p 8888:8888 \
    #     --name nlp \
    #     --restart=always \
    #     -v ~/assets:/assets \
    #     -v sudachipy:/usr/local/lib/python3.7/dist-packages/sudachipy/resources \
    #     -v livedoor:/data/livedoor \
    #     -v fever-data:/fever/data \
    #     -v fever-config:/fever/config \
    #     -v fever-logs:/fever/logs \
    #     miorgash/nlp:latest

    # w/ GPUs
    # coming soon
    ```

## Notebook Password
- Login to container:

    ```
    $ sudo docker exec -it nlp /bin/bash
    ```

- Get hashed password:

    ```
    # python3.7 -c 'from notebook.auth import passwd;print(passwd())'
    ```

- Set config:

    ```
    vim ~/.jupyter/jupyter_notebook_config.py
    # edit bellow
    # c.NotebookApp.notebook_dir = '/assets'
    # c.NotebookApp.password = 'your_hashed_password'
    ```

- Logout:

    ```
    # exit
    ```

- Restart

    ```
    sudo docker restart nlp
    ```

### font-settings

- edit config

    ```
    $ vim $(python3.7 -c 'import matplotlib as mlp; print(mlp.matplotlib_fname())')
    # ...
    # # font.family         : sans-serif
    # font.family         : IPAexGothic
    ...
    ```

- remove cache

    ```
    $ rm ~/.cache/matplotlib/fontlist-v310.json
    $ rm -rf ~/.cache/matplotlib/tex.cache
    # and then restart jupyter
    ```

## Set Sudachidict (if sudachipy/resources directory is mounted)

- `sudachipy link -t core`

## Other maintenances
### Adding VOLUME

- stop container (removed automatically)
- `docker run` with new volume explicited by `-v` option
- setting jupyternotebook (look above)

## How to use
### notebook
(Client operation)
1. setup ssh tunnel.

    ```console
    ssh -i ~/.ssh/${YOUR_KEY} -f -NL ${YOUR_PORT}:localhost:8888 ${USER_NAME}@${INSTANCE_IP}
    ```

1. open browser and access `http://localhost:${YOUR_PORT}`, type the password.

### vim w/ssh

```
vim scp://${username}@${hostname}/${path_relative_from_home}
vim scp://${username}@${hostname}//${path_abs}
```

## Memo
### mecab dict location
```
$ # container 内のものは改めて確認．
$ ls /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-unidic-neologd
```

## References
- jupyter in ec2
  - https://qiita.com/t12968yy/items/b6c14f48638060916824
- ssh tunnel
  - https://www.datasciencebytes.com/bytes/2015/12/18/using-jupyter-notebooks-securely-on-remote-linux-machines/
  - https://qiita.com/mechamogera/items/b1bb9130273deb9426f5
- execute tmux as a daemon
  - coming soon
- MeCab on Ubuntu 18.04
  - https://qiita.com/SUZUKI_Masaya/items/685000d569452585210c
