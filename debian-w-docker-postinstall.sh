#! /bin/bash
# Post Installation DEBIAN Server Alpha (and PROD)
# Work on 8.7 and 9.4 x64 for AWS and Digital Ocean
# Created: 20180521 10:18
# Updated: 20180521 20:32
##

# Upgrade the base system
apt-get update && apt-get upgrade -y;
# Installing basic tools
apt-get install -y vim net-tools curl apt-transport-https apt-utils htop strace sysstat \
ca-certificates gnupg2 software-properties-common gzip bzip2 whois dnsutils rblcheck;

# Installing chkrootkit security tool and updating configuration
apt-get install -y chkrootkit;
mv /etc/chkrootkit.conf /etc/chkrootkit.orig;
touch /etc/chkrootkit.conf;
echo -e '\n RUN_DAILY="true" \n RUN_DAILY_OPTS="-q"`\n DIFF_MODE="false" \n' > /etc/chkrootkit.conf;

# Installing Docker CE
# Verifying the Docker repository key. Option grep-q tells grep to exit in error
# if the value is not strictly (-w) the one expected, hence not exporting KEY_OK=KEY_OK

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -;
apt-key adv --list-public-keys --with-fingerprint --with-colons | grep 9DC8 | cut -c 13-52 | grep -q -w "9DC858229FC7DD38854AE2D88D81803C0EBFCD88" && export KEY_OK=KEY_OK;
if [ "$KEY_OK" = 'KEY_OK' ]
  then add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable" && apt-get update && apt-get install -y docker-ce && apt-get autoremove && apt-get clean;

# Importing useful variables at login without touching Bash's files
    echo "export LS_OPTIONS='--color=auto'" > /root/env_vars;
	echo 'eval "`dircolors`"' >> /root/env_vars;
	echo "alias ls='ls $LS_OPTIONS'" >> /root/env_vars;
	echo "alias ll='ls $LS_OPTIONS -l'" >> /root/env_vars;
	echo "alias l='ls $LS_OPTIONS -lA'" >> /root/env_vars;
	echo "export SEP="-------------------------------------------------"" >> /root/env_vars;
	echo "alias full-docker-list='docker ps && echo $SEP && docker ps --all && echo $SEP && docker images'" >> /root/env_vars;
	echo 'export wan=$(curl -s http://api.ipify.org/)' >> /root/env_vars;
	echo 'export lan=$(ifconfig | grep -i inet | grep -v inet6 | grep -v "127.0.0.1" | cut -d: -f1 | cut -c14-25)' >> /root/env_vars;
	printf 'export dns=$(cat /etc/resolv.conf | grep nameserver | cut -d'"' '"' -f2)' >> /root/env_vars;
	echo "unset TMOUT" >> /root/env_vars;
	echo '. ./root/env_vars' >> /root/.bashrc;

else echo "Fail to verify Docker's repository key! Aborting Docker install and variables creation!"
exit 1
fi
