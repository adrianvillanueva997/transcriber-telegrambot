FROM python:3.11.0rc2-slim-buster as base

ENV PYTHONFAULTHANDLER=1 \
    PYTHONHASHSEED=random \
    PYTHONUNBUFFERED=1
RUN apt-get update && apt-get install -y build-essential ffmpeg flac && pip install --upgrade pip

FROM base as poetry
ENV PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    POETRY_VERSION=1.1.13
RUN  pip install "poetry==$POETRY_VERSION"

FROM poetry as prod
WORKDIR /app
COPY . .
RUN make installdeps
EXPOSE 2112
CMD ["make", "prod"]