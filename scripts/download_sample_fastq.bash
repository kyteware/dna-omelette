#!/bin/bash
if [[ $1 != "" ]]
then
    wget -q -P $1 -O sample.fastq "https://zenodo.org/record/3736457/files/1_control_psbA3_2019_minq7.fastq?download=1"
else
    wget -q -O sample.fastq "https://zenodo.org/record/3736457/files/1_control_psbA3_2019_minq7.fastq?download=1"
fi