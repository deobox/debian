#!/bin/bash
function dohelp() { echo "-> Usage: $0 e/d file"; }

if [ -z "${2}" ]; then dohelp; exit;  fi
if [ -f "${2}" ]; then filein="${2}"; else dohelp; exit; fi

cypher=aes-256-cbc; # List: openssl enc -cyphers
function dogetkey() { echo -n "-> Encryption key: "; read -s mykey; if [ "${mykey}" == "" ]; then echo "-> Cancelled" && exit 0; fi }
function doencrypt() { openssl enc -e -md sha512 -pbkdf2 -iter 1000 -pass pass:${mykey} -${cypher} -in "${filein}" -out "${filein}.${cypher}"; }
function dodecrypt() { openssl enc -d -md sha512 -pbkdf2 -iter 1000 -pass pass:${mykey} -${cypher} -in "${filein}" -out "${filein%.*}"; }

case "$1" in
e) dogetkey; doencrypt; ;;
d) dogetkey; dodecrypt; ;;
*) dohelp; ;;
esac
