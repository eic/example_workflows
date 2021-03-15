#!/bin/bash

BASEDIR=`dirname $0`
BASEDIR=`readlink -f ${BASEDIR}`
OUTPUT=${BASEDIR}/output
SCRIPT=${BASEDIR}/epCreateSimu.sh
LIMIT=${1:-10}
Q2LO=${2:-0.00001}
Q2HI=${3:-1.0}
ENRG=${4:-10}
PNRG=${5:-100}

echo "`basename ${SCRIPT}` for Q2 from ${Q2LO} to ${Q2HI}, Ee=${ENRG}, Ep=${PNRG} (${LIMIT} jobs)"

sbatch --account=eic --partition=production --mem-per-cpu=2G --time=1-00:00:00 --constraint=farm18 --array=1-${LIMIT} \
  ${SCRIPT} ${OUTPUT} ${Q2LO} ${Q2HI} ${ENRG} ${PNRG}
