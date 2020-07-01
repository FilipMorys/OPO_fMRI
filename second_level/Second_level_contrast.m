function [] = Second_level_contrast(model_dir,model_name,con_weights,con_names)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
        matlabbatch{1}.spm.stats.con.spmmat = {sprintf('%s/%s/SPM.mat',model_dir,model_name)};
        
        for c=1:length(con_names)
                      
            matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = con_names{c};
            matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = con_weights{c};
            matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'none';
            matlabbatch{1}.spm.stats.con.delete = 1;

        end
        
    spm_jobman('run',matlabbatch);
    clear matlabbatch;
        
end