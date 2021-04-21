#! /bin/env csh

# Output Directory
set OUTPUT_DIR = /gpfs02/eic/${USER}/scratch/submittest/generateSimu/sums

if ($#argv > 0) then 
    set OUTPUT_DIR = $1
endif

# Payload location - will be copied into a sandbox
set PAYLOAD_DIR = `pwd`/../simu_payload/
if ($#argv > 1) then 
    set PAYLOAD_DIR = $2
endif
set EXECUTABLE   = "epCreateSimuCondor.sh"

# Make sure structure exists
mkdir -pv ${OUTPUT_DIR}/scheduler || exit
mkdir -pv ${OUTPUT_DIR}/TREES
mkdir -pv ${OUTPUT_DIR}/TXTFILES
mkdir -pv ${OUTPUT_DIR}/LOGFILES

# Simulation parameters
set LIMIT = 5
set Q2LO = 0.00001
set Q2HI = 1.0
set ENRG = 10
set PNRG = 100

sums-submit-template -template sums_template.xml -entities \
    LIMIT=$LIMIT,Q2LO=$Q2LO,Q2HI=$Q2HI,ENRG=$ENRG,PNRG=$ENRG,OUTPUT_DIR=$OUTPUT_DIR,PAYLOAD_DIR=$PAYLOAD_DIR

