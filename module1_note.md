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

**Docker daemon config file** - the fiel containes user defined config for docker daemon (for. ex. insecure-registries config). It is by default stored in */etc/docker/daemon.json* location. By defaultm it does not exsits (has to be created by user if needed). We can create it also in other location and pass the path to it by **--config-file** flag to **docker run** command. Some of configs can be reloaded when docker daemon is running, by sending SIGHUP signal on Linux. To do that (in Linux) we have to send signal ```kill -HUP $(pidof dockerd)``` to daemon process. PID of process of docker daemon we can get by ```pidof dockerd```, or we can read it from one of docker file by ```cat /var/run/docker.pid```.

**Docker client config file** - simrarly to docker daemon, also docker client can be configured. To do that we have to just create **config.json** file with new config and pass it to docker client command by ```docker --config <path_to_configfile_directory> <command>```. Other possibility is to use **env DOCKER_CONFIG=<path_to_configfile>**. If we export such env, the docker clint will use the config any time. We can set it by command ```export DOCKER_CONFIG=<path_to_configdir>``` and unset it by command ```unset DOCKER_CONFIG```. We can also set it permanently by modyfing/adding **config.json** file to **~/.docker** path.

**Logs from docker** - logs from docker can be read and accesed via OS. It differs depending on os type. The full path of logs location in the OS are in lach.dev/docker-engine-logs more info can be found. In ubuntu, to see the logs, we have to run ```sudo tail -f /var/log/upstart/docker.log```. It may happend that logs will be written to other file. In such situation just use ```grep docker *``` which will look for all *docker* names in */var/log* path, and from that we can see in which log we have docker logs.

**Monitoring used resources** - we can look for used hard disk memory by docker daemon  by ```docker system df``` command. The ```-v``` flag added to the command lists the informations of used memory by image and container. In order to monitor in real time the resource usage by container, including CPU, RAM and network usage, we can use ```docker stats``` command. The ```--no-stream``` flag will run the stats just once, without real time feedback. Additionally we can add ```--format <format>``` parameter to format the output. All formats of docker stats command can be found in docker stats command documentation. In order to see detailed informations about docker image/container, we can use ```docker inspect <container/image>``` command. For example, command used on image will give us paths to caches filesystems of all layers being parts of the image.

**Dangling images and dangling containers** - dangling images refers to images tahat are not taged and can be accesed only via its hash. Dangling image can occur if we rebuild some image and the old image would become a dangling. Same rule can be applied to containers, networks or volumes. To remove dangling objects we can use command ```docker <images / containers / volumes / networks > prune```. If we want to remove all dangling objects we can use command ```docker system prune```. In order to remove any specified non - dangling image, we can use ```docker rmi <image_name or hash>```, and to remove container - ```docker rm <container name of hash```. Adding ```-a``` flag to any prune command will efect removing all related to command docker objects, currently not running, not the dangling only. For example, if we have no container running at the moment, and we type ```docker system prune -a```, we will remove all contianers, images etc. The ```-f``` flag supress prune confirmation (usable in scripts).

**Monitoring docker status** - we can observe and debug docker daemon by:
> ```docker events``` command - shows logs about docker daemon - started/stopped containers, used networks etc.
> Using debug mode - add env variable ``` ``` to ```/etc/docker/daemon.json``` and reload the config by sending **SIGHUP** signal to reload the daemon and apply the change. You can also kill the engine by **SIGKILL** and restore it again.
> Getting the stacktrace - we can get the stacktrace by sending *SIGUSR1* signal to docker daemon by command ```kill -USR1 $(pidof dockerd)```. In the docker logs we can observe where the stacktrace has been written (usually in /var/run/docker/goroutine-stacks-xxxxx.log)

**Container states**:
CREATED -> RUNNING -> PAUSED / STOPPED

* CREATED - the contianer is created and ready to be run
* RUNNING - the container is running
* PAUSED - contianer is paused. Resources are still occupied, but not used.
* STOPPED - container stopped doing his job. Resources are freed.

! After ```docker run``` command the container goes thred states: CREATED and to RUNNING.

**Container attributes** - all runned container has its unique, automatically generated **id**, and a name, which can be given by *--name=* parameter added to *docker run* command, or if not given, will be automatically given. The id and nae is used for identyfing the container in any other command.

**Container size** - the size of contaienr is understood as all modifications added to image file syatem after running it. In general, it is size of top level, read - write layer.

**Container namespaces** - all of the containers has its own, unique set of namespaces, like PID (user ID namespace); User namespace; UTS; Mount - disk namespace; Newtork namespace nad IPC - inter process communication namespace. It means, that each container can use resources only from its own namespace. Namespaces can be shared between containers.

**IPC communication between containers** - to make able 2 containers to connect each other using IPC mechanism, we have to run one of them with flag ```--ipc shareable``` which will make its ipc communication space shareable, and run other container, which we want to use ipc of the first one with flag ```--ipc container:<name of cont. with shareable ipc>```.

> **_NOTE_** ! Popular programming languages has its eligeable images in docker hub naming same, as language. For example, to run python script we just need to type: 
```docker run -v `pwd`/script.py:/script.py python:3-alpine pytohn3 /script.py```
The docker will pull official image with python 3 alpine version and run "script" on it.

> **_NOTE_** ! All images with "alpine" suffix are n general lighter versions of standerd images.

> **_TIP_** Elgeable documentation can be found on https://devdocs.io/. It is lightweight, and once enabled documentation is stored inside browser cache, so it will be accesible also without access to the internet. 

> **_TIP_** - In **~/.profile** file we can add any commands that are executed at startup with the user. For example - we can add any docker config file here to make it only for selected user.
> **_NOTE_** - In ```/var/lib/docker``` directory we have location of docker cache. Here we can find all infor about networks, containers, images etc.
> **_TIP_** - If we have some "commnad not found" error, we can use https://command-not-found.com/ to find out commands we have to use to get the program we want.
----------

## Docker commands

* **docker run [options] <image> [command]** - runc container based in image and executes command on it. When we type the command, client sends request do daemon. Than, daemon tries to fnd the image locally, if not found looks for it in logged registries and downloads if found. Then, the daemon starts the container based on image and informs client about it. The docker run can end with error (typical error codes: 125 - daemon error; 126: command cannot be invoked; 127: command not found; else exit code of the container).
* **docker version** - informs if we have and what kind of docker client and docker engine ou our setup
* **docker info** - gives more informations about docker engine, includeing nr f images, stopped containers, assigned registries, plugins etc.
* **docker pull <image>** - pulls image from registry. If the image is already in daemon cache, the image will be checked if there is any update in registry, and update, if exists, will be pulled. When docker runs image, it will use local copy as first. It is not recomended to use same tags for updates of docker images (old tags shall not be overwritten). If we du not type explicitly the version, *latest* version will be used.
* **docker rename <id or old name> <new name>** - Renames the container
* **docker ps** - lists all active containers with its data (name, image, comand, status, run time (from), ports). The table is always sorted by time. If run with *-a* parameter (all), the command will list all containers, including containers in other than run state. Running it with *-l* parameter will list only recent run container (or none if no container is running). Parameter *-q* (quiet) will force the command to return only ids of the containers. It can be used for example inside subshell in other docker commands that needs ids of the container (ex. docker stop). For example, command *docker kill $(docker ps -q --filter name=web\*)* will kill all containers that has "web" in its name. Docker ps with *-s* parameter will give info about container size.
* **docker logs <container id or name>** - will display all logs from the beggining of detached container (all stuffs from stdout/stderr). The *--tail N* parameter will force displaying only N last logs. Follow parameter *-f* will display the logs in real time mode.The *--since X* and *--until X* will dispaly logs from last X or untill X time. The --timestamp will add timestamp to every log line, and --details will priint additional informations to the logs. We can get infor what kind of driver is used for logging by *docker inspect --format '{{.HostConfig.LogConfig.Type}}' <container name>*, and get the log path (if the driver logs to file) by *docker inspect --format='{{.LogPath}}' <container name>*.
* **docker inspect <container id or name>** will return all inforamtions that daemon knows about the container in json format. The *--format '{{ json <field>}}'* parameter will print out selected arg of the json.
* **docker stats** will block terminal and in real time give information about containers and consubed resources by it. The *--no-stream* parameter will print just a current stats without real-time mode, and *--format {{}}* allows to format the output. 
* **docker top <container name or id>** will give us list of processes (top command) for the given container. The PID and PPID are ids from host OS perspective. 
* **docker diff <container name>** will give us diff of filesystem of the container since it was run.

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
-> By usage automated script: *get.docker.com* which will install docker engine for us, example ```curl -fsSL get.docker.com | sh```
-> Add user to docker group (as sudo) ```adduser <myusername> docker``` and reboot the host os

! See docker docs

3. Installing docker on Windows

## Linux definitions

**Unix Socket** - A special kind of file (type "s") which is used for inter process communication. We have 3 tyles of unix sockets: SOCK_STREAM (comparable to TCP); SOCK_DGRAM (comparable to UDP) and SOCK_SEQPACKET (comparable to SCTP). Unix socket is a communication endpoint for processes. Only 2 processes can communcate threw single unix socket, and the communication is similar to internet communication.

**IPC** - Inter process communication - set of Unix/Linux mechanisms for communication processes each other. In general, it defines mechanisms used by many processes to share data. Types of IPC communication in Unix/Linux:

* **File** - The simplest one. Each process can write and read to/from file at any time. A record is stored on a hard drive.
* **Signal** - a system message sent from one process to another (for. ex. SIGKILL, SUGUSR1 etc...).
* **Socket** - Data are sent over a network interface, to processes working on the same host machine, or on different machines, using choosen internet protocol (ex. TCP). Special type of socket is unix-socket, which allows only to send data between processes on the same host machine, and all communication is handhelded by the kernel. Many processes can communicate to single socket.
* **Message queue** - special type of a file, that allows to communicate just 2 processes. The processes are directly connected each other.
* **Pipe** - unidirectional data channel using standard io. 2 processes can be connected by single pipe, from which one can only sent to the pie, and other can receive. Data in a pipe are buffered untill receiving process takes it. To make bidirectional communication between 2 processes - we need 2 pipes.
* **Shared memory segment** - Defined range of a memory that is shaed between processes.


