FROM ruby:3.2.3

RUN mkdir /log-parser
WORKDIR /log-parser

COPY Gemfile Gemfile.lock ./

RUN gem install bundler && bundle install

COPY . .

EXPOSE 3000

CMD ["rails", "server", "-b", "127.0.0.1"]
