#!/bin/bash
echo="$(which echo)";
if [ -f "$1.tgz" ]; then $echo "-> $(date '+%F %T') : Output file $1.tgz exist. Leaving"; exit 0;fi
if [ "$1" ]; then $echo "-> $(date '+%F %T') : Backing up $1 to $1.tgz";
        $(which tar) czvf "$1.tgz" "$1"; $echo "-> $(date '+%F %T') : Done";
else $echo "-> $(date '+%F %T') : File or directory $1 does not exist"; fi
