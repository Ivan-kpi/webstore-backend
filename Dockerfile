# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.2.9
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /app

# Install required system packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    libyaml-dev \
    git \
    curl \
    postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Install Bundler (Rails 8 requires 2.7.x)
RUN gem install bundler -v 2.7.2

# Copy Ruby files
COPY Gemfile Gemfile.lock ./

# Install production gems (important for Railway)
RUN bundle _2.7.2_ config set without 'development test' && \
    bundle _2.7.2_ install --jobs 4 --retry 3

# Copy the Rails app
COPY . .

# Expose internal port
EXPOSE 3000

# Start Rails correctly for Railway
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "${PORT:-3000}"]

