# Define Ruby version and base image
ARG RUBY_VERSION=3.3.4
FROM ruby:$RUBY_VERSION-slim AS base

# Set environment variables
ENV BUNDLER_VERSION=2.5.21 \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test" \
    WORKDIR=/app_name

# Set working directory
WORKDIR $WORKDIR

# Install essential packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips libpq-dev && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# Throw-away build stage to install build dependencies and precompile assets
FROM base AS build

# Install build dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git pkg-config && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# Copy the entire app context for multi-engine projects
COPY . .

# Install gems with bundle
RUN gem install bundler -v "$BUNDLER_VERSION" && \
    bundle install && \
    rm -rf "$BUNDLE_PATH/ruby/*/bundler/gems/*/.git"

# Precompile bootsnap and assets for production
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec bootsnap precompile app/ lib/ && \
    SECRET_KEY_BASE_DUMMY=1 RAILS_ENV=production ./bin/rails assets:precompile

# Final stage for runtime
FROM base AS final

# Copy over built gems, app code, and assets
COPY --from=build $BUNDLE_PATH $BUNDLE_PATH
COPY --from=build $WORKDIR $WORKDIR

# Entrypoint and command setup
ENTRYPOINT ["./bin/docker-entrypoint"]
EXPOSE 80
CMD ["./bin/thrust", "./bin/rails", "server"]
