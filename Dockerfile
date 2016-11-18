FROM ubuntu:16.04

MAINTAINER Walt Shands jshands@ucsc.edu

WORKDIR ./

USER root

# Install OpenJDK JRE, curl, python, python pip, and the docker client
RUN apt-get update && apt-get install --yes \
    openjdk-8-jre \
    curl \
    python \
    python-pip \
    docker.io

RUN pip install --upgrade pip

#install cwltool in the container
#use the version required by dockstore
RUN pip install setuptools==24.0.3
RUN pip install cwl-runner cwltool==1.0.20160712154127 schema-salad==1.14.20160708181155 avro==1.8.1

#Patch the cwltool code that sets up the docker run command line
#so that it includes '-v /var/run/docker.sock:/var/run/docker.sock
#this will allow the docker run command generated by cwltools inside
#this container to access the host's docker engine
#and launch containers outside this container
#this patch addes code to job.py and assumes the file is at
#/usr/local/lib/python2.7/dist-packages/cwltool/job.py
#TODO?? make sure the path exists and the current version 
#of python is the right one?
COPY job.patch /usr/local/lib/python2.7/dist-packages/cwltool/job.patch
RUN patch -d /usr/local/lib/python2.7/dist-packages/cwltool/ < /usr/local/lib/python2.7/dist-packages/cwltool/job.patch

# switch back to the ubuntu user so this tool (and the files written) are not owned by root
RUN groupadd -r -g 1000 ubuntu && useradd -r -g ubuntu -u 1000 ubuntu

#create /home/ubuntu in the root as owned by ubuntu before switching to user ubuntu
RUN mkdir /home/ubuntu
RUN chown ubuntu:ubuntu /home/ubuntu

COPY .dockstore/ /home/ubuntu/.dockstore
RUN chown -R ubuntu:ubuntu /home/ubuntu/.dockstore

COPY Dockstore/ /home/ubuntu/Dockstore
RUN chown -R ubuntu:ubuntu /home/ubuntu/Dockstore

ENV PATH /home/ubuntu/Dockstore/:$PATH
#ENV HOME /home/ubuntu

#copy dockstore files to root so root can run dockstore
#otherwise for some reason dockstore tries to install
#dockstore files at /root if running dockstore from /home/ubuntu
COPY .dockstore/ /root/.dockstore
COPY Dockstore/ /root/Dockstore

ENV PATH /root/Dockstore/:$PATH
ENV HOME /root

COPY dockstore_tool_runner.py /usr/local/bin
RUN chmod a+x /usr/local/bin/dockstore_tool_runner.py

#since we have not figured out how to run as nonroot
#set the following env var so dockstore does not question
#the fact that we are running as root
ENV DOCKSTORE_ROOT 1

#container must run as root in order to access docker.sock on the host
#becuase ubuntu is not a member of the host's docker.sock docker group
#and there is no way to set this up at build time
USER root
#USER ubuntu

