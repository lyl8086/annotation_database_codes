#!/bin/bash

read -p "accessKeyID:" id
read -p "accessKeySecret:" key

echo "[default]
language=EN
accessKeyID=$id
accessKeySecret=$key
region=cn-qingdao
" >myoss.conf

