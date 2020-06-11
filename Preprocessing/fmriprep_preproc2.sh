#!/bin/bash

while read sub 
do

singularity run -B /data/p_02187/ -B /data/pt_02187/ /data/pt_02187/fMRI_analysis/fmriprep_2/fmriprep-20.0.6.simg \
/data/p_02187/Daten/BIDS/ \
/data/pt_02187/fMRI_analysis/preprocessing/fmriprep_out2/ \
participant \
-w /data/pt_02187/fMRI_analysis/preprocessing/workdir2/ \
--fs-license-file /data/pt_02187/fMRI_analysis/fmriprep/license.txt \
--bold2t1w-dof 12  \
--nthreads 16  \
--output-space MNI152NLin2009cAsym:res-native T1w \
--participant-label ${sub} \
--skip-bids-validation \
--fd-spike-threshold 0.5 \
--ignore slicetiming \
--fs-no-reconall &

done < xan