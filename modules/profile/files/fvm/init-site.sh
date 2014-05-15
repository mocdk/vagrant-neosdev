#!/bin/bash

FILE=fvm-files.tar.gz
SITEPATH=/home/sites/fvm.dk/
DATAFILE_PATH=www-data@fvmfile1:/home/local-data/fvm/fvm-files.tar.gz
#Create typo_src foldr
cd $SITEPATH
if [ ! -d "typo3_src-6.1.x-patchedForFVM" ]; then
    echo "Cloning TYPO3 Source"
    git clone git@github.com:mocdk/typo3_src.git typo3_src-6.1.x-patchedForFVM
fi

#Clone versioned folder
if [ ! -d "versioned" ]; then
    echo "Cloning versioned folder"
    git clone git@git.moc.net:sites/fvm.git versioned
    cd versioned
    git submodule init
    git submodule update
    git config remote.origin.pushurl ssh://gerrit.mocsystems.com:29418/sites/fvm.git
    git config remote.origin.push HEAD:refs/for/master
    curl https://moc.net/commit-msg > .git/hooks/commit-msg
    chmod a+x .git/hooks/commit-msg
    git config branch.master.rebase true
    git config alias.lg "log --graph --pretty=oneline --abbrev-commit --date=relative"
fi

cd $SITEPATH/htdocs/


if [[ ! -f "$FILE" ]]; then
    echo "Copying datafiles"
#    scp $DATAFILE_PATH $FILE
fi


echo Linking typo3 src
if [ -e "typo3_src" ]; then
    rm typo3_src
fi
ln -s ../typo3_src-6.1.x-patchedForFVM typo3_src

if [ ! -d "typo3temp" ]; then
    echo "Creating typo3temp directory"
    mkdir typo3temp
    chmod g+w typo3temp
fi;


#ToDo:

#update sys_domain set domainName="fvm.dev" where uid=11;
#delete from sys_domain where uid!=11 and pid=2;
#create sys_domaiun with fvm.dev:8081

#update sys_domain set domainName="en.fvm.dev" where uid=17;
#delete from sys_domain where uid!=17 and pid=892;

#update sys_domain set domainName="naer.dev" where uid=70;
#delete from sys_domain where uid!=70 and pid=1467;

#update sys_domain set domainName="agrifish.dev" where uid=101;
#delete from sys_domain where uid!=101 and pid=1706;

#update sys_domain set domainName="madkulturen.dev" where uid=41;
#delete from sys_domain where uid!=41 and pid=18+4;

#update sys_domain set domainName="madkulturen.dev" where uid=54;
#delete from sys_domain where uid!=54 and pid=2029;


#Update /etc/hosts, or somehow fix loca DNS ISsues
#Disable all scheduler tasks expect ones that are needed

#Create Crontab job for schefuler


#Change moc_message_queue settings to use localhost (LocalConfiguration.php)
