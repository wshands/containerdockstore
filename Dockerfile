FROM ubuntu:latest

MAINTAINER Walt Shands jshands@ucsc.edu

WORKDIR ./

USER root

#COPY UCSCbcbioTool.py /usr/local/bin
#RUN chmod a+x /usr/local/bin/UCSCbcbioTool.py

# Install OpenJDK JRE, curl, python, python pip, and the docker client
RUN apt-get update && apt-get install --yes \
    openjdk-8-jre \
    curl \
    python \
    python-pip \
    docker.io

RUN pip install --upgrade pip

#install cwltool in the container
RUN pip install setuptools==24.0.3
RUN pip install cwl-runner cwltool==1.0.20160712154127 schema-salad==1.14.20160708181155 avro==1.8.1

#install cwltools
#RUN pip install cwl-runner==1.0.0
#RUN pip install cwlref-runner

# switch back to the ubuntu user so this tool (and the files written) are not owned by root
RUN groupadd -r -g 1000 ubuntu && useradd -r -g ubuntu -u 1000 ubuntu

#WILL NOT WORK THIS IS NOT RUNTIME SO THE CONTAINER WILL NEED TO RUN AS ROOT
#TO ACCESS THE EXTERNAL DOCKER docker.sock
#add the ubuntu user to the host docker group so ubuntu can execut docker commands
#we assume that a volume has been mounted to the host docker.sock file so
#that the containers docker.sock file is no longer visible.
#The group for the host's /var/run/docker.sock file is unknown to the container
#and is just an id. We need to get that group id and add unbuntu to that
#group so ubuntu can access the host's docker engine
#RUN usermod -a -G $(stat -c "%g" '/var/run/docker.sock') ubuntu

#since we have not figured out how to run as nonroot
#set the following env var so dockstore does not question
#the fact that we are running as root
ENV DOCKSTORE_ROOT 1

# create /home/ubuntu in the root as owned by ubuntu before switching to user ubuntu
RUN mkdir /home/ubuntu
RUN chown ubuntu:ubuntu /home/ubuntu

COPY .dockstore/ /home/ubuntu/.dockstore
RUN chown -R ubuntu:ubuntu /home/ubuntu/.dockstore

COPY Dockstore/ /home/ubuntu/Dockstore
RUN chown -R ubuntu:ubuntu /home/ubuntu/Dockstore

ENV PATH /home/ubuntu/Dockstore/:$PATH

#copy dockstore files to root so root can run dockstore
#otherwise for some reason dockstore tries to install
#dockstore files at /root if running dockstore from /home/ubuntu
COPY .dockstore/ /root/.dockstore
COPY Dockstore/ /root/Dockstore

#USER ubuntu 

