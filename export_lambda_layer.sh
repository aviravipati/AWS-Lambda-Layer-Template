#!/bin/ksh
docker compose up -d  --build
docker cp awslambdalayertemplate-python-layer-1:/layer/layer_content.zip ./python-layer.zip