#!/bin/bash

#Make relative path absolute
if [[ "$1" = /* ]]
then
	par1=$1
else
	par1="$(pwd)"/$1
fi
if [[ "$2" = /* ]]
then
	par2=$2
else
	par2="$(pwd)"/$2

fi
#Removing leading / in directories
par1=${1%/}
par2=${2%/}
#Error cases
if [[ $# -ne 2 ]]
then
	echo 'Error: Expected two input parameters.'
	echo 'Usage: ./srcdiff.sh <originaldirectory> <comparisondirectory>'
	exit 1
elif [[ ! -d "$par1" ]]
then
	echo "Error: Input parameter #1 '$par1' is not a directory."
	echo "Usage: ./srcdiff.sh <originaldirectory> <comparisondirectory>"
	exit 2
elif [[ ! -d "$par2" ]]
then
	echo "Error: Input parameter #2 '$par2' is not a directory."
	echo "Usage: ./srcdiff.sh <originaldirectory> <comparisondirectory>"
	exit 2
elif [[ "$par1" == "$par2" ]]
then
	echo 'Error: Both arguments are the same directory'
	exit 2
else
	#Case that there is no difference
	DIFF=`diff -q $par1 $par2`
	if [[ $DIFF == "" ]]
	then
		exit 0
	fi
	#iterate param 1 to check which files are in param 1 but not in param 2
	for f in $par1/*.*
	do
		fName2=$(basename $f) #get file name
		FILE2="$par2/$fName2" #create the path to the file with param 2
		if [[ ! -e "$FILE2" ]] #check if it is actually a file in param 2 directory
		then
			echo "$FILE2 is missing" | grep -v '*.*' #grep is to get rid of *.* output
		fi
	done
	#iterate param 2 to check which files are in param 2 but not in param 1
	for f in $par2/*.*
	do
		fName1=$(basename $f)
		FILE1="$par1/$fName1"
		if [[ ! -e "$FILE1" ]]
		then
			echo "$FILE1 is missing" | grep -v '*.*'
		else
			#When the file exists then we compare files to see if they have same content
			diff -q $FILE1 $f > out
			if [[ $? -ne 0 ]] #if the exit code is not zero then they are different
			then
				echo "$FILE1 differs."
			fi
		fi
	done
	exit 3
fi

