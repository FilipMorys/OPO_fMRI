function [] = First_level_estimate(model_dir,model_name,current_sub)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    matlabbatch{1}.spm.stats.fmri_est.spmmat = {sprintf('%s/%s/%s/SPM.mat',model_dir,model_name,current_sub)};
    matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;

    spm_jobman('run',matlabbatch);
    clear matlabbatch;
    
end

