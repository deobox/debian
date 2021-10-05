#!/bin/bash
echo="$(which echo)";
if [ -f "${1}" ]; then $echo "$(date '+%F %T') : Backing up $1 to ${1//./-}.zip"; $(which zip) "${1//./-}.zip" "${1}"; $echo "$(date '+%F %T') : Done";
elif [ -d "${1}" ]; then $echo "$(date '+%F %T') : Backing up ${1} to ${1}.zip"; $(which zip) -r "${1}" "${1}"; $echo "$(date '+%F %T') : Done";
else $echo "Error at $(date '+%F %T') : File ${1} does not exist";
fi
