FROM ruby:2.3.7-alpine

RUN mkdir /inspector && apk add --update build-base libffi-dev

COPY . /inspector

WORKDIR /inspector

RUN gem install bundler && bundle install

ENTRYPOINT ["/usr/local/bin/ruby", "/inspector/inspector.rb"]
