#!/bin/bash

export EIC_LEVEL=dev
source /cvmfs/eic.opensciencegrid.org/x8664_sl7/MCEG/releases/etc/eic_bash.sh

echo START

date

run=${SLURM_ARRAY_JOB_ID:-1}
number=${SLURM_ARRAY_TASK_ID:-1}

BASEDIR=`readlink -f $1`

Q2MIN=${2:-0.00001}
Q2MAX=${3:-1.0}

ENRG=${4:-10}
PNRG=${5:-100}

KT=1.0

WRKDIR=${BASEDIR}/condor
TREEDEST=${BASEDIR}/TREES
TXTDEST=${BASEDIR}/TXTFILES
LOGDEST=${BASEDIR}/LOGFILES

mkdir -p ${WRKDIR} ${TREEDEST} ${TXTDEST} ${LOGDEST}

# Specific name base for output and logfiles
NAMEBASE="pythia.ep.${ENRG}x${PNRG}.1Mevents.RadCor=0.Q2=$Q2MIN-$Q2MAX.kT=${KT}_$number"

# Set up steering file in the working directory
## - A placeholder is in the steer template for ease of readin
## - sed with a generic pattern is dangerous though (e.g., can contain '/')
## - so instead delete the first line and write it anew
echo ${NAMEBASE}.txt > $WRKDIR/tmp_${number}.txt #! output file name
tail -n +2 ep_steer_template.txt >> $WRKDIR/tmp_${number}.txt #! output file name

# copy over the root script - wasteful but flexible
cp -u genTree.C $WRKDIR/genTree.C

# change to Working Directory
cd $WRKDIR

# Run Pythia
pythiaeRHIC < tmp_${number}.txt > ${LOGDEST}/${NAMEBASE}.log

# Remove Steering File
rm tmp_${number}.txt

# Move .txt File to Proper Location
mv ${NAMEBASE}.txt $TXTDEST

# Create Tree
root -b -l -q $WRKDIR/genTree.C\(\"${TXTDEST}/${NAMEBASE}.txt\",\"${TREEDEST}\"\)

date




