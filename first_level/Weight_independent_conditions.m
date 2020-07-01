%%%%%%%%%%%%%%%% FIRST LEVEL MODEL IN SPM %%%%%%%%%%%%%%%%%%

%{
1. Set up parameters and flags

2. Loop over participants and get all the data

3. Run model specification

4. Run model estimation

5. Run contrast specification

6. Display and save results

Structure of timing matrices by columns:
1-stimulation onset
2-stimulation offset + perception question
3-perception question button press
4-VAS onset
5-VAS offset + VAS button press
6-VAS rating
7-condition
8-response to the perception question

Conditions are: 1 - cucumber; 2 - orange; 3 - chips; 4 - chocolate; 5 - neutral

%}
clear all
%% 1. Set up parameteers and flags
% Flags
First_level=0;
Estimate=0;
Contrast=1;
Display=0;

%% Parameters and variables
load('/data/pt_02187/fMRI_analysis/timing_matrix/timing_matrix.mat')
addpath(genpath('~/spm12/spm12/'))
model_name='Weight_independent_conditions';
data_dir='/data/pt_02187/fMRI_analysis/preprocessing/xcp/';
folders=dir(data_dir);
subs={All_timing{:,3}};
%for p=1:length(folders)
%    if length(folders(p).name)==6
%        subs=[subs;folders(p).name];
%    end
%end
model_dir='/data/pt_02187/fMRI_analysis/first_level/';



%% CONDITIONS
conds={'StimCucumber','StimOrange','StimChips','StimChocolate','StimNeutral','Error','PercQ','VAS'};
ons={1 1 2 4}; % For each condition specify which column will of the design matrix to take for each condition respectively
durs={[2 1];[2 1];[3 2];[5 4]}; % For each condition to calculate durations enter which column of the time matrix sould be substracted from which
odour={[1 2 3 4 5];[6];[0];[0]}; % Do I want to divide condition for specific odours? If yes, say which ones, if no, say 0!!! 6 for error regressor
ncond=sum(cellfun(@numel,odour)); % Or ncond=length(conds)
pmod=[1 0 0 0]; % parametric modulation? 1 - yes, 0 - no

%% CONTRASTS
con_weights={[1 0 0 0 0 0 0 0 -1 0],[0 0 1 0 0 0 0 0 -1 0],[0 0 0 0 1 0 0 0 -1 0],[0 0 0 0 0 0 1 0 -1 0],[1 0 1 0 1 0 1 0 -4 0],...
    [0 0 0 0 1 0 1 0 -2],[1 0 1 0 0 0 0 0 -2]};
con_names={'Cucumber','Orange','Chips','Chocolate','All_stim','HC','LC'};
ncon=length(con_weights);        
%% 2. Loop over participants and get all the data
for i=[1:7. 9:17, 20:32, 34:38, 40:48, 51, 53:62] %53:length(All_timing) %[1:7. 9:17, 20:32, 34:38, 40:48, 51, 53:62] Because all proper participants with correct data are in the timing matrix
    current_sub=subs{i};
    timing=All_timing{i};
      
    
%% 3. Run model specification 
    if First_level   
        First_level_specify(pmod,odour,ons,durs,current_sub, data_dir, model_name, model_dir, ncond, conds, timing)
    end
    
%% 4. Run estimation of the model    
    if Estimate
       First_level_estimate(model_dir,model_name,current_sub)
    end
    
%% 5. Run contrast manager

    if Contrast
        First_level_contrast(model_dir,model_name,current_sub,con_names,con_weights,ncon)
    end
    
%% 6. Display and save results

    if Display
        First_level_display(model_dir,model_name,current_sub)
    end
    
end

