FROM nginx:latest
RUN adduser -D www-data --shell /usr/bin/nologin
COPY . /usr/share/nginx/html/
USER www-data
