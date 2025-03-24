#!/bin/bash

# 설정
IMAGE_NAME="195275652706.dkr.ecr.ap-northeast-2.amazonaws.com/frontend:latest"

# 기존 컨테이너 정리
docker stop frontend || true
docker rm frontend || true

# ECR 로그인
aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 195275652706.dkr.ecr.ap-northeast-2.amazonaws.com

# 이미지 pull & run
docker pull $IMAGE_NAME
docker run -d --name frontend -p 80:80 $IMAGE_NAME
