function [] = First_level_specify(pmod,odour,ons,durs,current_sub, data_dir, model_name, model_dir, ncond, conds, timing)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    durs=repelem(durs,[cellfun(@numel,odour)])';
    ons=repelem(ons,[cellfun(@numel,odour)])';
    pmod=repelem(pmod,[cellfun(@numel,odour)])';
    timing((isnan(timing(:,3))),:)=[]; % Remove all trials without perceptual response
    odour=[odour{:}]; % Flatten cell array for ease of use
    
    
    %gunzip(sprintf('%s/%s/regress/%s_img_sm6.nii.gz',data_dir,current_sub,current_sub)); % unpack preprocessed file
    preprocessed=sprintf('%s/%s/regress/%s_img_sm6.nii',data_dir,current_sub,current_sub);
    new_model_dir=sprintf('%s/%s/%s/',model_dir,model_name,current_sub);
    if exist(new_model_dir,'dir')
        rmdir(new_model_dir,'s')
    end
    mkdir(new_model_dir)

    matlabbatch{1}.spm.stats.fmri_spec.dir = {new_model_dir};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = {preprocessed};
    for j=1:ncond
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).name = conds{j};
        if odour(j)~=0
            matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).onset = rmmissing(timing(timing(:,7)==odour(j),ons{j}));
            if length(durs{j})==2
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).duration = rmmissing(timing(timing(:,7)==odour(j),durs{j}(1))-timing(timing(:,7)==odour(j),durs{j}(2)));
            else
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).duration = zeros(length(rmmissing(timing(timing(:,7)==odour(j),ons{j}))),1); 
            end
            if pmod(j)~=0 && odour(j)~=3
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).pmod.name = sprintf('Intensity_%s',conds{j});
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).pmod.param = rmmissing(timing(timing(:,7)==odour(j),6));
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).pmod.poly = 1;
            else
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).pmod = struct('name', {}, 'param', {}, 'poly', {});
            end
        else
            matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).onset = rmmissing(timing(:,ons{j}));
            if length(durs{j})==2
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).duration = rmmissing(timing(:,durs{j}(1))-timing(:,durs{j}(2)));
            else
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).duration = zeros(length(rmmissing(timing(:,ons{j}))),1); 
            end
            if pmod(j)~=0
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).pmod.name = sprintf('Intensity_%s',conds{j});
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).pmod.param = rmmissing(timing(:,6));
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).pmod.poly = 1;
            else
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).pmod = struct('name', {}, 'param', {}, 'poly', {});
            end
        end    
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).orth = 1;
    end
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 1000;
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = -Inf;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

    spm_jobman('run',matlabbatch);
    clear matlabbatch;
end

