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
TFCE=1;

%% Parameters and variables
addpath(genpath('~/spm12/spm12/'))
flvl_model='Weight_independent_conditions';
model_name='Weight_independent_rmANOVA';
data_dir='/data/pt_02187/fMRI_analysis/first_level/';
folders=dir(sprintf('%s/%s', data_dir, flvl_model));
load('/data/pt_02187/fMRI_analysis/timing_matrix/behavioural_data.mat');
subs={};
covs={};
subs_to_exclude={'sub-10','sub-43','sub-54','sub-45','sub-22','sub-23','sub-37','sub-55','sub-57'}; %motion outliers and empty conditions
ncond=4; %number of conditions in the ANCOVA

for p=1:length(folders)
    if length(folders(p).name)==6
        if ~ismember(folders(p).name,subs_to_exclude)
            subs=[subs;folders(p).name];
            covs=[covs;Behavioural(Behavioural.BIDS_ID==folders(p).name,:)];
        end
    end
end

model_dir='/data/pt_02187/fMRI_analysis/second_level/';


%% CONTRASTS FROM 1st LEVEL
conds=[1 2 3 4]; % Which conditions - contrasts - to take into 2nd level model

files={};
for c=1:length(conds)
    for f=1:length(subs)
        files{f,c}=sprintf('%s/%s/%s/con_00%02d.nii',data_dir,flvl_model,subs{f},conds(c));
    end
end

%% CONTRASTS
con_weights={[1 1 -1 -1],[-1 -1 1 1],[-1 1 -1 1],[1 -1 1 -1],...
    %[1 0 0 0 ones(1,53)/53],[0 1 0 0 ones(1,53)/53],[0 0 1 0 ones(1,53)/53],[0 0 0 1 ones(1,53)/53],[1/4 1/4 1/4 1/4 ones(1,53)/53]};
};
    con_names={'LC>HC','HC>LC',...
    'Sweet>Savory','Savory>Sweet'};%,'Cucumber','Orange','Chips','Chocolate','All'};

%% Covariates for the model
ncov=0;
cov_names={'Sex','Age','BMI'};

%% TFCE Specs
nperm=1000;

%% 3. Run model specification

if Second_level
    Second_level_rmANOVA(ncond,covs,ncov,cov_names,model_dir,files,model_name)
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