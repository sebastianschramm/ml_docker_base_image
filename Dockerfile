FROM python:3-alpine3.6

LABEL maintainer="Sebastian Schramm"

RUN apk update

# Switch timezone to France
RUN apk --no-cache add tzdata && \
    cp /usr/share/zoneinfo/Europe/Paris /etc/localtime && \
    echo "Europe/Paris" > /etc/timezone && \
    apk del tzdata

# hack to keep container small
RUN apk add --no-cache gcc linux-headers musl-dev libstdc++ lapack g++ gfortran && \
    apk add --no-cache --virtual .builddeps build-base ca-certificates cmake lapack-dev && \
    pip3 install --no-cache-dir asyncpg==0.15.0 && \
    pip3 install --no-cache-dir lightgbm==2.1.2 && \
    apk del gcc linux-headers musl-dev g++ gfortran

# Install dependencies
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
