FROM ruby:2.7.2
RUN apt-get update -qq \
	&& apt-get install -y libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb

WORKDIR /app

COPY Gemfile ./
COPY Gemfile.lock ./
RUN bundle install

COPY . .
RUN cp config/database.yml.sample config/database.yml

EXPOSE 3000
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
