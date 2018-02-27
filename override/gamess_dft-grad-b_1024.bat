#!/bin/bash

#### ---- Usage ----
#### [arg1: ncores_total] [arg2: ncores_per_node]

USER=`whoami`
export WORKDIR=/home/$USER/benchmarks/GAMESS
#ncores=${1:-672}
#ncores_per_node=${2:-28}

#==============================
#  Required ABTP Prolog
#==============================
#ABTP_JOBID=`echo ${PBS_JOBID} | cut -d. -f1`
ABTP_JOBID=job001
echo " "
echo "++++ ABTP ++++ gamess_dft-grad-b_1024 began:    `date`"
echo "++++ ABTP ++++ gamess_dft-grad-b_1024 hostname: `hostname`"
echo "++++ ABTP ++++ gamess_dft-grad-b_1024 uname -a: `uname -a`"
echo " "

#==============================
#  System specific commands
#==============================
ABTP_JOBDIR="${WORKDIR}/gamess_dft-grad-b_1024_${ABTP_JOBID}"
export ABTP_APPDIR="${WORKDIR}/ABTP/app/gamess"
export ABTP_CASEDIR="${WORKDIR}/ABTP/ded/gamess/dft-grad-b"

mkdir ${ABTP_JOBDIR}
cd ${ABTP_JOBDIR}
cp ${ABTP_CASEDIR}/input/dft-grad-b.inp .
cp ${ABTP_CASEDIR}/ref/accuracyCheck_DFT_GRAD-B.pl .

ulimit -c 0
ulimit -a

#==============================
#  Application specific commands
#==============================
export GAMESSBIN=${GAMESSBIN:-${ABTP_APPDIR}/bin}

#==============================
# Run GAMESS
#==============================
TBEGIN=`echo "print time();" | perl`
##### ---------------------------
##### ---- modified by RSheu ----
##### ---------------------------
#####
#input_file=${1:-dft-grad-b}
#codeversion=${2:-00}

#echo "$GAMESSBIN/rungms ${input_file} ${codeversion} ${ncores} ${ncores_per_node}"
#time $GAMESSBIN/rungms dft-grad-b 00 1 | tee tmp.o${PBS_JOBID}
#time $GAMESSBIN/rungms ${input_file} ${codeversion} ${ncores} ${ncores_per_node} | tee tmp.o${ABTP_JOBID}
#time $GAMESSBIN/rungms.mpi dft-grad-b 00 672 28| tee tmp.o${ABTP_JOBID}
time $GAMESSBIN/rungms.mpi dft-grad-b 00 ${ncores} ${ncores_per_node}| tee tmp.o${ABTP_JOBID}
##### (Original lines)
#time $GAMESSBIN/rungms dft-grad-b 00 1024 36 | tee tmp.o${ABTP_JOBID}

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
