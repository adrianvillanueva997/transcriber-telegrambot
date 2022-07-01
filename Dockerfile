FROM python:3.8.13-slim-buster as base

ENV PYTHONFAULTHANDLER=1 \
    PYTHONHASHSEED=random \
    PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y build-essential ffmpeg flac
WORKDIR /app

FROM base as builder

ENV PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    POETRY_VERSION=1.1.13

RUN pip install --upgrade pip && pip install "poetry==$POETRY_VERSION"
RUN python -m venv /venv

COPY pyproject.toml poetry.lock ./
COPY Makefile .
RUN make installdeps

COPY . .
RUN make poetrybuild

FROM base as final

COPY --from=builder /venv /venv
COPY --from=builder /app/dist .

RUN  make installwhl
CMD ["make", "prod"]