function [] = Second_level_estimate(model_dir,model_name)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
matlabbatch{1}.spm.stats.fmri_est.spmmat(1) = {sprintf('%s/%s/SPM.mat',model_dir,model_name)};
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;

spm_jobman('run',matlabbatch);
clear matlabbatch;
end

