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

**Image registry** - is a HTTP server, that stores docker images and allows to push/pull it. 

**Local image registry** - We are able to run local image register, by running docker registry project. It is contenerized application, as well as we can download and compile the sources. If we want to use contenerized app, we can pull and run it by command *docker run -d -v [docker_registry_loc_folder]:/var/lib/registry -p 5000:5000 registry:version, ex.2]
*

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

**Docker volumes** - mechanism of usage some filesystem of hosts os inside docker container. In most basic way we can create any volume inside a container by VOLUME command inside dockerfile, or by -v <volume_name> inside docker run. Then, the volume will be created in a given path inside docker, and in random location inside volumes on host os. To get exact location of the volume on host os, type **dockr inspect -f '{{.Config.Volumes}}' volumeName**. Other way is to create volume by **docker volume volumeName** command and use the created volume in docker run by **-v namedVolume:pathToVolumeInsideDocker** added to **docker run**. The volume will be stored in volumes on host os. Third way is to just map existing path as a volume to the container by **-v host_dir_path:volume_path_in_docker** added to **docker run** command.

**Docker networks** - docker provides several types of network drivers: host (only Linux host OS), bridge, none, swarm, container_network_mode (same as set in the given container). The drivers defines how and what we can use regarding network connections of the container.

**Docker compose** - the tool for creating single docker image by multiple docker images using .yaml configuration. Docker compose has its distro to all systems that docker can work on (Linux, Mac, Windows). Docker compose allows to store whole application stack in a single YAML file. Docker compose is a kind of wrapper for docker commands, and can be used with docker client in parallell. Docker compose is installed by default on Windows and Mac distributions, for Linux we have to install it (follow instruction on https://docs.docker.com/compose/install/). 

Docker compose version has to be at least as high as docker version. Docker compose is backward compatible, so the docker can be in lower version than compose tool.

Docker compose YAML file sections:
- version - required, specifies required docker-compose version
- services - required, a service is one or more replicas of the same container
- networks - optional, defines the networks that containers should use, by-default it is bridge
- volumes - optional, defines volumes to be used by the containers

And each service in the YAML has to be defined by:
- iamge - required, indicates the image
- build - required, points to path with Dockerfile, and optionaly parameters for the build
- command - optional, alows to overwrite command defined in CMD in dockerfile
- container-name - optional, overwrites default (given by docker-compose) name to the container. Dpcker-compose will automatically handle names conflict by adding numeric suffix to the given name.
- depends_on - optional, allows to type dependencies between services (containers) to make chain of starting/stopping the services. Depends on waits for running the container, but not for services inside the containers waited on.
- entrypoint - optional, allows to overwrite entrypoint to docker image
- env_file - optional, path to file from which environmental variables has to be taken (can be single file or list of files)
- environment - optional, allows environment variables addings (key - val is ENV - its value). All boolean has to be passed inside '', otherwise it will be treated as string. If we pass only a keys, the docker-compose will check if env is avaliable in host os, and if yes will use it (otherwise it will be empty).
- network_mode: "host/none/bridge/services:[service name]/container:[container name]" - optional allows to overwrite network type of the container
- restart: "no/always/on-failure/unless-stopped" - optional - value defining strategy what shall bedone when container stops, default is no
- volumes - optional allows to ad volumes to the container, syntax is same as for docker run volumes (by mapping, no mapping or by volume name)
- ports - optional, alows to pass list of ports that we want to map from host to container system (we can use ranges, like 8000-9000:8000-9000; or even ip adresses, like 192.164.1.1:8080:8080). We can add also protocul like *6060:6060/udp*
- 

Basic commands for docker compose and its analogy to docker client commands:
- docker ps -> docker-compose ps
- docker pull -> docker-compose pull
- docker run -> docker-compose run
- docker run -d -> docker-compose up -d
- docker stop -> docker-compose stop
- docker rm -> docker-compose rm
- docker build -> docker-compose build

Other commands:
- docker-compose config - prints the content of docker compose config file

! If we put an env inside docker compose, we can specify default value by **${ENV_VARIABLE:-default_value}**. The default value will be used if the env is not set in host system during startup of docker-compose. The file will be loaded only by docker compose (docker client not). The file name (.env) can be changed in config of docker-compose tool. We can also set it explicitly by **-env_file: [path to env file]** config to docker-compose yaml file.

! If we want, we cen define text file named **.env** with environbmental variables (same foled as docker compose config). The env variables defined here will be loaded.

**Daemon mode** - container can be run in attached and in daemon mode. In attached mode, the container *STDOUT* and *STDERR* streams are attached to terminal. In daemon mode, the streams are not attached and the contaienr works in background. We can see the streams by displaying container logs.

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
* **docker attach <container name>** will attach STDIO and STDERR streams of a given container to current terminal. We can add parameter *--detach-keys <some keyn, ex. ctrl-a>* to define detach keys combination. It can be also put inside configfiled of the docker daemon (detach-keys record).
* **[CTRL + P + Q]** will detach currently attached container
* **docker restart** will restart the container, launch run command, but will not remove and recreate container. The command will restart already created container, so all fs diffs will be kept.
* **docker exec <id or name> <command>** - Will execute command inside given docker image. The *-it* flag will make it in interactive mode. The *-u 0* parameter will do the command by root user (UID of the root user is 0).
* **docker build <build context>** will build image basing on its dockerfile. The dockerfile has to exists inside build context (build context is a path). If we do not use any COPY or ADD command, we do not need any directory as build context, we can injest the Dockerfile to the docker build directly. In such situation the command would look like **docker build - < Dockerfile**. The **-** means we use nothing as build context, and the **<** means we inject directly the given dockerfile. If we have experimental features enabled, we can use *--squash* flag. The docker, after building all layrs will squash them to only one, big layer, and the final image will have just that single layer.
* **docker network connect [container_name] [network_name]** - allows to connect the given docker container to the given network name in runtime. 
* **docker save [image name or id] > [tar file path]** - Will save given image (or all versions of image, if the version is not given) to tar file. Optionally, it can be used with syntax *docker save -o [tar file path] [image name or id]*
* **docker load -i [tar archive path]** - Loads exported image from tar archive.

## Docker environmental variables
* **DOCKER_HOST** - specifies url of socket for docker engine. By changing it, we can reorder connection between docker client and docker engine.

## Commands fo getting info about the running OS

```cat /etc/os-release``` - gives info about os on the machine
```free -h``` - give info about system memory (hard drive)
```cat /proc/cpuinfo``` - gives info about cpu on the system

## Docker images versioning

**Stable tagging** - The version of the image cames by components: **<major_version>.<minor_version>**. If we tag any image with some version, for ex. 1.2, the docker will automatically assign **:2** tak pointed to highest minor version of images tagged by major version 2, and the **:latest** tag which points to the latest released image, regardles its major and monor vesrion. In stable tagging we use major and minor versions. Stable tags can be forex. used for tagging images that will be used as jenkins agents.

**Unique tagging** - in unique tagging we tag versions by syntax **<version>**, without usage minor/major versioning. There will only be created **:latest** automatic tag pointed to image commited last in time.

**Multistage builds** - Means we can use multiple times FROM instruction in Dockerfile. Moreover, all stages of build can use stuffs defined in previous stages (like ENV variables). Multistage builds alows us to create lighter versions of final image - only the image started from last FROM instruction will be the final one. To use multistage build we can use **COPY --from=<stage> <source> <dest>** command. The command allows to copy some files (source) to destination inside our build image, taken from given stage. The stage can be identified by its id (from 0), or by stage name (after *AS* directive in stage). The **--from** and accept also other docker image name and copy some files from inside it. The dockerfile like:
  ```
  FROM ubuntu:16 AS base_os
  RUN "echo someHost >> /etc/hosts"
  
  FROM someOtherImage
  COPY --from=base_os /etc/hosts /myHosts
 ```
Will create the image which has copied ONLY hosts from base image (Ubuntu). The final base image for created image will be someOtherImage.

! If we do not want to use any base image we type **scratch** to FROM command (FROM scratch). Then, our docker image will base on no image.
  
## Valuable programs

### For docker

**hadolint** - Linter for dockerfiles. Will give us informations about whant we can imporve in dockerfile, and moreover, can give us info about optimization of schell commands given in RUN directives. The hadolint is contenerized application. To get it we have to get appropriate docker image by ```docker pull hadolint/hadolint```, and to use it we type ```docker run -i hadolint/hadolint < our_dockerfile```.

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

4. Running processes inside container with PID1
  It is possible to run any application under PID1 in container PID namespace. To do that, just run the application with container by passing it as parameter or by typing it to *RUN* command in dockerfile. It is a good practice to handle at least *SIGKILL* signal, and better also *SIGTERM* by the process runed with PID1. If signals are not handheld, sending it to process will do nothing, beacoude PID1 process is able to ignore non handled signals.
  
  If the PID1 application is shell script, You can use syntax:
  ```
  #!/bin/bash
  trap '' EXIT
  while true; do
    ... <content>
  done
  ```
  The "trap" will catch EXIT which means it will register SIGKILL and SIGTERM signal. The trap will cause ending the process.
  ! If there is not given explicitly init process, there is ready init process default given by docker, named **tini**. To run that porcess under docker just add *--init* flag to **docker run** command. The *tini* will handle signals, handle zombie processes and manage PID fro sub processes inside the container.
  
  **_TIP_** If You wont to run any new app inside schell runned with PID1, and we want to run some other application inside it also with PID1, we have to run it with **exec** command prefix, like
  ```
  exec /usr/bin/someApp -daemon
  ```
  That will cause taking control of the current process with PID1 by someApp.
  
  **_TIP_** If Youw ant to run some command inside script with other user (group), You can use **su-exec** or **gosu** prefix, like:
  ```
  su-exec user:[optional group] comeCommand
  gosu user:[optional group] command
  ```
  By using that we can, for example, run some commands for other user as root.
  
  **_TIP_** We can enter the container namespace by using **nsenter** command. The command works only as sudo user, and allows to get into given namespace. Example:
  ``` sudo nsenter -t $(docker inspect -f '{{ .State.Pid }}' <container_name>) -m ps aux```. Th docker inspect subshell will return us PID of any process inside the container (1st from list). To enter the namespace of the container we need any proces from the container. The *-m* parameter will make that command will be from inside the container, and not giving the parameter will make it from outside the container (from host os).
  
  **_TIP_** Docker ENTRYPOINT vs CMD command. If in the dockerfile we have both ENTRYPOINT and CMD command, the things given in ENTRYPOINT will be executed, and the things given in CMD will act as a parameters for ENTRYPOINT command. In case if we add some parameters to docker run, the CMD will not be used wn given by hand parameters will be passed to ENTRYPOINT command. If we do not have ENTRYPOINT, and have CMD, and we just run the image without any prams, the CMD will be treated as command and executed. If we have some CMD command and anyway pass some parameters to docker run, than the given parameters will be treated as command to run (1st param) and parametrs to the command. CMD will not be used in that case. We can use ENTRYPOINT and CMD to rpoduce docker that will act as kind of executable file. The WORKDIR instruction defines work directory for RUN, COPY, ADD, ENTRYPOINT and CMD commands. If we give no */* at the begining of workdir (non absolute path), the workdir will create directory relative to current workdir.
  
**_TIP_** .dockerignore - the file that allows us to specify ignored parts of build context directory (syntax as for .gitignore file). With dockerignore file we can set COPY . . in a dockerfile to copy all build context inside dockef image, and in the .dockerignore file we can skip selected files. 

**_TIP_** Good practices for building images 
1. Use --squash option for build base images. Do not use it for deployement images.
2. Use as least as possible RUN comands. Each RUN command produces bew layer.
3. Clean unnecessary files (by rmeoving it). That will make image lighter in the same instruction when You get it!.
4. Use multistage builds
5. Use RUN --mount=type=<type> oprion for RUN command of the dockerfile to map volumes when images are build (experimental feature). See more types in docker documentation.

## Linux definitions

**Unix Socket** - A special kind of file (type "s") which is used for inter process communication. We have 3 tyles of unix sockets: SOCK_STREAM (comparable to TCP); SOCK_DGRAM (comparable to UDP) and SOCK_SEQPACKET (comparable to SCTP). Unix socket is a communication endpoint for processes. Only 2 processes can communcate threw single unix socket, and the communication is similar to internet communication.

**IPC** - Inter process communication - set of Unix/Linux mechanisms for communication processes each other. In general, it defines mechanisms used by many processes to share data. Types of IPC communication in Unix/Linux:

* **File** - The simplest one. Each process can write and read to/from file at any time. A record is stored on a hard drive.
* **Signal** - a system message sent from one process to another (for. ex. SIGKILL, SUGUSR1 etc...).
* **Socket** - Data are sent over a network interface, to processes working on the same host machine, or on different machines, using choosen internet protocol (ex. TCP). Special type of socket is unix-socket, which allows only to send data between processes on the same host machine, and all communication is handhelded by the kernel. Many processes can communicate to single socket.
* **Message queue** - special type of a file, that allows to communicate just 2 processes. The processes are directly connected each other.
* **Pipe** - unidirectional data channel using standard io. 2 processes can be connected by single pipe, from which one can only sent to the pie, and other can receive. Data in a pipe are buffered untill receiving process takes it. To make bidirectional communication between 2 processes - we need 2 pipes.
* **Shared memory segment** - Defined range of a memory that is shaed between processes.

**PID** - Process ID is an unique number identifying process on Linux system. The first runned process after running the OS gets PIS equals to 1. Any child process of the main process has higher PID value. Simirarly, inside docker container, the main process has PID eq. to one, but the processes from container in context of host os has naturarly higher pid values. The PID of the process can be used for identification of processes in commands like kill. The main process on ubuntu is named *systemd* (system daemon). Additionally, each container gets its own process namespace. Thanks to that we get separation of container processes of res of processes running on host os. Process with PID 1 has several special features. It does not handles non serviced signals (in other PID processes non sending non handled signal ends same as sending SIGKILL). Other responsibility of the PID1 process is clearing Zombie processes.

**Zombie process** - Zobie process is a process that has been finished its job, but has not been waited for by its parent process. In that case, the process is in fact not executing, but it is not terminated and its pid still exists in pid table. The danger of that is that too many zombie process can fill all PIDs and destabilize OS. 

**Process informations** - in /proc we have all informations about processes organized in catalogue structure. We can get from there for ex. informations about used resources, etc. The processes inside here are organized in folder structure, by ID, for example root process will be available under */proc/1* directory. We can also see how the user can see filesystem by */proc/1/root*. This will give us info about how the root user sees the fs. We can use it forex. to see files from container fs from host os just by going into: */proc/<PID of any process inside container>/root*. This will give us view of the fs inside container as root user of the container would see it. 

**IP adress of th local machine** - we can get it via:
```ip -br -c a``` <- The first interface (eth0) is external ip adress of the machin
```hostname -I``` <- samek, the 1st listed ip is the external IP of the machine
```curl ifconfig.co``` <- Will print extenral ip adress ot the machine
