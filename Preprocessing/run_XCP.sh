#!/bin/bash

singularity run --cleanenv -B /data/pt_02187/  \
   /data/pt_02187/fMRI_analysis/xcp/xcpEngine.simg \
   -d /data/pt_02187/fMRI_analysis/scripts/XCP_design.dsn \
   -c /data/pt_02187/fMRI_analysis/scripts/cohort_file3.csv  \
   -o /data/pt_02187/fMRI_analysis/preprocessing/xcp/ \
   -i /data/pt_02187/fMRI_analysis/preprocessing/workdir/xcp/ \
   -t 0 \