FROM ruby:2.5

RUN gem update --system --quiet && gem install  bundler -v '~> 2.1'
ENV BUNDLER_VERSION 2.2
RUN bundle config --global frozen 1
WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
EXPOSE 4567
CMD ["ruby", "herrschwarz.rb"]
