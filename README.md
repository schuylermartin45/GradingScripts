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
by lab number and student into the local (current) directory.

Files are sorted into folders by last-first name (or first-last with the
appropriate flag) and the UniqueID given by myCourses. The naming scheme is 
meant to make for easy navigation in a text only environment.

The final path looks something like this:
```shell
lab[id]/sec_[id]/LastName_FirstName_UID/filesSubmitted.py
```

This script also handles and corrects for common file submission mistakes, like
submitting a folder with the same name as the zip in the zip, and deleting the 
unwanted hidden "MACOSX" folder created by Mac systems.

**Usage**
```shell
Usage: ./organize.sh [-c] [-f] [-l] [-o] [-q] [-s] [due_date] file.zip [file(s) ...]
```
<dl>
  <dt>-c</dt>
  <dd>Cleans up (removes) the .zip files passed in after processing</dd>
  <dt>-f</dt>
  <dd>Creates user folders by first-last name order (instead of last-first)</dd>
  <dt>-l</dt>
  <dd>Marks late folders. This requires the due date to be specified.</dd>
  <dd>**Note(1):** date must be in a Unix accepted format (see date command)</dd>
  <dd>and entering a due date without a specified hour defaults to 00:00 </dd>
  <dd>meaning if something is due at midnight of 1/2/2014 you'll want to</dd>
  <dd>specify "1/2/2014 23:59", "1/3/2014", etc</dd>
  <dd>**Note(2):** although this functionality technically works, please be</dd>
  <dd>advised that myCourses occasionally modifies submission time stamps.</dd>
  <dt>-o</dt>
  <dd>Cleans up (removes) old submissions. Keeps only the latest files</dd>
  <dt>-q</dt>
  <dd>Quiet mode. Suppresses most output.</dd>
  <dt>-s</dt>
  <dd>Organizes zips by section names based on order passed-in</dd>
  <dd>(As of Fall 2014, all students register under the same SLI section)</dd>
</dl>

**Note:** you can pass-in and process multiple lab submissions on a single
run. The first zip will be labeled as "sec_a" (as in section A) as a 
subdirectory of the lab# folder. The next zip file will be "sec_b", and so
on. This is regardless of the lab number and based purely on the positinal
arrangement of the files passed in.

batchRun.sh
-----------
This script takes an organized lab directory and runs student submissions from
the specified executable file. It can handle text-based .py (CS1) and .java 
(CS2) submissions.

**Note:** Java support has not been tested on real student submissions; though
it has been tested by running a few short programs. Additional features may be
added/tweaked once I have access to actual submissions to test wih.

**Creating Tests**

Upon executing the script, you will be asked for a set of test parameters.
Test files placed in the 'test_files' directory can be accessible via a bash-ish
subsitution system. Enter $0 for the first file listed, $1 for the second, etc
and batchRun.sh will handle the pathing for you. All other arguments can be
passed-in "normally".

Each test also allows you to specify a single output file to diff against. 
These expected output files must be in the 'expected_output' directory in order
to be prompted by the script.

All the test output and diff files are then placed into the 'output' directory
of each student submission folder. Each output/diff file is labeled with the 
name of the executed file and test number.

**Note on Python projects:** CS1 does not expect students to use command line
arguments to pass-in information to the program. Instead, they use Python's
input prompts as a method of passing in file names and values. To get around
this, batchRun.sh replaces all spaces with newline characters and then pipes
that list of arguments into the Python program to simulate manual entry.

**tl;dr** Don't use spaces in file names passed into Python programs.

**Usage**
```shell
Usage: ./batchRun.sh [-q] [-t] [time_out] #_tests lab exec_file
```
<dl>
  <dt>-q</dt>
  <dd>Quiet mode. Suppresses most output.</dd>
  <dt>-t</dt>
  <dd>Specifies time-out. This is the amount of time to allow a program to</dd>
  <dd>execute. The default is 60 seconds. Man 'timeout' for more info.</dd>
  <dd>Note: if used, time-out becomes the first argument passed in.</dd>
</dl>

cheatCheck.sh
-------------
This script diffs student submisions against files and detects cheaters
by comparing against supplied solution files. The final report is stored in
"cheat_files/cheat_results.txt". Files to diff against must have the same base-
name as the student-submission file.

**Note:** this will not catch all cheaters, just the most obvious cases.

**Usage**
```shell
Usage: ./cheatCheck.sh [-q] lab file [files...]
```
<dl>
  <dt>-q</dt>
  <dd>Quiet mode. Suppresses most output.</dd>
</dl>
