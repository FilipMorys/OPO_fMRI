function [] = Second_level_rmANOVA(ncond,covs,ncov,cov_names,model_dir,files,model_name)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if exist(sprintf('%s/%s',model_dir,model_name),'dir')
    rmdir(sprintf('%s/%s',model_dir,model_name),'s')
end
mkdir(sprintf('%s/%s',model_dir,model_name))

for i=1:ncov
    files(isnan(covs.(cov_names{i})),:)=[]; % Remove NaNs from covariates and also scans of those people
    covs(isnan(covs.(cov_names{i})),:)=[];
end

matlabbatch{1}.spm.stats.factorial_design.dir = {sprintf('%s/%s',model_dir,model_name)};

for s=1:length(files)
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.fsubject(s).scans = files(s,:)';
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.fsubject(s).conds = [1 2 3 4];
end
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.ancova = 0;
if ncov~=0
    for c=1:ncov
        matlabbatch{1}.spm.stats.factorial_design.covar(c).c = repmat(covs.(cov_names{c}),ncond,1);
        matlabbatch{1}.spm.stats.factorial_design.covar(c).cname = cov_names{c};
        matlabbatch{1}.spm.stats.factorial_design.covar(c).iCFI = 1;
        matlabbatch{1}.spm.stats.factorial_design.covar(c).iCC = 1;
    end
    matlabbatch{1}.spm.stats.factorial_design.cov(1).c = [matlabbatch{1}.spm.stats.factorial_design.covar(1).c;matlabbatch{1}.spm.stats.factorial_design.covar(2).c;matlabbatch{1}.spm.stats.factorial_design.covar(3).c;matlabbatch{1}.spm.stats.factorial_design.covar(4).c;];
    matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = 'Pleasantness';
    matlabbatch{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
    matlabbatch{1}.spm.stats.factorial_design.cov(1).iCC = 1;
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
