#!/usr/bin/env cwl-runner 

class: CommandLineTool
id: "actiontest"
label: "container that can run a container"
cwlVersion: v1.0 
doc: |
    ![build_status](https://quay.io/wshands/bare_bcbio/status)
    A Docker container for the bcbio command. 
    See the bcbio (http://bcbio-nextgen.readthedocs.io/en/latest/index.html) 
    website for more information.
    ```  
    Usage:
    # fetch CWL
    $> dockstore tool cwl --entry quay.io/wshands/bare_bcbio > cancer_variant_calling.cwl
    # make a runtime JSON template and edit it
    $> dockstore tool convert cwl2json --cwl cancer_variant_calling.cwl > cancer_variant_calling.json
    # run it locally with the Dockstore CLI
    $> dockstore tool launch --entry quay.io/wshands/bare_bcbio  --json cancer_variant_calling.json
    ```

#dct:creator:
#  "@id": "jshands@ucsc.edu"
#  foaf:name: Walt Shands
#  foaf:mbox: "jshands@ucsc.edu"


requirements: 
  - class: DockerRequirement 
#    dockerPull: "" 
    dockerImageId: actioncontainer 
  - class: EnvVarRequirement 
    envDef: 
      - envName: HOME 
        envValue: "/home/ubuntu" 
#        envValue: $(inputs.HOME) 
 
arguments: 
  - valueFrom: tool 
  - valueFrom: launch 
 
#  - type: 
#      type: array 
#      items: string 
#         valueFrom: ["tool", "launch"] 
 
#  - type: string[] 
#      valueFrom: ["tool", "launch"] 
 
#  - type: string[] 
#      valueFrom: ["tool launch"] 
 
 
 
hints: 
  - class: ResourceRequirement 
    coresMin: 1 
    ramMin: 4092 
    outdirMin: 512000 
    description: "the process requires at least 4G of RAM" 
 
inputs: 
  json_file: 
    type: File 
    doc: "Path to JSON file for container to be run by Dockstore" 
    inputBinding: 
      prefix: --json 
 
  docker_image: 
    type: string 
    doc: "Path to docker image frome which to create container" 
    inputBinding: 
      prefix: --entry 
 
#  docker_sock_file: 
#    type: Directory? 
#    doc: "Path to host's docker.sock file" 
 
outputs: 
  output_files: 
    type: 
      type: array 
      items: File 
    outputBinding: 
      # should be put in the working directory 
       glob: ./* 
    doc: "Result files from container run on the host" 
 
 
baseCommand: ["dockstore"] 
