# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.4.2
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /app

# --------------------------
# 1) Install OS packages
# --------------------------
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    curl \
    git \
    bash \
    libvips42 \
    && rm -rf /var/lib/apt/lists/*

# --------------------------
# 2) Install gems
# --------------------------
COPY Gemfile Gemfile.lock ./
RUN bundle install

# --------------------------
# 3) Copy app code
# --------------------------
COPY . .

# --------------------------
# 4) Precompile bootsnap
# --------------------------
RUN bundle exec bootsnap precompile --gemfile app/ lib/

# --------------------------
# 5) Expose port & start Rails
# Railway injects PORT
# --------------------------
EXPOSE 3000

CMD ["bash", "-lc", "rails db:migrate && rails s -b 0.0.0.0 -p $PORT"]