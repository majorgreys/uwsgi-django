FROM python:2.7.15-stretch

RUN apt-get update \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/code
RUN pip install uwsgi

WORKDIR /opt/code

RUN git clone https://github.com/gothinkster/django-realworld-example-app app \
    && cd app \
    && pip install -r requirements.txt

COPY uwsgi.ini /etc/uwsgi.ini

EXPOSE 8080

ENTRYPOINT ["uwsgi", "/etc/uwsgi.ini"]
