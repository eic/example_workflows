# Example Workflows

This repo hosts a variety of examples or roles derived from real world use cases. 
The goal is to streamline them into simple and transparent scenarios that work in many different environments.

### pythia6 → eic-smear → histos and plots with condor
This example features a full workflow from MC event generation to final plots and illustrates
- running external executables
- reading, writing, moving large amounts of data
- submission of multible jobs

##### condor_p6_eicsmear_root/submitSimu
- payload shell script <pre>epCreateSimuCondor.sh</pre> creates 1M pythia6
  events with <pre>pythiaeRHIC</pre>, moves the result to a destination, then transforms 
  it to a ROOT tree using <pre>genTree.C<pre>.
- <pre>genTree.C</pre> is a very thin wrapper around eic-smear's <pre>BuildTree()</pre>
- <pre>ep_steer_template.txt</pre> is a steering card template for pythia6, 
  with a placeholder for the output file name.
- CondorSubmitter.csh creates and submits a submit description file for five jobs

To run, make scripts executable and call CondorSubmitter.csh with a destination directory (by default "."; not recommended),
e.g.
```
chmod u+x CondorSubmitter.csh
chmod u+x epCreateSimuCondor.sh
./CondorSubmitter.csh /gpfs02/eic/kkauder/scratch/submittest/generateSimu/ep
```

**Important Note:** 
This workflow hides a subtlety: <pre>BuildTree()</pre> accepts the name of 
a log file in addition to the input txt file.
Only if such a log file is available is full cross section information saved in the ROOT tree.
However, often (as in this example), that argument is omitted. In that case, 
<pre>BuildTree()</pre> automatically searches for a log file with a specific name in a specific location.
Therefore, the naming and directory structure (TREES, TXTFILES, LOGFILES) 
as done in <pre>epCreateSimuCondor.sh</pre> is important. 





