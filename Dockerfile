# syntax=docker/dockerfile:1 

ARG RUBY_VERSION=3.2.9
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    libyaml-dev \
    git \
    curl \
    postgresql-client && \
    rm -rf /var/lib/apt/lists/*

RUN gem install bundler -v 2.7.2

COPY Gemfile Gemfile.lock ./

RUN bundle _2.7.2_ config set without 'development test' && \
    bundle _2.7.2_ install --jobs 4 --retry 3

COPY . .

EXPOSE 3000

CMD ["sh", "-c", "bundle exec rails server -b 0.0.0.0 -p $PORT"]
