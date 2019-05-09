FROM ruby:2.6.2-alpine

ARG BUNDLE_ARGS="--without development test"

RUN mkdir /my-application
COPY Gemfile /my-application/Gemfile
COPY Gemfile.lock /my-application/Gemfile.lock
WORKDIR /my-application

RUN apk --no-cache add mariadb-dev && \
    apk --no-cache add --virtual build-dependencies linux-headers ruby-dev libxml2-dev libxslt-dev build-base && \
    bundle config build.nokogiri --use-system-libraries && \
    bundle install --jobs=4 --retry=3 $BUNDLE_ARGS && \
    apk del build-dependencies

COPY . /my-application

ENTRYPOINT /my-application/scripts/entrypoint.sh
