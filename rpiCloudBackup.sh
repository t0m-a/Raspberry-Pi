#! /bin/bash
# backupPItoGoogleDrive.sh v0.2
# Local backups archived and gunziped, then uploaded to Google Drive via RCLONE
# http://rclone.org/
# http://rclone.org/docs/
# You WILL NEED to have rcloned install and configured prior to launching this
# script. You can do so by lauching rclone config from a shell with the user
# who will usually run this script. You will also need a remote destination
# folder to be created in Google Drive or in Dropbox as you configured rclone.
# /!\ If you plan on backing up priviledged directories will need to be root /!\
# ie: /etc, /root, /var/backups, /var/www etc...
################################################################################

PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

######### VARIABLES DECLARATIONS ###############################################
# FOLDERS DECLARATION SECTION: local and remote folders for backup files storage
backupdir=$HOME/local_backup
remotebackupdir='insert_path_to_directory'

# FOLDERS DECLARATION SECTION: folders to backup
dirtobackup1='insert_path_to_directory'
dirtobackup2='insert_path_to_directory'
#dirtobackup3='insert_path_to_directory'
#dirtobackup4='insert_path_to_directory'
#dirtobackup5='insert_path_to_directory`

# BACKUP FILES NAMING SECTION
# You may add as much name definition as you have folders declared in the section 
# above by copying a line below and changing nameNUMBER and dirtobacupNUMBER values.
# You will also need to uncomment or create new tar lines in the backup section.
name1=$(date -I)-${dirtobackup1##*/}
name2=$(date -I)-${dirtobackup2##*/}
#name3=$(date -I)-${dirtobackup3##*/}
#name4=$(date -I)-${dirtobackup4##*/}
#name5=$(date -I)-${dirtobackup5##*/}

######### FLOWS CONTROL SECTION ################################################ 
# Checking backup sources and remote folders configuration
if [ "$dirtobackup1" = 'insert_path_to_directory' ]
  then echo "This is the first time you run this script. Please edit the folders declaration sections."; exit 1
else
if [ "$remotebackupdir" = 'insert_path_to_directory' ]
  then echo "This is the first time you run this script. Please edit the folders declaration sections."; exit 1
fi
fi

if [[ $EUID -ne 0 ]]; then
echo "If you included system files and folders in your backup, you may want to run this script as root!";
echo -n "Do you wish to run it as root? (y/n and press enter) "
read answer
if echo "$answer" | grep -iq "^y";then
    sudo -p 'Restarting as root, password: ' bash $0 "$@"
    exit $?
fi
fi

######### BACKUP SECTION #######################################################
echo "Creating local backups storage folder if it doesn't exist."
mkdir -p $backupdir
sleep 1
echo "Creating compressed archive files for backup using tar..."
cd $backupdir
sleep 1
tar -zcf $name1.tar.gz $dirtobackup1;
tar -zcf $name2.tar.gz $dirtobackup2;
#tar -zcvf $name3.tar.gz $dirtobackup3;
#tar -zcvf $name4.tar.gz $dirtobackup4;
#tar -zcvf $name5.tar.gz $dirtobackup5;

echo "Archives created, you may like to check the files list below:"
ls -lhA $backupdir

echo "Now exporting local backups to your remote Cloud storage..."
rclone copy $backupdir $remotebackupdir

echo "Cleaning up local backup directory..."
rm -rf $backupdir;

exit 0
