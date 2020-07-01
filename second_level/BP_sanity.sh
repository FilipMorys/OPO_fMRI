#!/bin/bash

#FSL
model="BP_sanity" # Important that it's the same name as the first level model
con_file="con_0003.nii"
echo "Creating model ${model}"
rm /data/pt_02187/fMRI_analysis/second_level/${model} -rf
mkdir /data/pt_02187/fMRI_analysis/second_level/${model}
Slvl_dir="/data/pt_02187/fMRI_analysis/second_level/${model}/"

echo "Copying individual contrast files"
while read sub; do
  cp /data/pt_02187/fMRI_analysis/first_level/${model}/${sub}/${con_file} /data/pt_02187/fMRI_analysis/second_level/${model}/${sub}${con_file}
done <subs.txt

cd /data/pt_02187/fMRI_analysis/second_level/${model}/

echo "Merging individual contrast files"
fslmerge -t ${model}.nii *.nii

echo "Running randomise"
randomise -i ${Slvl_dir}${model} -o ${Slvl_dir}${model} -1 -v 5 -T -n 500


