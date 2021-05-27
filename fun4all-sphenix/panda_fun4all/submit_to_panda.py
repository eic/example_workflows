import sys
from pandatools import Client
import os
import stat

# for ceonvenience
import getpass
USER = getpass.getuser()

OUTPUT_DIR = '/gpfs02/eic/'+USER+'/scratch/submittest/fun4all/panda/work'
PAYLOAD_DIR = os.getcwd()+'/../payload/'
EXECUTABLE = os.getcwd()+'/RunFun4allPanda.sh'
LIMIT=1

os.makedirs(OUTPUT_DIR, exist_ok=True)

# Make writable for osgeic user
os.chmod(OUTPUT_DIR, 0o775)

# Make executable for osgeic user
os.chmod(EXECUTABLE, 0o775)
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
taskParamMap['taskName'] = 'test EIC fun4all submission'
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
     source /cvmfs/sphenix.sdcc.bnl.gov/gcc-8.3/opt/sphenix/core/bin/sphenix_setup.sh -n new;
     echo """+task_command_line+""";
      """+task_command_line+""";"""
    },
    ]
print(Client.insertTaskParams(taskParamMap,verbose=True))
