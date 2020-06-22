function [] = Second_level_TFCE(model_dir,model_name,con_names,nperm)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
matlabbatch{1}.spm.tools.tfce_estimate.spmmat = {sprintf('%s/%s/SPM.mat',model_dir,model_name)};
matlabbatch{1}.spm.tools.tfce_estimate.mask = '';
matlabbatch{1}.spm.tools.tfce_estimate.conspec.titlestr = con_names;
matlabbatch{1}.spm.tools.tfce_estimate.conspec.contrasts = 1:length(con_names);
matlabbatch{1}.spm.tools.tfce_estimate.conspec.n_perm = nperm;
matlabbatch{1}.spm.tools.tfce_estimate.nuisance_method = 2;
matlabbatch{1}.spm.tools.tfce_estimate.tbss = 0;
matlabbatch{1}.spm.tools.tfce_estimate.E_weight = 0.5;
matlabbatch{1}.spm.tools.tfce_estimate.singlethreaded = 0;

spm_jobman('run',matlabbatch);
clear matlabbatch;

end
