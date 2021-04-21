# Getting started with JLab for students! 



Table of contents
=================
<!--ts-->
* [Prerequisistes](#prerequisistes)
* [Credentials](#credentials)
* [Log in to your account](#log-in-to-your-account)
* [Using docker images](#using-docker-images)
  * [**Using Herwig and Rivet**](#using-herwig-and-rivet)
<!--te-->



First thing to do is to get your username (usr) and password (pswd) for the JLab account. This usr and pswd will the same as the one that you use to login to the remote system  you will be provided access to. The details to getting this are in the '**Credentials**' section below. But there are some steps to be taken before that. 

#### Prerequisistes

------------

1. Visit this [link](https://misportal.jlab.org/jlabAccess/guests "link") for new guest users.
2. Enter your preferred email.
3. Further instructions on setting up the pswd will sent to the email provided in the above step.
4. After logging into the site by following the instructions in the email, you will be shown a '**Checklist**' for your visiting period to be completed for before getting access to a JLab account.
5. Make sure to complete all the tasks with "<img src="https://www.pngkit.com/png/full/281-2818982_red-exclamation-point-png.png" width="20" height="20"> " icon are completed.
*Also, if you are going to use the account remotely, you just have to complete only the ones under "**Before Arrival**" and "**Required Skills**" checklist.*

\*A personal advice that I would like to give at this point is that, after the "**GEN034**" form completion, which is a web based security awareness training, given under "**Required Skills**" and selecting "**Credits for user**" you will see a document similar to the image below. [![GEN034](~/Pictures/Screenshots/GEN034.png "GEN034")](~/Pictures/Screenshots/GEN034.png "GEN034"). Press the 'lock' icon there to complete the training officially.

*The training is also available anytime in this [link](https://www.jlab.org/human_resources/training/webbasedtraining "security training")*.

#### Credentials
------------

1.  After completing the training, a email will be sent to the registered email ID with the username and instructions on acquiring the pswd from the helpdesk.
2. Remote users should sent an email to "helpdesk@jlab.org" asking for a online meeting to share the pswd. Don't forget to mention the time differences between your timezone and the helpdesk staff (EDT timezone) so that the meeting can be arranged convenietly. Here's a sample email for a student from India ( IST timezone) :

  > " *Dear Officials,*
  >
  >*My JLab Computer Account Request has been approved and processed, and I have received a JLab username. However, it's difficult for me to contact the help desk >or visit the CEBAF Center in person because I am in India and will be working remotely. I was advised to contact the helpdesk and request for an online meeting >in order to receive the password. So, could you kindly send me a bluejeans connection link or any other softwares' at any time that is convenient for you so that >the password can be issued? I also want to mention that although there is a time difference of 10.5 hour between the two time zones, I can be ready for the >meeting at any time if necessary.*
  >
  >*Yours Sincerely,* "

3. After scheduling the meeting remember to bring something to write on so that you can note down the further instructions that will be provided along with your pswd. Here's the [link](https://jman.jlab.org/jpasswd "Password") for reseting the password.

#### Log in to your account

------------

After getting the credentials, the next step is to access your account through ssh.
-  [This](https://averagelinuxuser.com/how-to-install-and-use-ssh-on-linux/ "Linux ssh") is a good set of instructions for linux users to follow. ( *Ignore the 'Configure SSH on a Remote Computer' and 'Install SSH server' sections as those are not required for users*. )

- Open up your terminal and type in ` ssh username@login.jlab.org`.\
You will get something like `username@login.jlab.org's password:`

- Now provide your password. The characters won't appear when you type in the password like that for *sudo* commands in linux. Don't worry just type your password and press enter.

- Now ssh into the farm you have been allowed access to like `ssh ifarm1234`

That's it. Now you can start using the terminal like the way you use it in your pc.]
Just type commands like `pwd` or `ls -a` if you want to test anything.

#### Using docker images

------------

Using docker inside your jlab system is not permitted due to security reasons. You can however, use singularity containers with your docker images. For a quick start follow the steps below:

- Type and enter `ls -a` into your terminal to see whether there is any file name `.login` (The 'dot' at the beginning is intentional). If it's already there skip the step below.
- Enter `touch .login` to create a newfile named '.login' (Vim users can also use `vim .login` and `:wq` later ).
- Paste the following into your newly created '.login' file.\
    ```
    #####
    # User specific additions should be added below.
    #####
    # source softenv.csh 2.3
    module load singularity
    setenv SINGULARITY_CACHEDIR .
    #exec bash
    ```
    You can uncomment ( remove '#' ) the last line `#exec bash` to always open up a bash shell when you login to your farm.

- Using singularity to pull docker images is very easy. If you want to pull a docker image like `docker pull example-name/example-image`, you can just enter `singularity pull docker://example-name/example-image`. That's all there is to it. You will have `.sif` file in your directory where you executed the command.\
*Also, singularity cache will be downloaded in `.singularity` folder in your home directory as you had specified with `setenv SINGULARITY_CACHEDIR .` in the above command ( The *' dot '* at the end of the command points to *' current working directory '* ).*

More details regarding the above singularity commands and singularity in general can be found in here, [Singularity at Jlab](https://jeffersonlab.github.io/swcarpentry-jlab-singularity/ "Singularity at Jlab").

###### **Using Herwig and Rivet**

- To make things clean and eay, let's create a directory called '*Project*'
	`mkdir Project`
	Now create another directory called '*EIC*'
	`mkdir EIC`
	*You can also do this both in a single command*  `mkdir -p Project/EIC`
	*If you want you can create extra folders like *' Herwig '* etc.*
- Now let's pull the docker image with Herwig 7.2.x and Rivet 3.1.\
Enter `singularity pull docker://graemenail/herwig-eic`
- To run the commands and use the scripts within the singularity container, there are two ways :
	1. **First**
		- You can run/exec the command along with the `.sif` images like example, if you want to run `Herwig` type `./herwig-eic_latest.sif Herwig` or `path/to/your/sif-image/herwig-eic_latest.sif Herwig`.\
		- For ease of use, you can create a file called **Activate** and paste the following into it:\
			```
			\#!/bin/bash

			alias Herwig='~/Project/EIC/SingleFolder/herwig-eic_latest.sif Herwig'

			alias rivet-mkhtml='~/Project/EIC/SingleFolder/herwig-eic_latest.sif rivet-mkhtml'

			alias rivet-build='~/Project/EIC/SingleFolder/herwig-eic_latest.sif rivet-build'

			alias rivet='~/Project/EIC/SingleFolder/herwig-eic_latest.sif rivet'

			alias mkplots='~/Project/EIC/SingleFolder/herwig-eic_latest.sif make-plots'
			```
		- Now everytime ypu want use Herwig or rivet commands enter `source Activate`
		*You can change the alias names above to your liking*.
	2. **Second** : Enter `singularity run ./herwig-eic_latest.sif sh` or `singularity run ./herwig-eic_latest.sif bash`.
