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
    #below
    os.environ["TMPDIR"] = options.tmpdir
    print("setting TMPDIR to:", os.environ["TMPDIR"])

    print(os.environ)

    cmd = ["dockstore", "tool", "launch", "--debug", "--entry", options.docker_image, "--json", options.json_file]
    print("command to run:\n",cmd)
    output = subprocess.call(cmd)
    print("dockstore command call output is:\n", output)

                            
    print("----- %s seconds -----" % (time.time() - start_time), file=sys.stderr)
                        
if __name__=="__main__":
     sys.exit(__main__(sys.argv))

