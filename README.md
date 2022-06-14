[![Docker Pulls](https://img.shields.io/docker/pulls/anapsix/webdis)](https://hub.docker.com/r/anapsix/webdis/)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/anapsix/webdis/latest)
![linux/amd64](https://img.shields.io/badge/platform-linux%2Famd64-blue)
![linux/arm64](https://img.shields.io/badge/platform-linux%2Farm64-blue)

[Webdis](http://webd.is) (by Nicolas Favre-Félix) is a simple HTTP server which
forwards commands to Redis and sends the reply back using a format of your
choice. Accessing `/COMMAND/arg0/arg1/.../argN[.ext]` on Webdis executes the
command on Redis and returns the response; the reply format can be changed with
the optional extension (.json, .txt…).

Webdis implements ACL by IP/CIDR, by HTTP Auth or both with list of explicitly allowed or disallowed commands a client may use.

Documentation is available at author's site: [http://webd.is/#http](http://webd.is/#http).

## Build

Build as per usual

    docker build -t webdis .

Build a multi-arch image

    # you might need to create a multiarch builder
    docker buildx create --name multiarch --bootstrap --platform linux/arm64,linux/amd64

    # build using buildx, specifying all the platforms you want to build for
    docker buildx build --builder multiarch --platform linux/arm64,linux/amd64 -t webdis .

## Usage

Start all-in-one (includes Redis):

    docker run -d -p 7379:7379 -e LOCAL_REDIS=true anapsix/webdis

Link redis container manually and run:

    docker run -d --name r4w redis
    docker run -d -p 7379:7379 --link r4w:redis anapsix/webdis

Use external redis server:

    docker run -d -p 7379:7379 -e REDIS_HOST=redis-server-host anapsix/webdis

Use Docker Compose:

    docker-compose up

Try accessing it with curl:

* directly:

        curl http://127.0.0.1:7379/SET/hello/world
        curl http://127.0.0.1:7379/GET/hello

* or via haproxy:

        curl http://127.0.0.1:8080/SET/hello/world
        curl http://127.0.0.1:8080/GET/hello

## Known Issues

See https://github.com/nicolasff/webdis/issues
