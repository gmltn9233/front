#!/bin/bash
set -e  # 오류 발생 시 스크립트 즉시 종료

# 설정
REGION="ap-northeast-2"
REPOSITORY="195275652706.dkr.ecr.${REGION}.amazonaws.com"
IMAGE_NAME="${REPOSITORY}/frontend:latest"
CONTAINER_NAME="frontend"

echo "[INFO] Stop & remove previous container if exists..."
docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true

echo "[INFO] Logging in to ECR..."
aws ecr get-login-password --region $REGION \
  | docker login --username AWS --password-stdin $REPOSITORY

echo "[INFO] Pulling latest image from ECR..."
docker pull $IMAGE_NAME

echo "[INFO] Running new container..."
docker run -d --name $CONTAINER_NAME -p 80:80 $IMAGE_NAME

echo "[SUCCESS] Deployment complete!"
