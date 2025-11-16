# syntax=docker/dockerfile:1
# check=error=true

# Make sure RUBY_VERSION matches your .ruby-version
ARG RUBY_VERSION=3.4.7
FROM ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libjemalloc2 \
    libvips \
    postgresql-client && \
    ln -s /usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Production environment variables
ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT="development test" \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so"

# ---------- BUILD STAGE ----------
FROM base AS build

# Install packages for building gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libpq-dev \
    libyaml-dev \
    pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Copy application
COPY . .

# Precompile bootsnap
RUN bundle exec bootsnap precompile app/ lib/

# Precompile Rails assets
RUN bundle exec rails assets:precompile RAILS_ENV=production

# ---------- FINAL IMAGE ----------
FROM base

# Create non-root user
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash
USER 1000:1000

# Copy gems + app from build stage
COPY --chown=rails:rails --from=build /usr/local/bundle /usr/local/bundle
COPY --chown=rails:rails --from=build /rails /rails

# Entrypoint (handles DB setup)
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Railway exposes dynamic port
EXPOSE 3000

# 🔥 IMPORTANT — Railway compatible command
CMD ["bash", "-lc", "bin/rails server -b 0.0.0.0 -p ${PORT:-3000}"]