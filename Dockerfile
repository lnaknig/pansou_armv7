name: Build ARMv7 Image

on:
  push:
    branches: [ "main" ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up QEMU
        uses: docker/setup-qemu-action@v3

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Build and push
        uses: docker/build-push-action@v6 # 2025年使用 v6 版本
        with:
          context: .
          # 同时构建 amd64 和 arm/v7 以提高兼容性
          platforms: linux/amd64,linux/arm/v7 
          push: true
          tags: ${{ secrets.DOCKERHUB_USERNAME }}/pansou:latest
          # 关键：确保 build-args 传递正确（由 buildx 自动处理）
