# 1단계: React 앱 빌드
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build


# 2단계: nginx를 이용해 빌드 결과 서빙
FROM nginx:alpine

# 빌드된 파일을 nginx html 폴더로 복사
COPY --from=builder /app/build /usr/share/nginx/html

# nginx 포트 개방
EXPOSE 80

# nginx 실행
CMD ["nginx", "-g", "daemon off;"]