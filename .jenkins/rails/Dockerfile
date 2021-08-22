FROM ruby:2.7.2
RUN curl https://deb.nodesource.com/setup_12.x | bash \
	&& curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
	&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
	&& apt-get update -qq \
	&& apt-get install -y nodejs yarn libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb

RUN curl -sfL https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s

ENV	TRACKER_DATABASE_PORT=3306
ENV TRACKER_DATABASE_HOST=db
ENV TRACKER_FRONT_URL=localhost:8080
ENV TRACKER_ALLOW_ORIGINS=http://localhost:8080
ENV REDIS_URL=redis://redis:6379/1

ENV INFLUX_DB_HOST=http://influx_db:8086
ENV INFLUX_DB_TOKEN=token
ENV INFLUX_DB_ORG=tracker
ENV INFLUX_DB_BUCKET=tracker_db
ENV INFLUX_DB_TEST_BUCKET=tracker_db

ENV VUE_APP_BACK_END_API_URL=http://localhost:3000
ENV VUE_APP_FRONT_END_URL=http://localhost:8080
ENV VUE_APP_BACK_END_ACTIONCABLE_API_URL=ws://localhost:3000

