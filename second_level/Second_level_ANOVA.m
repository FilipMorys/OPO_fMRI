function [] = Second_level_ANOVA(ncond,covs,ncov,cov_names,model_dir,files,model_name)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if exist(sprintf('%s/%s',model_dir,model_name),'dir')
    rmdir(sprintf('%s/%s',model_dir,model_name),'s')
end
mkdir(sprintf('%s/%s',model_dir,model_name))

matlabbatch{1}.spm.stats.factorial_design.dir = {sprintf('%s/%s',model_dir,model_name)};

for s=1:size(files,2)
    matlabbatch{1}.spm.stats.factorial_design.des.anova.icell(s).scans = files(:,s);
end
matlabbatch{1}.spm.stats.factorial_design.des.anova.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.anova.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.anova.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.anova.ancova = 0;
if ncov~=0
    for c=1:ncov
        matlabbatch{1}.spm.stats.factorial_design.cov(c).c = repelem(covs.(cov_names{c}),ncond);
        matlabbatch{1}.spm.stats.factorial_design.cov(c).cname = cov_names{c};
        matlabbatch{1}.spm.stats.factorial_design.cov(c).iCFI = 1;
        matlabbatch{1}.spm.stats.factorial_design.cov(c).iCC = 1;
    end
else
        matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
end
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

spm_jobman('run',matlabbatch);
clear matlabbatch;

end
