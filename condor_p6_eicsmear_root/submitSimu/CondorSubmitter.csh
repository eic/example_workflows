#! /bin/env csh

set Exec = `pwd`/epCreateSimuCondor.sh

# Output Directory
# set Output = /gpfs02/eic/${USER}/scratch/submittest/generateSimu/ep
set Output = .

if ($#argv > 0) then 
    set Output = $1
endif

# make sure executable exists
#make $Exec || exit

####### Initialize condor file
echo ""  > CondorFile
echo "Universe     = vanilla" >> CondorFile
echo "Executable   = ${Exec}" >> CondorFile
echo "getenv = true" >> CondorFile

# Make sure structure exists

mkdir -p ${Output}/condor || exit
mkdir -p ${Output}/TREES
mkdir -p ${Output}/TXTFILES
mkdir -p ${Output}/LOGFILES

set NUMBER = 1
set LIMIT = 5
set Q2LO = 0.00001
set Q2HI = 1.0
set ENRG = 10
set PNRG = 100

while ( "$NUMBER" <= "$LIMIT" )

    set LogFile = ${Output}/condor/pythia.ep.${ENRG}x${PNRG}.1Mevents.RadCor=0.Q2=$Q2LO-$Q2HI.kT=1.0_$NUMBER.out
    set ErrFile = ${Output}/condor/pythia.ep.${ENRG}x${PNRG}.1Mevents.RadCor=0.Q2=$Q2LO-$Q2HI.kT=1.0_$NUMBER.err
    
    set Args = ( $NUMBER $Q2LO $Q2HI $ENRG $PNRG $Output )
    echo "" >> CondorFile
    echo "Output       = ${LogFile}" >> CondorFile
    echo "Error        = ${ErrFile}" >> CondorFile
    echo "Arguments    = ${Args}" >> CondorFile
    echo "Queue" >> CondorFile   

    echo Submitting:
    echo $Exec $Args
    echo "Logging output to " $LogFile
    echo "Logging errors to " $ErrFile
    echo

    @ NUMBER++

end

condor_submit CondorFile


