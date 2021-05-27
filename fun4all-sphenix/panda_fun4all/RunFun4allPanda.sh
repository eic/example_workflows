#!/bin/env bash

# Allow group members to change or delete created files
umask 0002

echo START
date

# set up sphenix environment
source /cvmfs/sphenix.sdcc.bnl.gov/gcc-8.3/opt/sphenix/core/bin/sphenix_setup.sh -n new

WRKDIR=$1
PAYLOAD_DIR=$2

# Specific name base for output and logfiles
NAMEBASE="fun4all"
touch ${WRKDIR}/${NAMEBASE}.out
touch ${WRKDIR}/${NAMEBASE}.err

# change to Working Directory
cd $WRKDIR

# And do the work
ls -lhvc
env
ls -lhvc 1> ${WRKDIR}/${NAMEBASE}.out 2> ${WRKDIR}/${NAMEBASE}.err
env 1> ${WRKDIR}/${NAMEBASE}.out 2> ${WRKDIR}/${NAMEBASE}.err
cd ${WRKDIR} 1> ${WRKDIR}/${NAMEBASE}.out 2> ${WRKDIR}/${NAMEBASE}.err
cp -r ${PAYLOAD_DIR}/* .  1> ${WRKDIR}/${NAMEBASE}.out 2> ${WRKDIR}/${NAMEBASE}.err
root -l -b -q ${PAYLOAD_DIR}/Fun4All_G4_sPHENIX.C 1> ${WRKDIR}/${NAMEBASE}.out 2> ${WRKDIR}/${NAMEBASE}.err

# Could move or copy files to destinations here, via
# (mc) mv, cp
