#!/bin/bash

## PBS -l select=1:ncpus=36:mpiprocs=16+28:ncpus=36:mpiprocs=36
#PBS -l nodes=24:ppn=28
## PBS -q standard
#PBS -A HPCMO34140001
#PBS -j oe
#PBS -l walltime=23:59:00
#PBS -N gdft-grad-b1024
#PBS -V

#==============================
#### ---- Usage ----
#### [arg1: ncores_total] [arg2: ncores_per_node]
#==============================

ncores=${1:-392}
ncores_per_node=${2:-28}

USER=`whoami`
export WORKDIR=/home/$USER/benchmarks/GAMESS

#==============================
#  Required ABTP Prolog
#==============================
ABTP_JOBID=`echo ${PBS_JOBID} | cut -d. -f1`
echo " "
echo "++++ ABTP ++++ gamess_dft-grad-b_1024 queued:   `cat ${PBS_O_WORKDIR}/gamess_dft-grad-b_1024_${ABTP_JOBID}.qdate`"
echo "++++ ABTP ++++ gamess_dft-grad-b_1024 began:    `date`"
echo "++++ ABTP ++++ gamess_dft-grad-b_1024 hostname: `hostname`"
echo "++++ ABTP ++++ gamess_dft-grad-b_1024 uname -a: `uname -a`"
echo " "

#==============================
#  System specific commands
#==============================
ABTP_JOBDIR="${WORKDIR}/gamess_dft-grad-b_1024_${ABTP_JOBID}"
ABTP_APPDIR="${WORKDIR}/ABTP/app/gamess"
ABTP_CASEDIR="${WORKDIR}/ABTP/ded/gamess/dft-grad-b"

mkdir ${ABTP_JOBDIR}
cd ${ABTP_JOBDIR}
cp ${ABTP_CASEDIR}/input/dft-grad-b.inp .
cp ${ABTP_CASEDIR}/ref/accuracyCheck_DFT_GRAD-B.pl .

ulimit -c 0
ulimit -a

#==============================
#  Application specific commands
#==============================
export GAMESSBIN=${ABTP_APPDIR}/bin

#==============================
# Run GAMESS
#==============================
TBEGIN=`echo "print time();" | perl`

let NNODES=($ncores+$ncores_per_node-1)/$ncores_per_node ; echo $NNODES
echo "$GAMESSBIN/rungms ${input_file} ${codeversion} ${ncores} ${ncores_per_node} ${NNODES}"
#time $GAMESSBIN/rungms dft-grad-b 00 1024 36 | tee tmp.o${ABTP_JOBID}
time $GAMESSBIN/rungms.docker dft-grad-b 00 ${ncores} ${ncores_per_node} ${NNODES} | tee tmp.o${ABTP_JOBID}

TEND=`echo "print time();" | perl`

#==============================
# Required ABTP Epilog
#==============================
echo " "
echo "++++ ABTP ++++ gamess_dft-grad-b_1024 pwd:      `pwd`"
echo "++++ ABTP ++++ gamess_dft-grad-b_1024 ls -al:"
echo " "
ls -al
echo " "
echo "++++ ABTP ++++ gamess_dft-grad-b_1024 ended:    `date`"
echo "++++ ABTP ++++ gamess_dft-grad-b_1024 walltime: `expr ${TEND} - ${TBEGIN}` seconds  `./accuracyCheck_DFT_GRAD-B.pl tmp.o${PBS_JOBID}`"



exit
