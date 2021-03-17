#! /bin/env csh

# Output Directory
set OUTPUT_DIR = /gpfs02/eic/${USER}/scratch/submittest/generateSimu/ep
# set Output = .

if ($#argv > 0) then 
    set OUTPUT_DIR = $1
endif

set SOURCE_DIR = `pwd`
if ($#argv > 1) then 
    set SOURCE_DIR = $2
endif
set EXECUTABLE   = "${SOURCE_DIR}/epCreateSimuCondor.sh"

# make sure executable exists
#make $EXECUTABLE || exit

####### Initialize condor file
echo ""  > CondorFile
echo "Universe     = vanilla" >> CondorFile
echo "Executable   = ${EXECUTABLE}" >> CondorFile
echo "getenv = true" >> CondorFile

# Make sure structure exists

mkdir -p ${OUTPUT_DIR}/condor || exit
mkdir -p ${OUTPUT_DIR}/TREES
mkdir -p ${OUTPUT_DIR}/TXTFILES
mkdir -p ${OUTPUT_DIR}/LOGFILES

set NUMBER = 1
set LIMIT = 5
set Q2LO = 0.00001
set Q2HI = 1.0
set ENRG = 10
set PNRG = 100

while ( "$NUMBER" <= "$LIMIT" )

    set LogFile = ${OUTPUT_DIR}/condor/pythia.ep.${ENRG}x${PNRG}.1Mevents.RadCor=0.Q2=$Q2LO-$Q2HI.kT=1.0_$NUMBER.out
    set ErrFile = ${OUTPUT_DIR}/condor/pythia.ep.${ENRG}x${PNRG}.1Mevents.RadCor=0.Q2=$Q2LO-$Q2HI.kT=1.0_$NUMBER.err
    
    set Args = ( $NUMBER $Q2LO $Q2HI $ENRG $PNRG $OUTPUT_DIR $SOURCE_DIR )
    echo "" >> CondorFile
    echo "Output       = ${LogFile}" >> CondorFile
    echo "Error        = ${ErrFile}" >> CondorFile
    echo "Arguments    = ${Args}" >> CondorFile
    echo "Queue" >> CondorFile   

    echo Submitting:
    echo $EXECUTABLE $Args
    echo "Logging output to " $LogFile
    echo "Logging errors to " $ErrFile
    echo

    @ NUMBER++

end

condor_submit CondorFile


