FROM alpine:3.6
MAINTAINER Gabe Ochoa <gabeochoa@gmail.com>

# These are packages we need to build native extensions
ENV BUILD_PACKAGES \
    build-base \
    bzip2-dev \
    curl-dev \
    libffi-dev \
    linux-headers \
    postgresql-dev

# These are packages we actually need at runtime
ENV RUBY_PACKAGES \
    bash \
    file \
    git \
    libbz2 \
    libstdc++ \
    libxml2-dev \
    libxslt-dev \
    ruby-bundler \
    ruby-dev \
    ruby-irb

ENV RUBY_VERSIONED_PACKAGE ruby==2.4.1-r3

WORKDIR /usr/app

# Install our dependencies ahead of adding our code, so that we don't
# re-build the dependencies every time there is a code change
COPY Gemfile /usr/app/
COPY Gemfile.lock /usr/app/

# Packages are added, installed, and any non-runtime dependencies are
# removed to save on container size. These have to be done in 1 RUN step
RUN apk --update add $BUILD_PACKAGES $RUBY_PACKAGES $RUBY_VERSIONED_PACKAGE && \
  gem update --system 2.6.10 --no-ri --no-rdoc && \
  # Nokogiri will try to download dependency packages if not, which will
  # fatten the resulting container. We remove system deps post build.
  bundle config build.nokogiri && \
  bundle install --clean --jobs 4 && \
  # Remove packages not needed at runtime to decrease image size
  apk del $BUILD_PACKAGES && rm -rf /var/cache/apk/*

# Copy in application code
COPY . /usr/app

# Expose port 3000 for web traffic
EXPOSE 3000
