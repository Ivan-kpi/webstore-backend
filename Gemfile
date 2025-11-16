# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.2.9
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    postgresql-client \
    curl && \
    rm -rf /var/lib/apt/lists/*

ENV RAILS_ENV=production
ENV RACK_ENV=production
ENV BUNDLE_PATH=/usr/local/bundle

COPY Gemfile Gemfile.lock ./

RUN bundle install --without development test

COPY . .

RUN bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]

