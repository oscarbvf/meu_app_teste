# syntax=docker/dockerfile:1

# Define Ruby version
ARG RUBY_VERSION=3.3.8
FROM ruby:$RUBY_VERSION-slim AS base

# Aplication path inside the conteiner
WORKDIR /rails

# Install basic packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        build-essential libpq-dev curl libjemalloc2 libvips sqlite3 git && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Config environment to bundler
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Build stage to reduce final image size
FROM base AS build

# Install other packages to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Copy Gemfile and Gemfile.lock and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap to speed Rails boot
RUN bundle exec bootsnap precompile app/ lib/

# Adjust binay files to Linux
RUN chmod +x bin/* && \
    sed -i "s/\r$//g" bin/* && \
    sed -i 's/ruby\.exe$/ruby/' bin/*

# Final image
FROM base

# Copy gems and application code
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Create rails user and define permissions
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

# Use non root user
USER 1000:1000

# Define absolute entrypoint
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Expose port 3000 to Rails
EXPOSE 3000

# Default command to start Rails server
CMD ["bash", "-c", "bundle exec rails server -b 0.0.0.0 -p 3000"]
