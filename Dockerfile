# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.2.9
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /app

# Install system dependencies for Rails + PostgreSQL + Psych
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    libyaml-dev \
    git \
    curl \
    postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Install Bundler to match Gemfile.lock
RUN gem install bundler -v 2.7.2

# Copy Gemfiles first to install gems
COPY Gemfile Gemfile.lock ./

RUN bundle install --jobs 4 --retry 3

# Copy the rest of the app
COPY . .

# Expose port Railway will use
EXPOSE 3000

# Run the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]


