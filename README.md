# 目的・利用方針

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

Using `docker run` command:

```
$ # for ubuntu, osx and other linux
$ sudo docker run -itd -p 8888:8888 -v ~/assets:/var/assets --restart=always --name nlp miorgash/nlp:latest
$ # With data container
$ sudo docker run -itd -p 8888:8888 -v ~/assets:/var/assets --volumes-from fever-common --restart=always --name nlp miorgash/nlp:latest
# ! docker-compose is not available for running the container with GPUs is not stable.
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
c.NotebookApp.password = '$hashed_password'
c.NotebookApp.notebook_dir = '/var/assets'
```

Logout:

```
# exit
```

Restart

```
sudo docker restart nlp
```


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
