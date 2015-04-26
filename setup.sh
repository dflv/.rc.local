#!/bin/bash

BACKUP_SURFIX=".`date +"%Y%m%d%H%M%S"`"
CONFIG_PREFIX="_"

if [ $1 == "bak" ];
then
    RC_LOCAL_BAK=1
else
    RC_LOCAL_BAK=0
fi

# replace configuration
# $1 - local config folder
# $2 - the core of the config file name
_rep_conf()
{
    if [ -f ~/.$2 ];
    then
        if [ $RC_LOCAL_BAK == "0" ];
        then
            rm -f ~/.$2
        else
            mv ~/.$2 ~/.$2$BACKUP_SURFIX
        fi
    fi
    ln -s $PWD/$1/"$CONFIG_PREFIX"$2 ~/.$2
}

# ack
_rep_conf ack ackrc
# bash
# git
# openbox
# ssh
# tmux
_rep_conf tmux tmux.conf
# vim
_rep_conf vim vimrc.local
_rep_conf vim vimrc.before.local
_rep_conf vim vimrc.bundles.local
# zsh
