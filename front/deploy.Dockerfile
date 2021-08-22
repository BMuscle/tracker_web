FROM node:lts-alpine as build-stage
RUN apk update && \
    apk add --no-cache --virtual build-dependencies git curl python make g++ && \
    curl -o- -L https://yarnpkg.com/install.sh | sh
ENV PATH $HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH
ENV VUE_APP_BACK_END_API_URL=https://bmuscle.ddns.net/tracker_rails
ENV VUE_APP_FRONT_END_URL=https://bmuscle.ddns.net/tracker
ENV VUE_APP_BACK_END_ACTIONCABLE_API_URL=wss://bmuscle.ddns.net/tracker_rails
WORKDIR /app
COPY package.json ./
COPY yarn.lock ./
RUN yarn install --network-timeout 600000
COPY . .
RUN yarn build

FROM nginx:stable-alpine as production-stage
RUN mkdir -p /usr/share/nginx/html/tracker
COPY --from=build-stage /app/dist /usr/share/nginx/html/tracker
COPY nginx_default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
