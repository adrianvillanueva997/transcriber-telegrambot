<<<<<<< HEAD
FROM python:3.11.3-slim-buster as base

ENV PYTHONFAULTHANDLER=1 \
  PYTHONHASHSEED=random \
  PYTHONUNBUFFERED=1
RUN apt-get update && apt-get install -y build-essential python-pkg-resources ffmpeg flac
RUN pip install --upgrade pip &&  pip install poetry

FROM base as prod
||||||| parent of b8cb279 (updated Dockerfile)
FROM python:3.11.2-slim-buster as base

ENV PYTHONFAULTHANDLER=1 \
  PYTHONHASHSEED=random \
  PYTHONUNBUFFERED=1
RUN apt-get update && apt-get install -y build-essential python-pkg-resources ffmpeg flac
RUN pip install --upgrade pip &&  pip install poetry

FROM base as prod
=======
# Build stage
FROM python:3.11.2 AS build
>>>>>>> b8cb279 (updated Dockerfile)
WORKDIR /app
COPY pyproject.toml poetry.lock ./
RUN pip install --upgrade pip && pip install poetry
RUN poetry install --no-dev --no-root

# Runtime stage
FROM python:3.11.2-slim-buster AS runtime
WORKDIR /app
RUN apt-get update && apt-get install -y ffmpeg flac && rm -rf /var/lib/apt/lists/*
COPY --from=build /app /app
EXPOSE 2112
CMD ["make", "prod"]
