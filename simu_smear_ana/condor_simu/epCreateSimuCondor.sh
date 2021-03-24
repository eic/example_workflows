#!/bin/env bash

echo START
date

number=$1

Q2MIN=$2
Q2MAX=$3

ENRG=$4
PNRG=$5

BASEDIR=$6
SOURCE_DIR=$7

KT=1.0

WRKDIR=${BASEDIR}/condor
TREEDEST=${BASEDIR}/TREES
TXTDEST=${BASEDIR}/TXTFILES
LOGDEST=${BASEDIR}/LOGFILES

# Specific name base for output and logfiles
NAMEBASE="pythia.ep.${ENRG}x${PNRG}.1Mevents.RadCor=0.Q2=$Q2MIN-$Q2MAX.kT=${KT}_$number"

# Set up steering file in the working directory
## - A placeholder is in the steer template for ease of reading
## - sed with a generic pattern is dangerous though (e.g., can contain '/')
## - so instead delete the first line and write it anew
echo ${NAMEBASE}.txt > $WRKDIR/tmp_${number}.txt
tail -n +2 $SOURCE_DIR/ep_steer_template.txt >> $WRKDIR/tmp_${number}.txt

# change to Working Directory
cd $WRKDIR

# Run Pythia
pythiaeRHIC < tmp_${number}.txt > ${LOGDEST}/${NAMEBASE}.log

# Remove Steering File
rm tmp_${number}.txt 

# Move .txt File to Proper Location
mv ${NAMEBASE}.txt $TXTDEST

# Create Tree
root -b -l -q $SOURCE_DIR/genTree.C\(\"${TXTDEST}/${NAMEBASE}.txt\",\"${TREEDEST}\"\)

date
