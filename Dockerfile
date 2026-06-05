# 使用官方 Python 运行时作为父镜像
FROM python:3.11-slim

# 设置工作目录
WORKDIR /app

# 安装系统依赖：编译工具和 PortAudio 库（这是 pyaudio 需要的）
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    make \
    libportaudio2 \
    portaudio19-dev \
    && rm -rf /var/lib/apt/lists/*

# 复制项目依赖文件并安装 Python 包
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制项目所有文件
COPY . .

# 设置环境变量（可选，Flask 通用）
ENV FLASK_APP=app.py

# 暴露应用运行的端口（Render 默认会使用 10000）
EXPOSE 10000

# 定义启动命令
CMD ["gunicorn", "-w", "1", "-b", "0.0.0.0:10000", "app:socketio"]