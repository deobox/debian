export PS1='\[\033[0;31m\]\u\[\033[01;32m\]@\h\[\033[01;34m\] \w #\[\033[00m\] ';
if [ -d "${HOME}/bin" ]; then export PATH=${PATH}:${HOME}/bin; fi;

alias cp='cp -rvf';
alias rm='rm -rvf';
alias mv='mv -v';
alias df='df -H';
alias dff='df -H -x tmpfs';
alias du='du --si';
alias vim='vim.tiny';
alias grep='grep --color -i';
alias l='ls -d .* --color=always';
alias ll='ls -l --color=always';
alias ls='ls --color=always';
alias lsz='ls -al --color=always';
alias disks='fdisk -l | grep dev';

TZ='Europe/London'; export TZ;
