# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.4.1
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /app

# ----- System deps -----
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    postgresql-client \
    libvips \
    git && \
    rm -rf /var/lib/apt/lists/*

ENV RAILS_ENV=production \
    BUNDLE_WITHOUT="development:test" \
    BUNDLE_PATH=/bundle

# ----- Install gems -----
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 4 --retry 3

# ----- Copy app -----
COPY . .

# Precompile bootsnap
RUN bundle exec bootsnap precompile --gemfile app/ lib/

# ----- Assets precompile (if needed) -----
# RUN bundle exec rails assets:precompile

# ----- Final Stage -----
FROM ruby:$RUBY_VERSION-slim AS final

WORKDIR /app

# Install runtime-only deps
RUN apt-get update && apt-get install -y \
    libpq5 libvips && \
    rm -rf /var/lib/apt/lists/*

ENV RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=true \
    BUNDLE_PATH=/bundle

COPY --from=base /bundle /bundle
COPY --from=base /app /app

EXPOSE 3000

CMD ["bash", "-lc", "rails server -b 0.0.0.0 -p ${PORT:-3000}"]