#!/bin/bash -x 

#### ---- HPC Cores Setup ----
ncores=${1:-392}
ncores_per_node=${2:-28}
let NNODES=($ncores+$ncores_per_node-1)/$ncores_per_node

MY_DIR="$(dirname $(readlink -f $0))"
MY_HOME="$HOME"

#### ---- PBS Setup ----
## Submit the job with a specific name
#MSUB -N singularity_gamess
## Specify resources
#MSUB  -l nodes=1,walltime=1:00 -W ENVREQUESTED:TRUE 
## Combine the standard out and standard error in the same output file
#MSUB -j oe
#MSUB -o singularity_gamess.out
## Pass environment variables
#MSUB -E

#### ---- Pull docker image down ----
## Before running, make sure you have the image downloaded in the folder 
## with custom local image name
# singularity pull --name docker-gamess.simg docker://openkbs/docker-gamess 
# 

##IMAGE_PATH=shub://openkbs
IMAGE_PATH=docker://openkbs
IMAGE_TAG=docker-hpc-gamess-ubuntu
IMAGE_NAME=${IMAGE_TAG}.simg
if [ ! -e "${IMAGE_NAME}" ]; then
    # singularity pull --name docker-gamess.simg docker://openkbs/docker-gamess # with custom name
    singularity pull --name ${IMAGE_NAME} ${IMAGE_PATH}/${IMAGE_TAG}
else
    echo "Docker image: ${IMAGE_NAME} already existing!"
fi

#### ---- Sigularity to run PBS ----
## Move into user's working directory
cd $PBS_O_WORKDIR
## ref: http://singularity.lbl.gov/docs-usage
## Run Singularity Container
## /usr/local/bin/singularity run funny.simg

INPUT_PATH=${MY_DIR}
GAMESS_RUN=/home/root/benchmarks/GAMESS/ABTP/ded/gamess/dft-grad-b/gamess_dft-grad-b.bat
singularity run ${INPUT_PATH}/${IMAGE_NAME} ${GAMESS_RUN} "$ncores" "$ncores_per_node" "$NNODES"

echo "Job submitted by $PBS_O_LOGNAME ran on $HOSTNAME"
