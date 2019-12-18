% This script extracts the T values (works also with beta values) from a defined ROI (specific label) and
% plots the results as  bar plots. It was used to see how specific was a
% body representation is. 
% % 
 NbLabels=5; % Number of labels maps that should be combined 
 Mask=cellstr(spm_select(Inf ,'any','Select the different participants to binarize'));% Segmented whole cerebellum
 Betas_toes=cellstr(spm_select(Inf ,'any','Select betas toes'));
 Betas_thumb=cellstr(spm_select(Inf ,'any','Select betas thumb'));
 Betas_little=cellstr(spm_select(Inf ,'any','Select betas littles'));
 Betas_tongue=cellstr(spm_select(Inf ,'any','Select betas tongues'));
 Betas_eyes=cellstr(spm_select(Inf ,'any','Select betas eyes'));
 CHROMA_atlas=cellstr(spm_select(Inf ,'any','Select CHROMA atlas'));
 Map_labels=cellstr(spm_select(Inf ,'any','Select map of labels'));

Betas_all=[Betas_toes Betas_thumb Betas_little Betas_tongue Betas_eyes];


Hdr=load_nii_hdr(Map_labels{1,:});

All_Data=[];
NbSubj=9;
Size_cluster=[];all_Size_cluster=[];
for i=1:NbSubj
    Label=spm_read_vols(spm_vol(Map_labels{i,:}));
    Masque=spm_read_vols(spm_vol(CHROMA_atlas{:}));
    Masque(Masque ==1)=0; 
    Masque(Masque==20)=1;Masque(Masque==21)=1;Masque(Masque==22)=1;Masque(Masque==23)=1;Masque(Masque==24)=1;%Select a subregion of the cerebellum (eg. anterior left) based on the CHROMA atlas. Numbers have to be changed accordingly. Be carefull with lobule 1 
    Masque(Masque ~=1)=0;
    Mask_subj=spm_read_vols(spm_vol(Mask{i,:}));
    Mask_subj(Mask_subj>0.2)=1; 
    for j=1:NbLabels
        
        Label_bin=zeros(size(Label,1),size(Label,2),size(Label,3));
        Label_bin(Label==j)=1;
        Beta=[];
        
        for k=1:5
        BigMask=Label_bin.*Mask_subj;
        BigMask(BigMask>0.001)=1;
        Beta=spm_read_vols(spm_vol(Betas_all{i,k})).*BigMask;
        Beta(Beta==0)=[];
        Beta(isnan(Beta))=[];
        Size_cluster(k)=length(Beta);
       Beta_mean_oneSub(k)=mean(Beta);
        clear BigMask;
        
        end
        %Beta(Beta==0)=NaN;
      
       all_Size_cluster(j,i,:)=Size_cluster;
        %Beta_mean_oneSub(Beta_mean_oneSub==0) = [];
        All_Data(j,i,:) = Beta_mean_oneSub;
    end

    clear Label; 
    clear Mask_subj;
end


MeanAcrossSub=squeeze(mean(All_Data,2));
StdAcrossSub=squeeze(std(All_Data,0,2));

figure
for l=1:5
    subplot(4,5,l)
    bar(MeanAcrossSub_AL(l,:));hold on; errorbar(MeanAcrossSub_AL(l,:),StdAcrossSub_AL(l,:)/sqrt(9));ylim([-3 5.3]);set(gca,'xtick',[1:5],'xticklabel',{'' '' '' '' ''},'Fontsize',7);set(gca,'FontSize',10)%;ylabel('T value')
end
for l=1:5
    subplot(4,5,5+l)
    bar(MeanAcrossSub_AR(l,:));hold on; errorbar(MeanAcrossSub_AR(l,:),StdAcrossSub_AR(l,:)/sqrt(9));ylim([-3 5.3]);set(gca,'xtick',[1:5],'xticklabel',{'' '' '' '' ''},'Fontsize',7);set(gca,'FontSize',10)%;ylabel('T value')
end
for l=1:5
    subplot(4,5,10+l)
    bar(MeanAcrossSub_PL(l,:));hold on; errorbar(MeanAcrossSub_PL(l,:),StdAcrossSub_PL(l,:)/sqrt(9));ylim([-3 5.3]);set(gca,'xtick',[1:5],'xticklabel',{'' '' '' '' ''},'Fontsize',7);set(gca,'FontSize',10)%;ylabel('T value')
end
for l=1:5
    subplot(4,5,15+l)
    bar(MeanAcrossSub_PR(l,:));hold on; errorbar(MeanAcrossSub_PR(l,:),StdAcrossSub_PR(l,:)/sqrt(9));ylim([-3 5.3]);set(gca,'xtick',[1:5],'xticklabel',{'' '' '' '' ''},'Fontsize',7);set(gca,'FontSize',10)%;ylabel('T value')
end



