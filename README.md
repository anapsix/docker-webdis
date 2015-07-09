
[![](https://badge.imagelayers.io/anapsix/webdis:latest.svg)](https://imagelayers.io/?images=anapsix/webdis:latest)

[Webdis](http://webd.is) (by Nicolas Favre-Félix) is a simple HTTP server which forwards commands to Redis and sends the reply back using a format of your choice. Accessing /COMMAND/arg0/arg1/.../argN[.ext] on Webdis executes the command on Redis and returns the response; the reply format can be changed with the optional extension (.json, .txt…).

Webdis implements ACL by IP/CIDR, by HTTP Auth or both with list of explicitly allowed or disallowed commands a client may use.

Documentation is available at author's site: [http://webd.is/#http](http://webd.is/#http).

# Usage

You can spin it up on [Tutum.co](http://tutum.co)  
[![Deploy to Tutum](https://s.tutum.co/deploy-to-tutum.svg)](https://dashboard.tutum.co/stack/deploy/)

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

# TODO
Make configurable via ENV/args
