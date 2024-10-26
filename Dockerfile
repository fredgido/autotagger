FROM python:3.12-slim-bullseye
ENV PYTHONUNBUFFERED 1

ENV SHELL /bin/bash

ENV MODEL swin
ARG MODEL

WORKDIR /project

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y wget && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir models
COPY supported_models.json supported_models.json
RUN python -c 'import json,os;j=json.load(open("supported_models.json"));print(j[os.getenv("MODEL")]["model_url"]);print(j[os.getenv("MODEL")]["tags_url"])' | wget -P models -i -

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

WORKDIR /project

EXPOSE ${PORT:-8000}/tcp

CMD gunicorn
