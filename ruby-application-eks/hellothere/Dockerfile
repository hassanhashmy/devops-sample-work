FROM ruby:3.2.3-alpine

# Add Tini - a tiny valid init
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "--"]

WORKDIR /app

COPY ./src .

EXPOSE 80

CMD ["ruby", "http_server.rb"]
