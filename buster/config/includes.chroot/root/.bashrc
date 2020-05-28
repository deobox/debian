export PS1='\[\033[0;31m\]\u\[\033[01;32m\]@\h\[\033[01;34m\] \w #\[\033[00m\] ';

alias cp='cp -vrfi';
alias mv='mv -iv';
alias rm='rm -iv';
alias df='df -H -x tmpfs';
alias du='du --si';
alias l='ls -d .* --color=always';
alias ll='ls -al --color=always';
alias ls='ls --color=always';
alias lsz='ls -al --color=always';
alias vim='vim.tiny';
alias tcpdump='tcpdump -p';
alias grep='grep -i --color=always';
alias uname='uname -a';
alias winkey="hexdump -s 56 -e '\"Windows BIOS key: \" /29 \"%s\n\"' /sys/firmware/acpi/tables/MSDM;";
alias dstat='dstat -cndylp --top-cpu --tcp';
alias disks='fdisk -l | grep dev';

if [ -d "$HOME/bin" ]; then export PATH=$PATH:$HOME/bin; fi;
if [ -n "$DISPLAY" ]; then xset b off; fi
