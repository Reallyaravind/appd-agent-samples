FROM python:3.11-slim

WORKDIR /app
COPY . /app
RUN pip install -r /app/requirements.txt
RUN apt-get update && apt-get install vim nano curl procps wget -y

RUN chmod +x run.sh
RUN chmod +x /app
EXPOSE 8002

ENTRYPOINT [ "sh","./run.sh" ]