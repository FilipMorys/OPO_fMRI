function [] = Second_level_twosamplettest(ncond,covs,ncov,cov_names,model_dir,files,model_name)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if exist(sprintf('%s/%s',model_dir,model_name),'dir')
    rmdir(sprintf('%s/%s',model_dir,model_name),'s')
end
mkdir(sprintf('%s/%s',model_dir,model_name))

files_obese=files((covs.BMI_group==3),:);
files_lean=files((covs.BMI_group==1),:);

covs_ordered=table;
for p=1:length(files_obese)
    sub=files_obese{p}(73:78);
    covs_ordered=[covs_ordered;covs(covs.BIDS_ID==sub,:)];
end
for p=1:length(files_lean)
    sub=files_lean{p}(73:78);
    covs_ordered=[covs_ordered;covs(covs.BIDS_ID==sub,:)];
end

matlabbatch{1}.spm.stats.factorial_design.dir = {sprintf('%s/%s',model_dir,model_name)};
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = cellstr(files_obese);
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = cellstr(files_lean);
matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
if ncov~=0
    for c=1:ncov
        matlabbatch{1}.spm.stats.factorial_design.cov(c).c = covs_ordered.(cov_names{c});
        matlabbatch{1}.spm.stats.factorial_design.cov(c).cname = cov_names{c};
        matlabbatch{1}.spm.stats.factorial_design.cov(c).iCFI = 1;
        matlabbatch{1}.spm.stats.factorial_design.cov(c).iCC = 1;        
    end
else
        matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
end
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;


spm_jobman('run',matlabbatch);
clear matlabbatch;

end