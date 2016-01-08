#!/bin/bash
##################################################
# This is a shell script for backup in Server.
# @author ioioj5
# @date 2016/01/09  00:42:40 
# @version 0.1.1
##################################################
# Global Variable
BACKUP_TIME=`date +%Y%m%d_%H%M`
PACKAGE_LIST=(subversion)
BACKUP_DIR=/data/backup

# Subversion
## Subversion service has been installed ? 
rpm -qa | grep -i subversion > /dev/null
SUBVERSION_DIR=/data/svn
if(($? == 0)); then
	# if it's been installed
	if [ -d $SUBVERSION_DIR ]; then
		# loop the subversion directory
		for directory in $SUBVERSION_DIR/*
		do
			# if the variable $directory is a directory
			if [ -d $directory ]; then
				# output
				echo "#> "${directory}
				# use the dump commend backup the repository
				/usr/bin/svnadmin dump $SUBVERSION_DIR/${directory##*/} > $BACKUP_DIR/svn/${directory##*/}.dump
			fi
		done
	fi	
else
	echo 'There is no subversion in this Server. Please install subversion.';
	exit 0;
fi

# To be continued ...