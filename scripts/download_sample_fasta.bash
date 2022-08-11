#!/bin/bash

if [[ $1 == "" ]]
then
    FILEPATH="./"
else
    LASTLETTER=${1: -1}
    if [[ $LASTLETTER != "/" ]]
    then
        FILEPATH="$1/"
    else
        FILEPATH=$1
    fi
fi

if test -f "$FILEPATH/sample.fasta"
then
    echo "Sample FASTA file already downloaded, skipping..."
else
    wget -q -O "$FILEPATH/sample.fasta" "https://www.ncbi.nlm.nih.gov/sviewer/viewer.cgi?tool=portal&save=file&log$=seqview&db=nuccore&report=fasta&id=1798174254&extrafeat=null&conwithfeat=on&hide-cdd=on"
    echo "Sample FASTA file downloaded..."
fi