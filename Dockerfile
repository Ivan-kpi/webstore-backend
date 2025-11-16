# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.4.1
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /app

RUN apt-get update -qq && apt-get install --no-install-recommends -y \
  curl build-essential libpq-dev libvips postgresql-client \
  && rm -rf /var/lib/apt/lists/*

ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_WITHOUT="development test"

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bash", "-lc", "rails server -b 0.0.0.0 -p ${PORT:-3000}"]