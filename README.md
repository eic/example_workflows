# Example Workflows

This repo hosts a variety of examples or roles derived from real world use cases.
The goal is to streamline them into simple
and transparent scenarios that work in many different environments.

### pythia6 → eic-smear → histos
This example, found under the ``simu_smear_ana`` direcory,
features a full workflow from MC event generation to final plots and illustrates
- running external executables
- reading, writing, moving large amounts of data
- submission of multiple jobs

#### simu_payload
- ``ep_steer_template.txt`` is a steering card template to
  create 1M pythia6 events with ``pythiaeRHIC``,
- ``genTree.C`` is a very thin wrapper around eic-smear's ``BuildTree()``
  to transform the simulation output via eic-smear into ROOT trees

All other ``*_simu`` directories contain wrappers and other files
necessary to submit the simulation workflow to various farms.
In most cases, that consists of an executable wrapper, here a bash script
that differs little between the different submission methods,
and another script that prepares and executes the actual submission.

**Notes:**
- It is presumed that pythiaeRHIC, ROOT, and eic-smear are available
  and that PATH and LD_LIBRARY_PATH are set up correctly. This is achieved,
  wherever cvmfs is installed
  and ``CVMFS_REPOSITORIES`` contains ``eic.opensciencegrid.org``, via
```
setenv dev
source /cvmfs/eic.opensciencegrid.org/x8664_sl7/MCEG/releases/etc/eic_cshrc.csh
```
or
```
export EIC_LEVEL=dev
source /cvmfs/eic.opensciencegrid.org/x8664_sl7/MCEG/releases/etc/eic_bash.sh
```
- This workflow hides a subtlety: ``BuildTree()`` accepts the name of
a log file in addition to the input txt file.
Only if such a log file is available is full cross section
information saved in the ROOT tree.
However, often (as in this example), that argument is omitted. In that case,
``BuildTree()`` automatically searches for a log file
with a specific name in a specific location.
Therefore, the naming and directory structure (TREES, TXTFILES, LOGFILES)
as done in e.g. ``submit_to_condor.csh`` is important.


#### condor_simu
- The wrapper shell script ``epCreateSimuCondor.sh`` runs pythia,
  moves the result to a destination, then transforms it to a ROOT tree
  in another location. I does not contain any fixed paths.
- ``submit_to_condor.csh`` needs to be adapted to a local filesystem.
  It then creates the directory structure, sets up a configuration
  file with output redirects, and submits that file.

To run, make scripts executable and call ``submit_to_condor.csh``
with a destination directory (by default "."; not recommended),
e.g.
```
chmod u+x epCreateSimuCondor.sh
chmod u+x submit_to_condor.csh
./submit_to_condor.csh /gpfs02/eic/${USER}/scratch/submittest/generateSimu/ep
```

Further reading:
- https://research.cs.wisc.edu/htcondor/
- https://www.sdcc.bnl.gov/resources/htc/htcondor/quick-start-guide

#### slurm_simu
- The wrapper shell script ``epCreateSimuSlurm.sh`` runs pythia,
moves the result to a destination, then transforms it to a ROOT tree
in another location. I does not contain any fixed paths.
The only difference to ``epCreateSimuCondor.sh``
is the usage of ```SLURM_ARRAY_TASK_ID```.
Also, for this example directory creation is handled here in the wrapper.
- ``submit_to_slurm.sh`` needs to be adapted to a local filesystem.
  It submits to slurm using ```sbatch``` with appropriate flags.

To run, make scripts executable and call ``submit_to_slurm.sh``.
Optional command line arguments can be used to
customize simulation parameters, e.g.
```
chmod u+x epCreateSimuSlurm.sh
chmod u+x submit_to_slurm.sh
./submit_to_slurm.sh 5 10 0.00001 1.0 10 100
```

Further reading:
- https://slurm.schedmd.com/documentation.html
- https://scicomp.jlab.org/docs/slurm

#### Note
Both ``HTCondor`` and ``Slurm`` are sophisticated
and powerful workload managers. Torque/PBS would be another example.
But for the typical HEP/HENP workflow consisting of
- generate a list of files,
- split them up into chunks,
- dispatch jobs for these chunks and make the actual files visible to them,
- transfer the result to a specific location or data manager,

it is usually preferred to add another layer of abstraction and monitoring,
especially in the case of shared resources. For example, you may want to run
similar jobs at BNL which uses Condor for HTC, and at JLab or NERSC
which are Slurm-based. Below are currently available options for this.

#### sums_simu
Originally developed for the STAR collaboration, SUMS is now the
Simple Unified Meta Scheduler, and it is used outside of STAR as well.
Executables are found in
```
/afs/rhic.bnl.gov/star/packages/scripts/sums-submit
/afs/rhic.bnl.gov/star/packages/scripts/sums-submit-template
```

Its basic concept is that users describe the intended workflow in an
XML file and leave the details of figuring out file locations,
resources, queue, etc. to sums.

This directory contains three examples. The first two use a wrapper approach:
- The wrapper shell script ``epCreateSimuSums.sh`` runs pythia,
moves the result to a destination, then transforms it to a ROOT tree in another location.
I does not contain any fixed paths. The main change with respect to
``epCreateSimuCondor.sh`` is that no separate work directory is needed,
nor any information about the original source directory,
because the payload code is sandboxed and transported into a
job-local scratch directory.

1. ``sums_notemplate.xml`` is the most simple and straightforward example.
Notably, all simulation parameters and paths are hard-coded and need to be adapted. Afterward, you can simply submit via
```
subms-submit sums_notemplate.xml
```
1. ``sums_template.xml`` fixes this. Parameters are transmitted via
  xml entities like ``&Q2LO;``. Setup and submission
  (ultimately via ``sums-submit-template``) is done via
  ```
  chmod u_x submit_sums_template.csh
  ./submit_sums_template.csh
  ```
1. The final and most preferred example in ``altsums_template.xml``
does away with a wrapper script altogether.
The commands to execute are part of the ``<command>`` block in the xml.
More importantly, file transfer is prescribed via  ``<output>`` tags,
the executed code needs no further information and stays in its sandbox.
Setup and submission via
```
chmod u_x submit_altsums_template.csh
./submit_altsums_template.csh
```

Further reading:
- https://www.star.bnl.gov/public/comp/Grid/scheduler/manual.htm
- https://www.slideserve.com/alain/the-star-unified-meta-scheduler-sums-powerpoint-ppt-presentation

#### panda_simu
Originally developed for the ATLAS collaboration, the
Production ANd Distributed Analysis is used or projected to be used for a number
of other experiments as well in the form of the BigPanDA project.

Prerequisites:
- Python3. I used python 3.8 from a local spack installation
- panda-client. One option:
```
pip install panda-client
```
But I instead used
```
git clone git://github.com/PanDAWMS/panda-client.git
python setup.py install --prefix=~/install
```
- Modify ``env.sh`` or ``env.csh`` to point to the correct
``[panda-client-install-directory]/etc/panda/panda_setup.[c]sh``
- Register here: https://panda-iam-doma.cern.ch/. Kolja is manager of the EIC group but has as yet no experience how this registration would proceed.

Job submission:

**Important:** Jobs are run under a different user account, namely ``osgeic``, so destination directories need to be group-writable and generated files as well. In ATLAS, PanDA works hand in hand with Rucio; for the EIC, exploring interactions with file management services will be explored in the next step.

- The wrapper shell script ``epCreateSimuPanda.sh`` runs pythia,
moves the result to a destination, then transforms it to a ROOT tree in another location. I does not contain any fixed paths.
Changes with respect to ``epCreateSimuCondor.sh``:
   - Sourcing of the environment shell script is moved to another file. Purely cosmetic.
   - Added ``umask 0002`` to allow the submitter to manipulate the generated files.
- ``env.[c]sh`` set up PanDA environment variables
- ``submit_to_panda.py`` needs to be adapted to a local filesystem.
  It creates the directory structure with appropriate permissions, and then
  submits by populating ```taskParamMap```.
  For setting up the only difference between jobs, the job number, ```inFileList``` is used as a dummy.
```
source env.csh
python3 submit_to_panda.py
```
Then a user gets a temporary link like:
https://panda-iam-doma.cern.ch/device?user_code=AZ5VYC
Open it in the browser and follow instructions.
This token is currently good for one day.

Monitoring is provided here: https://panda-doma.cern.ch/
URLs usually encodes parameters to shortcut access to the information needed. E.g.: https://panda-doma.cern.ch/task/460/

You may find it useful to install CERN certificates for your browser from
https://cafiles.cern.ch/cafiles/certificates/list.aspx?ca=grid
(Note that the instructions are sparse. On a Mac, it is also necessary
to double-click the certificates and then explicitly trust them)

To kill a task from the command line:
```
python
>>> from pandatools import Client
>>> Client.killTask(466)
```

Further reading:
- https://twiki.cern.ch/twiki/bin/view/PanDA/PanDA
- Please contact Kolja for a more detailed Howto google doc.

## Some thoughts and open questions
**Sandboxing** is very convenient. Last time I checked,
  Condor had no (simple) tools for that. How do **PanDA** and **Slurm** do it?

**logfiles and other helper files**:
- **SUMS** is very chatty, and the created files are cryptic. For every task it creates:
    - [longhash].session.xml in the user directory.
    This is the file to use to modify, kill, resubmit a task.
    - $USER.log in the user directory.
    - schedTemplateExp.xml if using the templated version
    - [longhash]\_[jobnumber].list, [longhash]\_[jobnumber].csh, and [longhash].condor, [longhash].report in the \<generator\> directory.

    That's not necessarily bad, but it would be nice to have options for cleanup, suppression, or more intuitively named files.
- **PanDA** provides a wealth of information from the web interface, but it would be good to have a way to route (copies of?)
log files, stdout, stderr files similar to SUMS' \<stdout URL= ... \> feature.
- **Slurm**: TBD. I haven't tested yet

Both **PanDA** and **SUMS** combine stdout from the payload with
(rather large amounts of) additional output from the wrappers/pilots.
A simple way to separate out the parts generated
by the true payload would be helpful. 
