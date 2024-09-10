#!/bin/bash
#
#####################################################################
#
#Author: CCking
#Use Docker
#
#####################################################################

ACCESS_KEY_ID="你的AccessKeyId"
ACCESS_SECRET="你的AccessSecret"
DOMAIN_NAME="example.com"
RR="www"
TYPE="A"

while [[ $# -gt 0 ]];
do
  case $1 in
    -id|-AccessKeyId)
      ACCESS_KEY_ID=$2
      shift
      shift
      ;;
    -secret|-AccessSecret)
      ACCESS_SECRET=$2
      shift
      shift
      ;;
    -domain|-DomainName)
      DOMAIN_NAME=$2
      shift
      shift
      ;;
    -rr|-RR)
      RR=$2
      shift
      shift
      ;;
    -type|-Type)
      TYPE=$2
      shift
      shift
      ;;
    *)
      shift
      shift
    ;;
  esac
done
curl -fsSL https://get.docker.com | sh
docker run -d --restart=always --net=host \
    -e "AKID=$ACCESS_KEY_ID" \
    -e "AKSCT=$ACCESS_SECRET" \
    -e "DOMAIN=$RR.node-is.green" \
    -e "REDO=30" \
    -e "TTL=1" \
    -e "TIMEZONE=8.0" \
    -e "TYPE=A" \
    sanjusss/aliyun-ddns
