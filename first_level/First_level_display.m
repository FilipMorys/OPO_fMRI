function [] = First_level_display(model_dir,model_name,current_sub)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    matlabbatch{1}.spm.stats.results.spmmat = {sprintf('%s/%s/%s/SPM.mat',model_dir,model_name,current_sub)};
    matlabbatch{1}.spm.stats.results.conspec.titlestr = '';
    matlabbatch{1}.spm.stats.results.conspec.contrasts = 1;
    matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'FWE';
    matlabbatch{1}.spm.stats.results.conspec.thresh = 0.05;
    matlabbatch{1}.spm.stats.results.conspec.extent = 0;
    matlabbatch{1}.spm.stats.results.conspec.conjunction = 1;
    matlabbatch{1}.spm.stats.results.conspec.mask.none = 1;
    matlabbatch{1}.spm.stats.results.units = 1;
    matlabbatch{1}.spm.stats.results.export{1}.pdf = true;
    %matlabbatch{1}.spm.stats.results.export{2}.pdf = true;
%     matlabbatch{1}.spm.util.render.display.rendfile = {'/afs/cbs.mpg.de/software/spm/12.7771/9.7/bionic/rend/render_smooth_average.mat'};
%     matlabbatch{1}.spm.util.render.display.conspec.spmmat = {sprintf('%s/%s/%s/SPM.mat',model_dir,model_name,current_sub)};
%     matlabbatch{1}.spm.util.render.display.conspec.contrasts = 1;
%     matlabbatch{1}.spm.util.render.display.conspec.threshdesc = 'FWE';
%     matlabbatch{1}.spm.util.render.display.conspec.thresh = 0.05;
%     matlabbatch{1}.spm.util.render.display.conspec.extent = 200;
%     matlabbatch{1}.spm.util.render.display.conspec.mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});

    spm_jobman('run',matlabbatch);
    clear matlabbatch;
    
    
end

