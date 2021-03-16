import sys
from pandatools import Client
import os
import stat

OUTPUT_DIR = '/gpfs02/eic/kkauder/scratch/submittest/generateSimu/panda/'
SOURCE_DIR = '/gpfs02/eic/kkauder/scratch/spacktest/example_workflows/panda_p6_eicsmear_root/'
EXECUTABLE   = SOURCE_DIR+'epCreateSimuPanda.sh'

LIMIT = 3
Q2LO = 0.00001
Q2HI = 1.0
ENRG = 10
PNRG = 100

os.makedirs(OUTPUT_DIR + '/work', exist_ok=True)
os.makedirs(OUTPUT_DIR + '/TREES', exist_ok=True)
os.makedirs(OUTPUT_DIR + '/TXTFILES', exist_ok=True)
os.makedirs(OUTPUT_DIR + '/LOGFILES', exist_ok=True)

# Make writable for osgeic user
os.chmod(OUTPUT_DIR + '/work', 0o775)
os.chmod(OUTPUT_DIR + '/TREES', 0o775)
os.chmod(OUTPUT_DIR + '/TXTFILES', 0o775)
os.chmod(OUTPUT_DIR + '/LOGFILES', 0o775)

# Make executable for osgeic user
os.chmod(EXECUTABLE, 0o775)

output = "{OUTPUT_DIR}/work/pythia.ep.{ENRG}x{PNRG}.1Mevents.RadCor=0.Q2={Q2LO}-{Q2HI}.kT=1.0_${{IN/L}}.out".format(OUTPUT_DIR=OUTPUT_DIR, ENRG=ENRG,
                                                                                                                    PNRG=PNRG, Q2LO=Q2LO, Q2HI=Q2HI)
task_command_line = "{EXECUTABLE} ${{IN/L}} {Q2LO} {Q2HI} {ENRG} {PNRG} {OUTPUT} {SOURCE_DIR}".format(EXECUTABLE=EXECUTABLE, Q2LO=Q2LO, 
                                                                                                      Q2HI=Q2HI, ENRG=ENRG, PNRG=PNRG, OUTPUT=OUTPUT_DIR, SOURCE_DIR=SOURCE_DIR)

taskParamMap = {}
taskParamMap['vo'] = 'wlcg'
taskParamMap['site'] = 'BNL_OSG_1'
taskParamMap['workingGroup'] = 'EIC'
taskParamMap['nFilesPerJob'] = 1
inFileList = [str(i) for i in range(0, LIMIT)]
taskParamMap['nFiles'] = len(inFileList)
taskParamMap['noInput'] = True
taskParamMap['pfnList'] = inFileList
taskParamMap['taskName'] = 'test EIC submission'
taskParamMap['userName'] = 'A user Name'
taskParamMap['processingType'] = 'step1'
taskParamMap['prodSourceLabel'] = 'test'
taskParamMap['taskType'] = 'test'

taskParamMap['transPath'] = 'https://atlpan.web.cern.ch/atlpan/bash-c'
taskParamMap['taskPriority'] = 900
taskParamMap['architecture'] = ''
taskParamMap['transUses'] = ''
taskParamMap['transHome'] = None
#taskParamMap['coreCount'] = 1
taskParamMap['ramCount'] = 2000
taskParamMap['skipScout'] = True
taskParamMap['cloud'] = 'US'
taskParamMap['jobParameters'] = [
    {'type':'constant',
     'value':"""export EIC_LEVEL=dev;
      source /cvmfs/eic.opensciencegrid.org/x8664_sl7/MCEG/releases/etc/eic_bash.sh;
      echo """+task_command_line+""";
      """+task_command_line+""";"""
    },
    ]
print(Client.insertTaskParams(taskParamMap,verbose=True))
