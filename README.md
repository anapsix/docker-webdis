[![](https://img.shields.io/docker/automated/anapsix/webdis.svg)](https://hub.docker.com/r/anapsix/webdis)  
[![Docker Pulls](https://img.shields.io/docker/pulls/anapsix/webdis.svg?style=round-square)](https://hub.docker.com/r/anapsix/webdis/)

[Webdis](http://webd.is) (by Nicolas Favre-Félix) is a simple HTTP server which forwards commands to Redis and sends the reply back using a format of your choice. Accessing /COMMAND/arg0/arg1/.../argN[.ext] on Webdis executes the command on Redis and returns the response; the reply format can be changed with the optional extension (.json, .txt…).

Webdis implements ACL by IP/CIDR, by HTTP Auth or both with list of explicitly allowed or disallowed commands a client may use.

Documentation is available at author's site: [http://webd.is/#http](http://webd.is/#http).

## Usage

Start all-in-one (includes Redis):

    docker run -d -p 7379:7379 -e LOCAL_REDIS=true anapsix/webdis

Link redis container manually and run:

    docker run -d --name r4w redis
    docker run -d -p 7379:7379 --link r4w:redis anapsix/webdis

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
`SUBSCRIBE` endpoint triggers Segmentation fault, when aborting connection and hitting it again..
```
## Example

## Step 1 (in terminal session #1)
# start container

$ docker run -it --rm -p 7379:7379 -e LOCAL_REDIS=true w


## Step 2 (in terminal session #2)
# curl subscribe endpoint

$ curl 127.0.0.1:7379/subscribe/hello


## Step 3 (in terminal session #3)
# curl set endpoint

$ curl 127.0.0.1:7379/set/hello/world
{"set":[true,"OK"]}


## Step 4 (in terminal session #2)
# abort previous subscribe curl, and start new one

$ curl 127.0.0.1:7379/subscribe/hello
curl: (7) Failed to connect to 127.0.0.1 port 7379: Connection refused


## Step 5 (in terminal session #1)
# check docker logs

$ docker run -it --rm -p 7379:7379 -e LOCAL_REDIS=true w
installing redis-server..
starting local redis-server..
17:C 14 Dec 17:42:59.397 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
17:C 14 Dec 17:42:59.397 # Redis version=4.0.11, bits=64, commit=bca38d14, modified=0, pid=17, just started
17:C 14 Dec 17:42:59.397 # Configuration loaded
writing config..
starting webdis..
[21] 14 Dec 17:42:59 35 Webdis 0.1.5-dev up and running
[21] 14 Dec 17:43:02 0 /subscribe/hello
[21] 14 Dec 17:43:05 0 /set/hello/world
Segmentation fault
```

## TODO
Make configurable via ENV/args
