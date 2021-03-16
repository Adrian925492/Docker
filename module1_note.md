# Docker masters - part 1

----------
## Definitions

**Docker client** - CLI tool for controlling the docker engine. It allows us to pull, manage and run images and containers. The client converts tuped commands into http requests, and sensd it to docker engine. Commands payloads includes localy stored registry credentials. With that kind of architecture we can control any docker engine on any machine threw locally installeddocker client.

**Docer engine** - Open source program running as separate program that realizes commands given by docker client. The docker engine (daemon) realizes tasks with managing and using images and containers. Docker daemon manages also reaources and networks for containers. 

**Docker registry** - Storage for keeping the images that can be used to run containers from it.

**Emulation** - it is a program, that run in one OS (host) duplicates functions other OS (guest), for ex. wine. Guest is emulated by host. It means, that any task given in emulation has to be converted to resources avaliable on host, executed, and the results has to be converted back to emulation system functions by emulator.

**Virtualization** - we have complete OS (guest) running on host os. Virtualization has high isolation level, but also has overhead due to hypervisor running. The hypervisotr is a process which interracts between guest OS and hardware resources.

**Contenerization** - with contenerization the containers shares the same host OS kernel, but has isolated env variables, networks, memory resources etc. That grants limited isolation level, but is much lighter than virtualization.

**Docker desktop** - dedicated platform to run docker containers on Windows/MacOS

> **_NOTE_** ! Popular programming languages has its eligeable images in docker hub naming same, as language. For example, to run python script we just need to type: 
```docker run -v `pwd`/script.py:/script.py python:3-alpine pytohn3 /script.py```
The docker will pull official image with python 3 alpine version and run "script" on it.

> **_NOTE_** ! All images with "alpine" suffix are n general lighter versions of standerd images.

> **_TIP_** Elgeable documentation can be found on https://devdocs.io/. It is lightweight, and once enabled documentation is stored inside browser cache, so it will be accesible also without access to the internet. 
----------

## Docker commands

* **docker run [options] <image> [command]** - runc container based in image and executes command on it
* **docker version** - informs if we have and what kind of docker client and docker engine ou our setup
* **docker info** - gives more informations about docker engine, includeing nr f images, stopped containers, assigned registries, plugins etc.

## Docker environmental variables
* **DOCKER_HOST** - specifies url of socket for docker engine. By changing it, we can reorder connection between docker  client and docker engine.

## Commands fo getting info about the running OS

```cat /etc/os-release``` - gives info about os on the machine
```free -h``` - give info about system memory (hard drive)
```cat /proc/cpuinfo``` - gives info about cpu on the system

## Valuable programs

### From apt-get

* **bat** - better version of "cat" - more likely looking ```sudo apt install bat```; usage: ```batcat <filename>```

-----------
## Tips

1. Add proxy to connection docker client -> docker engine

a) run proxy by command (Ubuntu): ```sudo socat -d -d -t100 -lf /dev/stdout -v UNIX-LISTEN:/var/run/docker.debug,mode=777,reuseaddr,fork UNIX-CONNECT:/var/run/docker.sock```. The proxy will listen all messages and informs it on the console.
b) Modify DOCKER_HOST variable (for one command or for whole session) to use proxy instead of standard socket, and type docker command, for example: ```DOCKER_HOST=unix:///var/run/docker.debug docker images``` Default docker engine socket is: */var/run/docker.sock*

! As communication between client and engine is realized by https, You do not need to use docker client at all. You ca just send http requests directly to docker engine, eg. ```curl -sSf --unix-socket /var/run/docker.sock 0/images/json``` will give json with all containers inside the engine.

2. Installing docker on Ubuntu:
-> By apt repository (just add appropriate repo to the apt before)!
-> By usage automated script: *get.docker.com* which will install docker engine for us

! See docker docs

3. Installing docker on Windows


