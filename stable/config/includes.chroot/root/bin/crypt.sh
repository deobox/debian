#!/usr/bin/env bash
function dohelp() { echo "-> Usage: $0 encrypt/decrypt file {cipher: aes-256-cbc or openssl enc -ciphers}"; }

if [ -z "${2}" ]; then dohelp; exit;  fi
if [ -f "${2}" ]; then filein="${2}"; else dohelp; exit; fi
if [ -z "${3}" ]; then cypher=aes-256-cbc; else cypher=${3}; fi
if [ "${1}" == "decrypt" ] && [ -z "${3}" ]; then cypher=${2##*.}; echo $cypher; fi

function doencrypt() { openssl enc -e -${cypher} -a -pbkdf2 -in "${filein}" -out "${filein}.${cypher}"; }
function dodecrypt() { openssl enc -d -${cypher} -a -pbkdf2 -in "${filein}" -out "${filein%.*}"; }

case "$1" in
encrypt) doencrypt; ;;
decrypt) dodecrypt; ;;
*) dohelp; ;;
esac

