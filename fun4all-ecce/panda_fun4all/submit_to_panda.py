import sys
from pandatools import Client
import os
import stat
import getpass

SetupStructure = True
if SetupStructure:
    # for convenience
    USER = getpass.getuser()

    OUTPUT_DIR = '/gpfs02/eic/'+USER+'/scratch/submittest/fun4all-ecce/panda/work'
    PAYLOAD_DIR = os.getcwd()+'/../payload/'
    EXECUTABLE = os.getcwd()+'/RunFun4allPanda.sh'
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    # Make writable for osgeic user
    os.chmod(OUTPUT_DIR, 0o775)

    # Make executable for osgeic user
    os.chmod(EXECUTABLE, 0o775)
else:
    # In order to submit from a different location, 
    # use fixed paths and rely on permissions being correct
    OUTPUT_DIR  = '/gpfs02/eic/eickolja/scratch/submittest/fun4all/panda/work'
    PAYLOAD_DIR = '/gpfs02/eic/kkauder/scratch/spacktest/example_workflows/fun4all-ecce/payload'
    EXECUTABLE  = '/gpfs02/eic/kkauder/scratch/spacktest/example_workflows/fun4all-ecce/panda_fun4all/RunFun4allPanda.sh'

# how many jobs
# Note: currently only 1 is supported (just needs some name finagling)
LIMIT=1

task_command_line = "{EXECUTABLE} {OUTPUT_DIR} {PAYLOAD_DIR}".format(EXECUTABLE=EXECUTABLE, OUTPUT_DIR=OUTPUT_DIR, PAYLOAD_DIR=PAYLOAD_DIR)

taskParamMap = {}
taskParamMap['vo'] = 'wlcg'
taskParamMap['site'] = 'BNL_OSG_1'
taskParamMap['workingGroup'] = 'EIC'
taskParamMap['nFilesPerJob'] = 1
inFileList = [str(i) for i in range(0, LIMIT)]
taskParamMap['nFiles'] = len(inFileList)
taskParamMap['noInput'] = True
taskParamMap['pfnList'] = inFileList
taskParamMap['taskName'] = 'test EIC fun4all ECCE submission'
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
taskParamMap['ramCount'] = 3000
taskParamMap['skipScout'] = True
taskParamMap['cloud'] = 'US'
taskParamMap['jobParameters'] = [
    {'type':'constant',
     'value':"""
     echo """+task_command_line+""";
      """+task_command_line+""";"""
    },
    ]
print(Client.insertTaskParams(taskParamMap,verbose=True))
