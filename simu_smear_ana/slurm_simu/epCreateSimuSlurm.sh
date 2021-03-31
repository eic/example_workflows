#!/bin/env bash

export EIC_LEVEL=dev
source /cvmfs/eic.opensciencegrid.org/x8664_sl7/MCEG/releases/etc/eic_bash.sh

echo START
date

run=${SLURM_ARRAY_JOB_ID:-1}
number=${SLURM_ARRAY_TASK_ID:-1}

Q2MIN=${1:-0.00001}
Q2MAX=${2:-1.0}

ENRG=${3:-10}
PNRG=${4:-100}

OUTPUT_DIR=`readlink -f $5`
PAYLOAD_DIR=`readlink -f $6`

KT=1.0

WRKDIR=${OUTPUT_DIR}/slurm
TREEDEST=${OUTPUT_DIR}/TREES
TXTDEST=${OUTPUT_DIR}/TXTFILES
LOGDEST=${OUTPUT_DIR}/LOGFILES

# Specific name base for output and logfiles
NAMEBASE="pythia.ep.${ENRG}x${PNRG}.1Mevents.RadCor=0.Q2=$Q2MIN-$Q2MAX.kT=${KT}_$number"

# Set up steering file in the working directory
## - A placeholder is in the steer template for ease of reading
## - sed with a generic pattern is dangerous though (e.g., can contain '/')
## - so instead delete the first line and write it anew
echo ${NAMEBASE}.txt > $WRKDIR/tmp_${number}.txt
tail -n +2 $PAYLOAD_DIR/ep_steer_template.txt >> $WRKDIR/tmp_${number}.txt

# change to Working Directory
cd $WRKDIR

# Run Pythia
pythiaeRHIC < tmp_${number}.txt > ${LOGDEST}/${NAMEBASE}.log

# Remove Steering File
rm tmp_${number}.txt

# Move .txt File to Proper Location
mv ${NAMEBASE}.txt $TXTDEST

# Create Tree
root -b -l -q $PAYLOAD_DIR/genTree.C\(\"${TXTDEST}/${NAMEBASE}.txt\",\"${TREEDEST}\"\)

date
