FROM python:2.7.15-stretch

RUN apt-get update \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/code

COPY requirements.txt .
COPY uwsgi.ini .

RUN pip install -r requirements.txt

RUN git clone https://github.com/gothinkster/django-realworld-example-app project \
    && cd project \
    && pip install -r requirements.txt \
    && python manage.py migrate

EXPOSE 8080

ENV DATADOG_TRACE_DEBUG true

ENTRYPOINT ["ddtrace-run", "uwsgi", "--ini", "/opt/code/uwsgi.ini"]
