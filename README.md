GradingScripts
==============

This repo is dedicated to the set of scripts I've developed to improve my 
grading workflow, as a Student Lab Instructor at RIT.  

These are scripts that I have developed from scratch to fit my workflow needs,
but you are free to use these yourself.

Setup
-----
It is highly suggested that you add sym links to these scripts that are 
in a directory that is in your path.

For example:
```shell
#make a bin directory to store runnable scripts
mkdir ~/bin
#create a sym link to the scripts
ln -s ~/GradingScripts/organize.sh ~/organize.sh
#add the bin to your path in your .bashrc
echo PATH=$PATH:~/bin >> .bashrc
```
This is because all the scripts do work locally (although you can include paths
for all file arguments). i.e. You want to run these scripts where you store 
your class submissions.

organize.sh
-----------
This script takes the .zip files from myCourses and organizes by the entries
by lab number and student into the local (currenti) directory.

Files are sorted into folders by last name, first name, and the UniqueID given
by myCourses. The naming scheme is meant to make for easy navigation in a text
only environment.

The final path looks something like this:
```shell
lab#/LastName_FirstName_UID/filesSubmitted.py
```

This script also handles and corrects for common file submission mistakes, like
submitting a folder with the same name as the zip, in the zip and deleting the 
unwanted hidden "MACOSX" folder created by Mac systems.

```shell
Usage: ./organize.sh [-c] [-f] [-l] [-o] [-q] [due date] file.zip [file(s) ...]
```
<dl>
  <dt>-c</dt>
  <dd>Cleans up (removes) the .zip files passed in after processing</dd>
  <dt>-f</dt>
  <dd>Creates user folders by first-last name order (instead of last-first)</dd>
  <dt>-l</dt>
  <dd>Marks late folders. This requires the due date to be specified.</dd>
  <dt>-o</dt>
  <dd>Cleans up (removes) old submissions. Keeps only the latest files</dd>
  <dt>-q</dt>
  <dd>Quiet mode. Suppresses most output.</dd>
</dl>
