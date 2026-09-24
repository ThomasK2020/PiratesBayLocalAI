FROM python:3.11-slim

WORKDIR /app

ENV PYTHONUNBUFFERED=1

# Installation de Node.js 20 LTS, Git, Curl et outils de build
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    build-essential \
    ca-certificates \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt || true

RUN mkdir -p /app/workspace

VOLUME ["/app/workspace"]

CMD ["tail", "-f", "/dev/null"]
