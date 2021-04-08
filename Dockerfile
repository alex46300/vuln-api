FROM python:3-alpine

COPY . /app
WORKDIR /app
RUN apk update \
    && apk add gcc musl-dev libffi-dev openssl-dev \
    && pip install --no-cache-dir -r requirements.txt \
    && python api/create-sqlite-db.py 

EXPOSE 5000
CMD [ "python", "api/api-sqlite.py" ]