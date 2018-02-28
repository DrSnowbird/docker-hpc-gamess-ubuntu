#!/bin/bash
#
#### ---- Usage ----
##  run-gamess.sh <ncores> <ncores_per_node>

if [ $# -lt 2 ]; then
    echo "**** ERROR ****: submit-pbs.sh <ncores> <ncores_per_node> "
    exit 1
fi

#### ---- HPC Cores Setup ----
ncores=${1:-392}
ncores_per_node=${2:-28}
let NNODES=($ncores+$ncores_per_node-1)/$ncores_per_node
sed -i 's/##NNODES##/'$NNODES'/' `pwd`/submit-pbs-test.sh

#### ---- PBS/QSUB setup ----
abtp_jobid=`qsub submit-pbs.sh | cut -d. -f1`
date > gamess_dft-grad-b_1024_${abtp_jobid}.qdate
echo "gamess_dft-grad-b_1024 submitted, JobID = ${abtp_jobid}"
exit
