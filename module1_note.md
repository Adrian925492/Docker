# Docker masters - part 1

----------
## Definitions

**Docker client** - CLI tool for controlling the docker engine. It allows us to pull, manage and run images and containers. The client converts tuped commands into http requests, and sensd it to docker engine. Commands payloads includes localy stored registry credentials. With that kind of architecture we can control any docker engine on any machine threw locally installeddocker client.

**Docer engine** - Open source program running as separate program that realizes commands given by docker client. The docker engine (daemon) realizes tasks with managing and using images and containers. Docker daemon manages also reaources and networks for containers. 

**Docker registry** - Storage for keeping the images that can be used to run containers from it.

> **_NOTE_** ! Popular programming languages has its eligeable images in docker hub naming same, as language. For example, to run python script we just need to type: 
```docker run -v `pwd`/script.py:/script.py python:3-alpine pytohn3 /script.py```
The docker will pull official image with python 3 alpine version and run "script" on it.

> **_NOTE_** ! All images with "alpine" suffix are n general lighter versions of standerd images.


----------

## Commands fo getting info about the running OS

```cat /etc/os-release``` - gives info about os on the machine
```free -h``` - give info about system memory (hard drive)
```cat /proc/cpuinfo``` - gives info about cpu on the system

## Valuable programs

### From apt-get

* **bat** - better version of "cat" - more likely looking ```sudo apt install bat```; usage: ```batcat <filename>```
