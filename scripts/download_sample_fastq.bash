#!/bin/bash
echo $1
if [[ $1 != "" ]]
then
    wget -P $1 "https://zenodo.org/record/3736457/files/1_control_psbA3_2019_minq7.fastq?download=1"
else
    wget "https://zenodo.org/record/3736457/files/1_control_psbA3_2019_minq7.fastq?download=1"
fi