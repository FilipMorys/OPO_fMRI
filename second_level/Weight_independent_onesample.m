%%%%%%%%%%%%%%%% SECOND LEVEL MODEL IN SPM + TFCE estimation %%%%%%%%%%%%%%%%%%

%{
1. Set up parameters and flags

2. Loop over participants and get all the data

3. Run model specification

4. Run model estimation

5. Run contrast specification

6. Run TFCE estimation

con_names={'Cucumber','Orange','Chips','Chocolate','All_stim','HC','LC','Savoury','Sweet'};

%}
clear all
%% 1. Set up parameteers and flags
% Flags
ROI=0;
Second_level=1;
Estimate=1;
Contrast=1;
TFCE=0;
Display=1;

%% Parameters and variables
addpath(genpath('~/spm12/spm12/'))
flvl_model='Weight_independent_conditions';
model_name='AllConditions_pleasantness';
data_dir='/data/pt_02187/fMRI_analysis/first_level/';
folders=dir(sprintf('%s/%s', data_dir, flvl_model));
load('/data/pt_02187/fMRI_analysis/timing_matrix/behavioural_pleasantness.mat');
subs={};
covs={};
subs_to_exclude={'sub-10','sub-43','sub-54','sub-45','sub-22','sub-23','sub-37','sub-55','sub-57'}; %motion outliers and empty conditions

for p=1:length(folders)
    if length(folders(p).name)==6
        if ~ismember(folders(p).name,subs_to_exclude)
            subs=[subs;folders(p).name];
            covs=[covs;Behavioural(Behavioural.BIDS_ID==folders(p).name,:)];
        end
    end
end

model_dir='/data/pt_02187/fMRI_analysis/second_level/';

ROI_list={'ACC','Amygdala','Caudate','Hippocampus','Insula','NAcc','Orbitofrontal','Pallidum','Piriform','Putamen','VmPFC','VTA'};

%% CONTRASTS FROM 1st LEVEL
conds=[1]; % Which conditions - contrasts - to take into 2nd level model

files={};
for c=1:length(conds)
    for f=1:length(subs)
        files{f,c}=sprintf('%s/%s/%s/con_00%02d.nii',data_dir,flvl_model,subs{f},conds(c));
    end
end

%% CONTRASTS
con_weights={[1],[0 0 0 0 1],[0 0 0 0 -1]};
con_names={'All','Cov','-Cov'};

%% Covariates for the model
ncov=4;
cov_names={'Sex','Age','PassiveSmoking','Pl_O5'};

%% TFCE Specs
nperm=5000;

%% Displaying
cons=[1];
con_disp={'All_conditions'};

%% RUN ALL IF ROI - SPECIAL CASE

if ROI
    
    for r=1:length(ROI_list)
        model_name='All';
        ROI1=ROI_list(r);
        [files,model_name]=Second_level_ROI(ROI1,files,conds,subs,data_dir,flvl_model,model_name);
    
    model_dir='/data/pt_02187/fMRI_analysis/second_level_ROI/';
    
    if Second_level
        Second_level_onesamplettest(covs,ncov,cov_names,model_dir,files,model_name)
    end

    try
    if Estimate
        Second_level_estimate(model_dir,model_name)
    end

    if Contrast
        Second_level_contrast(model_dir,model_name,con_weights,con_names)
    end

    if TFCE
        Second_level_TFCE(model_dir,model_name,con_names,nperm)
    end
    
    if Display
        Second_level_display(model_dir,model_name,cons,con_disp)
    end
    catch
    end
    end
end
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

%% 7. Display and save results

if Display
    Second_level_display(model_dir,model_name,cons,con_disp)
end