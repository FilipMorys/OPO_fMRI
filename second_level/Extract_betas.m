%%%%%%%%%%%%%%% Extrcact information from ROIs for mediation %%%%%%%%%%%%%%%%%%

clear all
%% 1. Set up parameteers

%% Parameters and variables
addpath(genpath('~/spm12/spm12/'))
flvl_model='Weight_independent_conditions';
data_dir='/data/pt_02187/fMRI_analysis/first_level/';
folders=dir(sprintf('%s/%s', data_dir, flvl_model));
load('/data/pt_02187/fMRI_analysis/timing_matrix/behavioural_data.mat');
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
%% CONTRASTS FROM 1st LEVEL
conds=[5]; % Which conditions - contrasts - to take and summarise

files={};
for c=1:length(conds)
    for f=1:length(subs)
        files{f,c}=sprintf('%s/%s/%s/con_00%02d.nii',data_dir,flvl_model,subs{f},conds(c));
    end
end

ROI_list={'dlPFC','ACC','Amygdala','Caudate','Hippocampus','Insula','NAcc','Orbitofrontal','Pallidum','Piriform','Putamen','VmPFC','VTA'};


%% Summarise
ROIs=table;
for r=1%:length(ROI_list)
    betas=[];
    [betas,xY]=spm_summarise(files(:,1),sprintf('/data/pt_02187/fMRI_analysis/ROI/%s.nii',ROI_list{r}));
    ROIs.(r)=mean(betas,2);
    
end
ROIs.Properties.VariableNames = ROI_list;



