FROM ruby:3.3.5-alpine

# Add Tini - a tiny valid init
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "--"]

WORKDIR /app

COPY ./src .

EXPOSE 80

CMD ["ruby", "http_server.rb"]
