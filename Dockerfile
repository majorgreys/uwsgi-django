FROM python:2.7.15-stretch

RUN apt-get update \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/code

WORKDIR /opt/code

COPY requirements.txt .
RUN pip install -r requirements.txt

RUN git clone https://github.com/gothinkster/django-realworld-example-app app \
    && cd app \
    && pip install -r requirements.txt

COPY uwsgi.ini /etc/uwsgi.ini

EXPOSE 8080

ENTRYPOINT ["uwsgi", "--ini", "/etc/uwsgi.ini"]
