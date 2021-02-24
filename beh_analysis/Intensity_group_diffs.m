%{
%% Individual habituation
for j=1:62
    for i=1:5
    figure(j)
    hold on
    plot(All_timing{j,1}((All_timing{j,1}(:,7)==i),6))
    end
end

%% Group habituation for everyone
rating_matrix={};
for stims=1:5
    for sub=1:62
        rating_matrix{stims}(:,sub)=All_timing{sub,1}((All_timing{sub,1}(:,7)==stims),6);
    end
end


for i=1:4
    figure(1)
    hold on
    plot(mean(rating_matrix{1,i},2,'omitnan'))
end

%% Habituation for obese vs. lean
load behavioural_data.mat
%}
load behavioural_data.mat
obese=Behavioural.BIDS_ID(Behavioural.BMI>30);
lean=Behavioural.BIDS_ID(Behavioural.BMI<25);
ow=Behavioural.BIDS_ID(Behavioural.BMI<30 & Behavioural.BMI>25);

timing_obese={};
rating_matrix_ob={};
index=1;
for i=1:length(obese)
    for j=1:62
        if strcmp(obese(i),All_timing{j,3})
            timing_obese{index,1}=All_timing{j,1};
            index=index+1;
        end
    end
end

for stims=1:5
    for sub=1:length(timing_obese)
        rating_matrix_ob{stims}(:,sub)=timing_obese{sub,1}((timing_obese{sub,1}(:,7)==stims),6);
    end
end

timing_lean={};
rating_matrix_le={};
index=1;
for i=1:length(obese)
    for j=1:62
        if strcmp(lean(i),All_timing{j,3})
            timing_lean{index,1}=All_timing{j,1};
            index=index+1;
        end
    end
end

for stims=1:5
    for sub=1:length(timing_lean)
        rating_matrix_le{stims}(:,sub)=timing_lean{sub,1}((timing_lean{sub,1}(:,7)==stims),6);
    end
end

timing_ow={};
rating_matrix_ow={};
index=1;
for i=1:length(ow)
    for j=1:62
        if strcmp(ow(i),All_timing{j,3})
            timing_ow{index,1}=All_timing{j,1};
            index=index+1;
        end
    end
end

for stims=1:5
    for sub=1:length(timing_ow)
        rating_matrix_ow{stims}(:,sub)=timing_ow{sub,1}((timing_ow{sub,1}(:,7)==stims),6);
    end
end
%{
close all
for i=1:4
    figure(1)
    hold on
    plot(mean(rating_matrix_le{1,i},2,'omitnan'))
end

for i=1:4
    %figure()
    hold on
    plot(mean(rating_matrix_ob{1,i},2,'omitnan'))
end
%}

lean=[rating_matrix_le{1,1},rating_matrix_le{1,2},rating_matrix_le{1,3},rating_matrix_le{1,4}];
ob=[rating_matrix_ob{1,1},rating_matrix_ob{1,2},rating_matrix_ob{1,3},rating_matrix_ob{1,4}];
ow=[rating_matrix_ow{1,1},rating_matrix_ow{1,2},rating_matrix_ow{1,3},rating_matrix_ow{1,4}];

%{
figure(3)
plot(mean(lean,2,'omitnan'))
hold on
plot(mean(ob,2,'omitnan'))
%}

%% Calculate mean values for obese and lean
ob_rat_mean=[];
le_rat_mean=[];
ow_rat_mean=[];
for o=1:length(rating_matrix_ob)
    ob_rat_mean=[ob_rat_mean;nanmean(rating_matrix_ob{o})];
    le_rat_mean=[le_rat_mean;nanmean(rating_matrix_le{o})];
    ow_rat_mean=[ow_rat_mean;nanmean(rating_matrix_ow{o})];
end
group=[ones(length(ob_rat_mean(1,:)),1)' 2*ones(length(le_rat_mean(1,:)),1)' 3*ones(length(ow_rat_mean(1,:)),1)'];

[p1, t1, stats1]=anova1([ob_rat_mean(1,:) le_rat_mean(1,:) ow_rat_mean(1,:)], group);
[p2, t2, stats2]=anova1([ob_rat_mean(2,:) le_rat_mean(2,:) ow_rat_mean(2,:)], group);
[p3, t3, stats3]=anova1([ob_rat_mean(3,:) le_rat_mean(3,:) ow_rat_mean(3,:)], group);
[p4, t4, stats4]=anova1([ob_rat_mean(4,:) le_rat_mean(4,:) ow_rat_mean(4,:)], group);
%[p5, t5, stats5]=anova1([ob_rat_mean(5,:) le_rat_mean(5,:) ow_rat_mean(5,:)]);

%% Between stimuli differences
   

for stims=1:5
    for sub=1:length(All_timing)
        rating_matrix_all{stims}(:,sub)=All_timing{sub,1}((All_timing{sub,1}(:,7)==stims),6);
    end
end

rat_mean=[];
for o=1:length(rating_matrix_all)
    rat_mean=[rat_mean;nanmean(rating_matrix_all{o})];
end

rat_mean(5,:)=[];

 [p,t,stats] = anova1(rat_mean')
 [c,m,h,nms] = multcompare(stats)
 