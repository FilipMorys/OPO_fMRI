%%%%%%%%%%%%%%%% SECOND LEVEL MODEL IN SPM + TFCE estimation %%%%%%%%%%%%%%%%%%

%{
1. Set up parameters and flags

2. Loop over participants and get all the data

3. Run model specification

4. Run model estimation

5. Run contrast specification

6. Run TFCE estimation

%}
clear all
%% 1. Set up parameteers and flags
% Flags
Second_level=1;
Estimate=1;
Contrast=1;
TFCE=0;

%% Parameters and variables
addpath(genpath('~/spm12/spm12/'))
model_name='BP_sanity';
data_dir='/data/pt_02187/fMRI_analysis/first_level/';
folders=dir(sprintf('%s/%s', data_dir, model_name));
load('/data/pt_02187/fMRI_analysis/timing_matrix/behavioural_data.mat');
subs={};
covs={};
for p=1:length(folders)
    if length(folders(p).name)==6
        subs=[subs;folders(p).name];
        covs=[covs;Behavioural(Behavioural.BIDS_ID==folders(p).name,:)];
    end
end
model_dir='/data/pt_02187/fMRI_analysis/second_level/';


%% CONTRASTS FROM 1st LEVEL
conds=[1]; % Which conditions - contrasts - to take into 2nd level model

files={};
for c=1:length(conds)
    for f=1:length(subs)
        files{f,c}=sprintf('%s/%s/%s/con_00%02d.nii',data_dir,model_name,subs{f},conds(c));
    end
end

%% CONTRASTS
con_weights={[1]};
con_names={'BP'};

%% Covariates for the model
ncov=3;
cov_names={'Sex','Age','BMI'};

%% TFCE Specs
nperm=5000;

%% 3. Run model specification

if Second_level
    Second_level_onesamplettest(covs,ncov,cov_names,model_dir,files,model_name)
end

%% 4. Estimate the model

if Estimate
    Second_level_estimate(model_dir,model_name)
end

%% 5. Run contrast specification

if Contrast
    Second_level_contrast(model_dir,model_name,con_weights,con_names)
end

%% 6. Run TFCE

if TFCE
    Second_level_TFCE(model_dir,model_name,con_names,nperm)
end