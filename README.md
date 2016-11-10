# containerdockstore

#we can run a dockstore command from this container like this:
```
docker run -it -w $(pwd) -e TMPDIR=$(pwd) -v $(pwd):$(pwd) -v /home/ubuntu:/home/ubuntu  -v /var/run/docker.sock:/var/run/docker.sock actioncontainer dockstore tool launch --entry quay.io/wshands/fastqc --json /home/ubuntu/fastqcwork/fastqc/fastqc.json
```
