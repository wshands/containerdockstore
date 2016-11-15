#!/usr/bin/env python 
from __future__ import print_function, division
""" 
    author Walt Shands 
    jshands@ucsc.com 
        


"""
import sys, argparse, os
import time
import subprocess
import datetime

from distutils.dir_util import copy_tree

def parse_arguments():
    """
    Parse Command Line
    """
    parser = argparse.ArgumentParser(description='Script to launch a Dockstore'
                               ' container from a Dockstore launched container')
    parser.add_argument('-i', '--docker_image', type=str, required=True,
                        help='Path to Docker image, e.g. /path/to/image to use to launch container')

    parser.add_argument('-j', '--json_file', type=str, required=True,
                        help='Path to JSON file, e.g. /path/to/JSON input file for container to launch')

    parser.add_argument('-d', '--tmpdir', type=str, required=True,
                        help="Path to tmpdir, e.g. /path/to/temporary directory for"
                        " container to write intermediate files.")

    options = parser.parse_args()


    return (options)

def __main__(args):
    """
    """
    start_time = time.time()

    options = parse_arguments()

    date_and_time_info = datetime.datetime.now()
    date_and_time = date_and_time_info.strftime("%d/%m/%y %H:%M")
    print("Current date and time:",date_and_time)

    #set the containers TMPDIR env variable to the same value as on the host so
    #the files written by dockstore in creating this container will be in the
    #place as those written by the container created by the dockstore command
    #belowi
    print("current OS env TMPDIR:", os.environ.get("TMPDIR"))
    os.environ["TMPDIR"] = options.tmpdir
    print("setting TMPDIR to:", os.environ["TMPDIR"])
    print("new OS env TMPDIR:", os.environ["TMPDIR"])

    #copy the contents of /home/ubuntu into the $HOME directory if different
    #so all the Dockstore files are available to the current user 
    #presumably $HOME is the current users HOME directory???
    #Docstore files were installed in the ubuntu users HOME directory in 
    #the Dockerfile when the image was built
    fromDirectory = "/home/ubuntu/Dockstore"
    toDockstoreDirectory = os.environ["HOME"] + "/Dockstore"
    print("HOME + Dockstore dir is {}".format(toDockstoreDirectory))
    if not os.path.isdir(toDockstoreDirectory) and fromDirectory != toDockstoreDirectory:
        print("copying {} to {}".format(fromDirectory, toDockstoreDirectory))
        copy_tree(fromDirectory, toDockstoreDirectory)
    fromDirectory = "/home/ubuntu/.dockstore"
    toDirectory = os.environ["HOME"] + "/.dockstore"
    print("HOME + .dockstore dir is {}".format(toDirectory))
    if not os.path.isdir(toDirectory) and fromDirectory != toDirectory:
        print("copying %s to %s".format(fromDirectory, toDirectory))
        copy_tree(fromDirectory, toDirectory)


# Put the Docstore client on the path
#export PATH=/home/ubuntu/Dockstore/:$PATH
#export PATH=$HOME/bin:$PATH
    os.environ["PATH"] = toDockstoreDirectory + ":" + os.environ["PATH"]
    
#    cmd = ["which","dockstore"]
#    subprocess.call(cmd)


#    my_env = os.environ.copy()
#    my_env["TMPDIR"] = options.tmpdir

    print(os.environ)

    cmd = ["dockstore", "tool", "launch", "--debug", "--entry", options.docker_image, "--json", options.json_file]
    print("command to run:\n",cmd)
#    output = subprocess.call(cmd, env=my_env)
    output = subprocess.call(cmd)
    print("dockstore command call output is:\n", output)

                            

    
                        

    
    print("----- %s seconds -----" % (time.time() - start_time), file=sys.stderr)
                        
if __name__=="__main__":
     sys.exit(__main__(sys.argv))

