# Concept

- jupyter/vim を用いた普段使いの分析環境
- 自然言語処理のライブラリと Jupyter, vim 等の設定を共通化する
- 深層学習系のライブラリは，このイメージをベースに version ごとに別途イメージを準備する

# How to set up

## build image

```
$ sudo docker build -t miorgash/nlp:latest .
```

## Run

- w/o GPUs

    ```
    cid=`sudo docker run \
            -d \
            -p 8888:8888 \
            --name nlp \
            --restart=always \
            -w=/tmp/work \
            -v $PWD:/tmp/work \
            -v sudachipy:/usr/local/lib/python3.7/dist-packages/sudachipy/resources \
            -v livedoor:/data/livedoor \
            -v chive:/data/chive\
            -v wikientvec:/data/wikientvec \
            miorgash/nlp:latest \
            jupyter notebook --ip="0.0.0.0" --notebook-dir=/tmp/work --allow-root --no-browser`
    echo ${cid:0:12}
    sleep 3
    sudo docker logs ${cid:0:12} 2>&1 | grep "        http"
    ```

- w/GPUs

    ```
    cid=`sudo docker run \
            --gpus all \
            -d \
            -p 8889:8888 \
            --name nlp-gpu \
            --restart=always \
            -w=/tmp/work \
            -v $PWD:/tmp/work \
            -v sudachipy:/usr/local/lib/python3.7/dist-packages/sudachipy/resources \
            -v livedoor:/data/livedoor \
            -v chive:/data/chive\
            -v wikientvec:/data/wikientvec \
            miorgash/nlp-gpu:latest\
            jupyter notebook --ip="0.0.0.0" --notebook-dir=/tmp/work --allow-root --no-browser`
    echo ${cid:0:12}
    sleep 3
    sudo docker logs ${cid:0:12} 2>&1 | grep "        http"
    ```

## Set Sudachidict (if sudachipy/resources directory is mounted)

- `sudo docker exec -it nlp sudachipy link -t core`

## Change font-settings for japanese (OPTIONAL; IPAexGothic by default)

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

- restart jupyter notebook

# How to use
## notebook

1. setup ssh tunnel (from client)

    ```console
    ssh -i ~/.ssh/${YOUR_KEY} -f -NL ${YOUR_PORT}:localhost:8888 ${USER_NAME}@${INSTANCE_IP}
    ```

1. open browser and access `http://localhost:${YOUR_PORT}`, type the password.

## vim w/ssh (from client)

```
vim scp://username@hostname/relative_path_from_home (persistent file)
vim scp://username@hostname//abs_path (persistent file)
```

# How to maintenance
## Adding VOLUME

- Stop container and remove manually
- `docker run` with new volume explicited by `-v` option
- Run container(Look above)

# Appendix
## mecab dict location
```
$ # container 内のものは改めて確認．
$ ls /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-unidic-neologd
```

## Rejected ideas

- Jupyter Kernel によるパッケージの管理
  - docker と jupyter kernel が入れ子になった環境は，変更を加える際に全体を把握するのに時間がかかる（認知コストが高い）
  - 1 つのコンテナ上で複数の環境を保守するとモジュールとして大きくなりすぎる
- コンテナの auto remove
  - 有効とするのが一般的に望ましいが，restart=always が優先
- docker-compose
  - 一人で使うスタンドアロンのコンテナではメンテナンスコスト以上の恩恵を受けられない

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
- amazon-linux docker installation
  - https://download.docker.com/linux/centos/7/$basearch/stable
