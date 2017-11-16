FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y ruby ruby-dev ruby-bundler

RUN apt-get install -y build-essential

RUN apt-get install -y zlib1g-dev

WORKDIR /root

RUN gem install google_drive
RUN gem install tenjin
RUN gem install google-api-client
RUN gem install firebase
RUN gem install cloudinary
RUN gem install redcarpet
RUN gem install pry
RUN gem install activesupport
