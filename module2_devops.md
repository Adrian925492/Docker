# Docker DevOps features

## Basic official Linux distributions images:
* Debian (up to 50 Mb) package manager: apt; apt-get; slim versions existing
* Ubuntu (up to 60 Mb) package manager: apt, apt-get; xlim version existing
* Fedora (up to 90 Mb) package manager: dnf; 
* CentOS (up to 75 Mb) package manager: yum;
* Alpine (up to 5 Mb) package manager: apk; created especially for docker containers - the lightest

## Tips

### Cmd cat tool

**Cmd cat** is a build in docker tool that allows to generate simple container with desired toolchain.
```
cmd.cat/bash/ngrep/git
```
Will generate container with bash, git and ngrep tool. We can use it as a normal image, for example in docker run command like:
```
cmd.cat/bash/ngrep/git
```

### Accesing to container threw other container

Assuming example, when we have container A without some tool (ex. bash schell), and we want to use bash inside the container B, we can:
1. Install desired bash tool inside container A
2. Connect by other container B in container A pid and net container mode - then we will get access to network and process nemaspace of container A threw container B. We can go to filesystem of the container by moving to /proc/1/root <- which presents file system of the pid1 process running in container (as we have same pid namespace) A. Here still we need to install desired tools. Example: ``` docker run -it --net container:A --pid container:A B ```
4. Same as with mode 2, but use cmd.cat tool to generate container with appropriate tools, threw which we will access to container A. Example: ``` docker run -it --net container:A --pid container:A cmd.cat/bash ```
5. Use **cntr** tool. The tool will allow us to use all host machine tools inside the container. In cntr, after attaching to the contaienr, we have access to container filesystem in */var/lib/cntr*, and to host filesystem in */* path.
6. Use **nsenter** command to enter the namespace of the container that uses process of PID equal any proces in desired container, and then run desired tool inside the namespace.

! If we are in root directory of the container, the docker add special **.dockerenv** file in it. It can be used to see if we are in docker conttainer file system, or not.

### Using contenerized versions of some tools

If we have not some tool on host os, or we ant to use its contenerized version, we can do it by 
```docker run -i --rm <image> <command>```
instead of just ```<command>```

The docker will look for apropriate image for us and run the comand inside it.

If we want to use contenerized command as normal one, we can add an alias!


