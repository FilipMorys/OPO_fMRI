function [] = First_level_contrast(model_dir,model_name,current_sub,con_names,con_weights,ncon)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
        matlabbatch{1}.spm.stats.con.spmmat = {sprintf('%s/%s/%s/SPM.mat',model_dir,model_name,current_sub)};
        
        for c=1:ncon
                      
            matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = con_names{c};
            matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = con_weights{c};
            matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'none';
            matlabbatch{1}.spm.stats.con.delete = 1;

        end
        
        spm_jobman('run',matlabbatch);
        clear matlabbatch;
        
end

