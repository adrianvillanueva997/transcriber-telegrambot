FROM python:3.11.3-slim-buster as base

ENV PYTHONFAULTHANDLER=1 \
  PYTHONHASHSEED=random \
  PYTHONUNBUFFERED=1
RUN apt-get update && apt-get install -y build-essential python-pkg-resources ffmpeg flac
RUN pip install --upgrade pip &&  pip install poetry

FROM base as prod
WORKDIR /app
COPY . .
RUN poetry install --no-root
EXPOSE 2112
CMD ["make", "prod"]
