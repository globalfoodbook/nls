# Nutrition Label Service API running inside docker.

A Docker container for setting up Nutrition Facts Label API (Golang and PostgreSQL). This server can respond to requests from any client browser and REST Client. This best suites development purposes.

This is a sample Nutrition Facts Label API (Golang and PostgreSQL) container used to test Nutrition Facts Lable Generator from [http://nuts.globalfoodbook.net](http://nuts.globalfoodbook.net) use on [http://globalfoodbook.com](http://globalfoodbook.com)


To build this gfb server run the following command:

```bash
$ docker pull globalfoodbook/nls
```

This will run on a default port of 80.

To change the PORT for this run the following command:

```bash
$ docker run --name=nls --detach=true --publish=80:80 --volume=/path/to/nuts-api-code/:/your/path/to/nuts-api-location nls
```

To run the server and expose it on port 9292 of the host machine, run the following command:

```bash
$ docker run --name=nls --detach=true --publish=80:80 globalfoodbook/nls
```

# NB:

## Before pushing to docker hub

## Login

```bash
$ docker login  
```

## Build

```bash
$ cd /to/docker/directory/path/
$ docker build -t <username>/<repo>:latest .
```

## Push to docker hub

```bash
$ docker push <username>/<repo>:latest
```


IP=`docker inspect gfb | grep -w "IPAddress" | awk '{ print $2 }' | head -n 1 | cut -d "," -f1 | sed "s/\"//g"`
HOST_IP=`/sbin/ifconfig eth1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`

DOCKER_HOST_IP=`awk 'NR==1 {print $1}' /etc/hosts` # from inside a docker container 
