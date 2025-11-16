FROM ruby:3.2.9

WORKDIR /app

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs postgresql-client

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the app
COPY . .

# Railway needs a PORT ENV
ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true
ENV PORT=3000

# Precompile assets (if any)
RUN bundle exec rails assets:precompile || true

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]