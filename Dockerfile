# GCC support can be specified at major, minor, or micro version
# (e.g. 8, 8.2 or 8.2.0).
# See https://hub.docker.com/r/library/gcc/ for all supported GCC
# tags from Docker Hub.
# See https://docs.docker.com/samples/library/gcc/ for more on how to use this image
FROM ubuntu:latest

# Here we set maintainer information
MAINTAINER Adrian9254

# These commands copy your files into the specified directory in the image
# and set that as the working location
#COPY . /usr/src/myapp
#WORKDIR /usr/src/myapp

# This command compiles your app using GCC, adjust for your source code
RUN apt-get update

# Get coreutils
#RUN apt-get install coreutils

# Get compiler
#RUN apt-get -y install gcc

# Get gnu make
RUN apt-get install make

# Get g++ 
#RUN apt-get -y install g++

# Get mingw64 (for run under Windows)
RUN apt-get -y install mingw-w64

# Clear apt list
RUN rm -rf /var/lib/apt/lists/*

# Add volume - will be used to exchange files between container and output envinroment
VOLUME /Source

# Set working direcotry - source volume
WORKDIR /Source

# This command builds your application (by default)
#CMD make all

# Here we add some metadata, label and version information
LABEL Name=exampledockerfile Version=0.0.1
