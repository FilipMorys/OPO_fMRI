function [] = Second_level_flxf(ncond,covs,ncov,cov_names,model_dir,files,model_name)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if exist(sprintf('%s/%s',model_dir,model_name),'dir')
    rmdir(sprintf('%s/%s',model_dir,model_name),'s')
end
mkdir(sprintf('%s/%s',model_dir,model_name))

files_obese=files((covs.BMI_group==3),:);
files_lean=files((covs.BMI_group==1),:);


matlabbatch{1}.spm.stats.factorial_design.dir = {sprintf('%s/%s',model_dir,model_name)};
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).name = 'Group';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).name = 'CaloricContent';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).variance = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).name = 'Sweetness';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).variance = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(4).name = 'subject';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(4).dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(4).variance = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(4).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(4).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters = {};
for s=1:length(files_obese)
        matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(s).scans = files_obese(s,:)';
        matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(s).conds = [1 1 1 s; 1 1 2 s; 1 2 1 s; 1 2 2 s];
end
for s=1:length(files_lean)
        matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(s+length(files_obese)).scans = files_lean(s,:)';
        matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(s+length(files_obese)).conds = [2 1 1 s; 2 1 2 s; 2 2 1 s; 2 2 2 s];
end
if ncov~=0
    for c=1:ncov
        matlabbatch{1}.spm.stats.factorial_design.covar(c).c = repmat(covs.(cov_names{c}),ncond,1);
        matlabbatch{1}.spm.stats.factorial_design.covar(c).cname = cov_names{c};
        matlabbatch{1}.spm.stats.factorial_design.covar(c).iCFI = 1;
        matlabbatch{1}.spm.stats.factorial_design.covar(c).iCC = 1;
    end
    matlabbatch{1}.spm.stats.factorial_design.cov(1).c = [matlabbatch{1}.spm.stats.factorial_design.covar(1).c;matlabbatch{1}.spm.stats.factorial_design.covar(2).c;matlabbatch{1}.spm.stats.factorial_design.covar(3).c;matlabbatch{1}.spm.stats.factorial_design.covar(4).c;];
    matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = 'Pleasantness';
    matlabbatch{1}.spm.stats.factorial_design.cov(1).iCFI = 2;
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
matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{1}.fmain.fnum = 4;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{2}.inter.fnums = [1 2];
matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{3}.inter.fnums = [1 3];


spm_jobman('run',matlabbatch);
clear matlabbatch;

end