FROM python:3.8

WORKDIR /backend

COPY requirements.txt requirements.txt
RUN pip install --upgrade pip
RUN pip3 install -r requirements.txt

COPY . /backend

EXPOSE 5000

CMD [ "gunicorn","--workers","4","-b", "0.0.0.0:5000", "app:app" ]
