#!/bin/bash
#Make all the paths absolute
if [[ "$1" = /* ]]
then
	par1=$1
else
	par1="$(pwd)"/$1 #converting relative to absolute
fi
if [[ "$2" = /* ]]
then
	par2=$2
else
	par2="$(pwd)"/$2
fi
#Removing leading / from directories
par1=${1%/}
par2=${2%/}
if [[ $# -ne 2 ]]
then
	echo 'Error: Expected two input parameters.'
	echo 'Usage: ./backup.sh <backupdirectory> <fileordirectorybackup>'
	exit 1
elif [[ ! -e "$par1" ]]
then
	echo "Error: Backup directory '$par1' does not exist."
	echo "Usage: ./srcdiff.sh <originaldirectory> <comparisondirectory>"
	exit 2
elif [[ ! -e "$par2" ]]
then
	echo "Error: The file or directory '$par2' does not exist."
	echo "Usage: ./srcdiff.sh <originaldirectory> <comparisondirectory>"
	exit 2
elif [[ "$par1" == "$par2" ]]
then
	echo 'Error: Both arguments are the same directory'
	exit 2
else
	date=`date +%Y%m%d`
	isDir=$(basename $par2)	#getting last folder name from path
	dirname="$isDir.$date.tar" #name of the tar if it is directory
	fname=`basename $par2.$date.tar` #name of the tar if it is file
	if [[ -d "$par2" ]]
	then
		name=$dirname
	else
		name=$fname
	fi
	if [[ -f "$par1/$name" ]]
	then
		echo "Backup file $name already exists. Overwrite? (y/n)"
		read answer
		if [[ "$answer" == 'y' ]]
		then
			tar -cf $par1/$name $par2
			exit 0
		fi
		if [[ "$answer" == 'n' ]]
		then
			echo "Error: File already exists. Not overwriting."
			exit 3
		fi
	fi	
	tar -cf $par1/$name $par2
	exit 0
fi


