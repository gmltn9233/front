#!/bin/bash
set -e  # 오류 발생 시 스크립트 즉시 종료

# 설정
REGION="ap-northeast-2"
REPOSITORY="195275652706.dkr.ecr.${REGION}.amazonaws.com"
IMAGE_NAME="${REPOSITORY}/frontend:latest"
CONTAINER_NAME="frontend"
PORT=80

# 포트 점유 여부 확인 및 종료
if lsof -i :$PORT &>/dev/null; then
  echo "[WARNING] Port $PORT is already in use. Stopping existing container using it..."
  CONTAINER_ID=$(docker ps --filter "publish=$PORT" --format "{{.ID}}")
  if [ -n "$CONTAINER_ID" ]; then
    docker stop "$CONTAINER_ID"
    docker rm "$CONTAINER_ID"
  fi
fi

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
