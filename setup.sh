#!/bin/bash

BACKUP_SURFIX=".`date +"%Y%m%d%H%M%S"`"
CONFIG_PREFIX="_"

# replace configuration
# $1 - local config folder
# $2 - the core of the config file name
_rep_conf()
{
    if [ -f ~/.$2 ];
    then
        mv ~/.$2 ~/.$2$BACKUP_SURFIX
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
# zsh
