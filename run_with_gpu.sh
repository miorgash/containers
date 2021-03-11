#!/bin/bash

cid=`docker run \
	--gpus all \
	-v $PWD:/tmp/work \
	-w=/tmp/work \
	-p 8888:8080 \
	-d nlp jupyter notebook --no-browser --ip="0.0.0.0" --notebook-dir=/tmp/work --allow-root`
echo ${cid:0:12}
sleep 3
docker logs ${cid:0:12} 2>&1 | grep "        http"
