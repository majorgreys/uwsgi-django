FROM ubuntu:trusty

WORKDIR /opt/code

ENV PYENV_ROOT="/opt/pyenv" \
    PATH="/opt/pyenv/bin:/opt/pyenv/shims:$PATH" \
    LC_ALL="C.UTF-8" \
    LANG="C.UTF-8"

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        git \
        libbz2-dev \
        libffi-dev \
        libncurses5-dev \
        libncursesw5-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        llvm \
        make \
        netbase \
        pkg-config \
        tk-dev \
        wget \
        xz-utils \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash \
    && pyenv install 2.7.6 \
    && pyenv global 2.7.6

COPY requirements.txt .
RUN pip install -r requirements.txt

RUN git clone https://github.com/gothinkster/django-realworld-example-app project \
    && cd project \
    && pip install -r requirements.txt \
    && python manage.py migrate

COPY uwsgi.ini .
EXPOSE 3000

ENV DATADOG_TRACE_DEBUG true
ENV DATADOG_PATCH_MODULES httplib:false

ENTRYPOINT ["ddtrace-run", "uwsgi", "--ini", "/opt/code/uwsgi.ini"]
