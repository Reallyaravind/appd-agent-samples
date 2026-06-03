FROM python:3.9.10-slim-buster
RUN pip install --upgrade pip

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY app.py app.py

ENTRYPOINT [ "python3" , "app.py" ]