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
ROI=0;
Second_level=1;
Estimate=1;
Contrast=1;
TFCE=0;

%% Parameters and variables
addpath(genpath('~/spm12/spm12/'))
addpath(genpath('~/peak_nii/'))
flvl_model='Weight_independent_conditions';
model_name='Weight_dependent_GLMFLEX';
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

ROI_list={'ACC','Amygdala','Caudate','Hippocampus','Insula','NAcc','Orbitofrontal','Pallidum','Piriform','Putamen','VmPFC','VTA'};

%% Covariates for the model
ncov=0;
cov_names={'Sex','Age','BMI'};

%% TFCE Specs
nperm=1000;

%% GLM_flex_fast2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
files_obese=files((covs.BMI_group==3),:);
files_lean=files((covs.BMI_group==1),:);
files=[files_obese;files_lean];
scans=reshape(files',[1,4*length(files)])';
%%% Create a data structure to hold the variables
clear dat
dat.fn = [];
dat.Group = [];
dat.Condition = [];
dat.Run = [];
dat.SS = [];

%%% In this case all the information we need is contained in the file names, 
%%% so all we have to do is parse the file names, and store the information in the dat structure.

for c=1:length(scans)
    
    dat.fn{c,1} = scans{c};
    dat.SS{c,1} = scans{c}(73:78);
    dat.Run{c,1} = 1;
    dat.Condition{c,1} = scans{c}(80:87);
    
end

% First 8 Subjects (64 images) are in Group1 the rest are in Group2
dat.Group = cell(172,1);
dat.Group(1:76) = {'Obese'};
dat.Group(77:end) = {'Lean'};

%%% Now we set up I (same as before) only with new entries for data and for model.
%%% These two new entries obviate the need for the IN + CreateDesign2 step.
clear I;
I.Scans = dat.fn;
I.Model = 'Group*Condition + random(SS|Condition)';
I.Data = dat;
I.OutputDir = sprintf('%s/%s',model_dir,model_name);
I.RemoveOutliers = 0;
I.DoOnlyAll = 1;
I.estSmooth = 1;
 
%%% With the latest update to GLM_Flex_Fast2 we can also specify post hoc contrasts
I.PostHocs = {'Group$Obese & Group$Lean' 'AllGroups'; 
             'Group$Obese|Condition$con_0001 & Group$Obese|Condition$con_0002 & Group$Obese|Condition$con_0003 & Group$Obese|Condition$con_0004 & Group$Lean|Condition$con_0001 & Group$Lean|Condition$con_0002 & Group$Lean|Condition$con_0003 & Group$Lean|Condition$con_0004' 'AllConds';
             'Group$Obese # Group$Lean' 'Obese>Lean';
             'Group$Lean # Group$Obese' 'Lean>Obese';
             'Group$Obese|Condition$con_0001 & Group$Obese|Condition$con_0002 # Group$Obese|Condition$con_0003 # Group$Obese|Condition$con_0004 # Group$Lean|Condition$con_0001 # Group$Lean|Condition$con_0002 & Group$Lean|Condition$con_0003 & Group$Lean|Condition$con_0004' 'LC>HC.OB>Lean';
             'Group$Obese|Condition$con_0003 & Group$Obese|Condition$con_0004 # Group$Lean|Condition$con_0003 # Group$Lean|Condition$con_0004' 'HC.OB>Lean';
             'Group$Obese|Condition$con_0001 & Group$Obese|Condition$con_0002 # Group$Lean|Condition$con_0001 # Group$Lean|Condition$con_0002' 'LC.OB>Lean'
             };

GLM_Flex_Fast4(I);

