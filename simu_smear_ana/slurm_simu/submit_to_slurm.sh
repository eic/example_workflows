#!/bin/bash

SOURCE_DIR=`dirname $0`
SOURCE_DIR=`readlink -f ${SOURCE_DIR}`
# OUTPUT=${SOURCE_DIR}/output
OUTPUT=${HOME}/work/slurmtest

WRKDIR=${OUTPUT}/slurm
TREEDEST=${OUTPUT}/TREES
TXTDEST=${OUTPUT}/TXTFILES
LOGDEST=${OUTPUT}/LOGFILES

mkdir -p ${WRKDIR} ${TREEDEST} ${TXTDEST} ${LOGDEST}


SCRIPT=${SOURCE_DIR}/epCreateSimuSlurm.sh
PAYLOAD_DIR=${SOURCE_DIR}/../simu_payload

LIMIT=${1:-5}
Q2LO=${2:-0.00001}
Q2HI=${3:-1.0}
ENRG=${4:-10}
PNRG=${5:-100}

echo "`basename ${SCRIPT}` for Q2 from ${Q2LO} to ${Q2HI}, Ee=${ENRG}, Ep=${PNRG} (${LIMIT} jobs)"

sbatch --account=eic --partition=production \
  --mem-per-cpu=2G --time=1-00:00:00 --constraint=farm18 \
  --array=1-${LIMIT} \
  -e ${WRKDIR}/slurm-%j.err -o ${WRKDIR}/slurm-%j.out \
  ${SCRIPT} ${Q2LO} ${Q2HI} ${ENRG} ${PNRG} ${OUTPUT} ${PAYLOAD_DIR}
