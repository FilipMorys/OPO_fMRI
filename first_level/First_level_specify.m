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
    for j=1:ncond % for all conditions
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).name = conds{j};
        if odour(j)~=0 && odour(j)~=5 && odour(j)~=6 % If dividing conditions for different odours and if this odour is NOT neutral and if it is not an error regressor
            matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).onset = rmmissing(timing(timing(:,7)==odour(j) & timing(:,8)==1,ons{j}));
            if length(durs{j})==2 % If not modelling events as stick functions, so with durations
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).duration = rmmissing(timing(timing(:,7)==odour(j) & timing(:,8)==1,durs{j}(1))-timing(timing(:,7)==odour(j) & timing(:,8)==1,durs{j}(2))); % If participant smelled anaything consciously ONLY
            else % if durations = 0
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).duration = zeros(length(rmmissing(timing(timing(:,7)==odour(j) & timing(:,8)==1,ons{j}))),1); 
            end
            if pmod(j)~=0 % If we want parametric modulation
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).pmod.name = sprintf('Intensity_%s',conds{j});
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).pmod.param = rmmissing(timing(timing(:,7)==odour(j) & timing(:,8)==1,6));
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).pmod.poly = 1;
            else % If not pmod
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).pmod = struct('name', {}, 'param', {}, 'poly', {});
            end
        elseif odour(j)==5 % If odour is neutral 
            matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).onset = rmmissing(timing(timing(:,7)==odour(j) & timing(:,8)==2,ons{j})); % only take trials correctly identified as neutral
            matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).pmod = struct('name', {}, 'param', {}, 'poly', {}); % no pmod
            if length(durs{j})==2 % If not modelling events as stick functions, so with durations
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).duration = rmmissing(timing(timing(:,7)==odour(j) & timing(:,8)==2,durs{j}(1))-timing(timing(:,7)==odour(j) & timing(:,8)==2,durs{j}(2))); % If participant smelled anaything consciously ONLY
            else % if durations = 0
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).duration = zeros(length(rmmissing(timing(timing(:,7)==odour(j) & timing(:,8)==2,ons{j}))),1); 
            end
        elseif odour(j)==6 % For error regressors
            matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).onset = rmmissing(timing(timing(:,7)~=5 & timing(:,8)==2,ons{j})); % only take trials wrongly identified as neutral
            matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).pmod = struct('name', {}, 'param', {}, 'poly', {}); % no pmod
            if length(durs{j})==2 % If not modelling events as stick functions, so with durations
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).duration = rmmissing(timing(timing(:,7)~=5 & timing(:,8)==2,durs{j}(1))-timing(timing(:,7)~=5 & timing(:,8)==2,durs{j}(2))); % If participant smelled anaything consciously ONLY
            else % if durations = 0
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).duration = zeros(length(rmmissing(timing(timing(:,7)~=5 & timing(:,8)==2,ons{j}))),1); 
            end            
        else % If simple condition odour-independent
            matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).onset = rmmissing(timing(timing(:,8)==1,ons{j}));
            if length(durs{j})==2 % If not modelling events as stick functions, so with durations
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).duration = rmmissing(timing(timing(:,8)==1,durs{j}(1))-timing(timing(:,8)==1,durs{j}(2)));
            else % if durations = 0
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).duration = zeros(length(rmmissing(timing(timing(:,8)==1,ons{j}))),1); 
            end
            if pmod(j)~=0 && odour(j)~=5 % If pmod and stimulation was not neutral
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).pmod.name = sprintf('Intensity_%s',conds{j});
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).pmod.param = rmmissing(timing(timing(:,8)==1,6));
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(j).pmod.poly = 1;
            else % If not pmod
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

