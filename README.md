# What is it?

- jupyter でのレポート作成（深層学習関連以外の汎用的なライブラリを汎用化するため＆見た目の設定を汎用化するため）
- Python パッケージはカーネルで管理する．（コンテナを作るのはオーバーヘッドが大きいので忌避）
- コンテナ化する理由
    - 可搬性

# Initialize

## build image

```
$ sudo docker build -t miorgash/nlp:latest .
```

## Run

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
	miorgash/nlp:latest

    # w/ GPUs
    # coming soon
    ```


## Notebook settings

Login to container:

```
$ sudo docker exec -it nlp /bin/bash
```

Get hashed password:

```
# python3.7 -c 'from notebook.auth import passwd;print(passwd())'
```

Set config:

```~/.jupyter/jupyter_notebook_config.py
c.NotebookApp.notebook_dir = '/assets'
c.NotebookApp.password = '$hashed_password'
```

Logout:

```
# exit
```

Restart

```
sudo docker restart nlp
```

# Sudachidict (if sudachipy/resources directory is mounted)

- `sudachipy link -t core`

# Adding VOLUME

- stop container (removed automatically)
- `docker run` with new volume explicited by `-v` option
- setting jupyternotebook (look above)


# How to use
## notebook
(Client operation)
1. setup ssh tunnel.

    ```console
    ssh -i ~/.ssh/${YOUR_KEY} -f -NL ${YOUR_PORT}:localhost:8888 ${USER_NAME}@${INSTANCE_IP}
    ```

1. open browser and access `http://localhost:${YOUR_PORT}`, type the password.

## vim through ssh

```
vim scp://${username}@${hostname}/${path_relative_from_home}
vim scp://${username}@${hostname}//${path_abs}
```

# Memo
## mecab dict location
```
$ # container 内のものは改めて確認．
$ ls /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-unidic-neologd
```

# References
- jupyter in ec2
  - https://qiita.com/t12968yy/items/b6c14f48638060916824
- ssh tunnel
  - https://www.datasciencebytes.com/bytes/2015/12/18/using-jupyter-notebooks-securely-on-remote-linux-machines/
  - https://qiita.com/mechamogera/items/b1bb9130273deb9426f5
- execute tmux as a daemon
  - coming soon

- MeCab on Ubuntu 18.04
  - https://qiita.com/SUZUKI_Masaya/items/685000d569452585210c
