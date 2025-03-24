#!/bin/bash

echo -e "Inserisci lo script da criptare: " && read script
enc=$(echo $script | iconv -f UTF-8 -t UTF-16LE | base64 -w0)
echo
echo "----------------------------------"
echo -e "powershell -e $enc"
echo "----------------------------------"
echo
