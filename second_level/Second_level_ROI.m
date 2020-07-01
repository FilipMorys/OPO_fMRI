function [files,model_name] = Second_level_ROI(ROI1,files,conds,subs,data_dir,flvl_model,model_name)

for c=1:length(conds)
    for f=1:length(subs)
        for r=1%:length(ROI1)
            if ~exist(sprintf('%s/%s/%s/con_00%02d_%s.nii',data_dir,flvl_model,subs{f},conds(c), ROI1{r}),'file')
                matlabbatch{1}.spm.util.imcalc.input = {sprintf('%s/%s/%s/con_00%02d.nii',data_dir,flvl_model,subs{f},conds(c)), sprintf('/data/pt_02187/fMRI_analysis/ROI/%s.nii',ROI1{r})}';
                matlabbatch{1}.spm.util.imcalc.output = sprintf('con_00%02d_%s.nii',conds(c),ROI1{r});
                matlabbatch{1}.spm.util.imcalc.outdir = {sprintf('%s/%s/%s/',data_dir,flvl_model,subs{f})};
                matlabbatch{1}.spm.util.imcalc.expression = 'i1.*i2';
                matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
                matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
                matlabbatch{1}.spm.util.imcalc.options.mask = 0;
                matlabbatch{1}.spm.util.imcalc.options.interp = 1;
                matlabbatch{1}.spm.util.imcalc.options.dtype = 4;  
                
                spm_jobman('run',matlabbatch);
                clear matlabbatch;
            end
            files{f,c}=sprintf('%s/%s/%s/con_00%02d_%s.nii',data_dir,flvl_model,subs{f},conds(c), ROI1{r});
        end
    end
end

model_name=sprintf('%s_%s',model_name,ROI1{r});

end

