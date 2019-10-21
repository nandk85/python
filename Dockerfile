FROM python:3.6

ARG DEBIAN_FRONTEND=noninteractive

# Install tools required to build the project
RUN apt-get update
RUN apt-get install --assume-yes apt-utils
RUN apt-get install --assume-yes vim apt-transport-https unzip

RUN pip install filemagic wheel pycurl selenium flask flask_sqlalchemy flask_bcrypt flask_login flask_uploads celery flask_wtf flask-marshmallow marshmallow-sqlalchemy
RUN pip install jsonschema requests scp paramiko tavern pytest

# install chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && apt-get -qqy install google-chrome-stable \
  && rm /etc/apt/sources.list.d/google-chrome.list \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# install chromdriver
RUN wget -N http://chromedriver.storage.googleapis.com/$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip -P ~/ \
  && unzip ~/chromedriver_linux64.zip -d ~/ \
  && rm ~/chromedriver_linux64.zip \
  && mv -f ~/chromedriver /usr/local/bin/chromedriver \
  && chown root:root /usr/local/bin/chromedriver \
  && chmod 0755 /usr/local/bin/chromedriver

CMD "/bin/bash"
