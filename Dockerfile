FROM ruby:2.3-slim

RUN apt-get update && \
    apt-get install -qq -y \
    build-essential \
    nodejs \
    libpq-dev \
    postgresql-client \
    --fix-missing --no-install-recommends

ENV HOME /root
ENV APP_HOME /app
RUN mkdir $APP_HOME
ADD Gemfile* $APP_HOME/

RUN gem install bundler --no-ri --no-rdoc && \
    cd $APP_HOME; bundle install --without development test

EXPOSE 9292

WORKDIR $APP_HOME
