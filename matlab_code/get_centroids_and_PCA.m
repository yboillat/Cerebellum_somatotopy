%This script computes the different COG and perform a PCA in order to
%obtain the gradient orientation (first principal component). It also
%perform a Page test which tests whether the different body parts are
%significantly organized in an orderly manner. It also compute the Euler
%distance between the COG.


NbLabels=5; % Number of labels maps that should be combined 
 Mask=cellstr(spm_select(Inf ,'any','Select the different participant mask to binarize'));
  T_toes=cellstr(spm_select(Inf ,'any','Select t maps toes'));
  T_thumb=cellstr(spm_select(Inf ,'any','Select t maps thumb'));
  T_little=cellstr(spm_select(Inf ,'any','Select t maps littles'));
  T_tongue=cellstr(spm_select(Inf ,'any','Select t maps tongues'));
  T_eyes=cellstr(spm_select(Inf ,'any','Select t maps eyes'));
% % Anterior left 1:5
% % Anterior right 13:17
% % Posterior left 8:12
% % Posterior right 20:24
  Map_labels=cellstr(spm_select(Inf ,'any','Select CHROMA atlas'));

% This part compute the centroids based on the T-maps for subregions of
% the cerebellum. 
Hdr=load_nii_hdr(Map_labels{1,:});
A=spm_vol(T_little{3,:});
M=A.mat;
All_Data={};
NbSubj=9;
for i=1:NbSubj
    
    Masque=spm_read_vols(spm_vol(Mask{i,:})); 
    Masque(Masque >0.2)=1;
    
     Masque(Masque ~=1)=0;
    for j=1:NbLabels
        Label=spm_read_vols(spm_vol(Map_labels{:,:}));
        Label_bin=zeros(size(Label,1),size(Label,2),size(Label,3));
        Label_bin(Label==1 | Label==2 | Label==3 | Label==4 | Label==5)=1;% Adapt depending on the subregion.
        T_cluster=[];
%         if max(Label_bin(:))~=0;
        
        switch j
            case 1
                T_cluster_toes(:,:,:)=spm_read_vols(spm_vol(T_toes{i,:})).*Label_bin.*Masque;
              
                Ind=find(Label_bin==1);
                [x, y,z]=ind2sub(size(Label_bin),Ind);
                COM(1:3,i,j)=compute_centroid(T_cluster_toes, x, y, z);
            case 3
                T_cluster_thumb(:,:,:)=spm_read_vols(spm_vol(T_thumb{i,:})).*Label_bin.*Masque;
               
                Ind=find(Label_bin==1);
                [x, y,z]=ind2sub(size(Label_bin),Ind);
                COM(1:3,i,j)=compute_centroid(T_cluster_thumb, x, y, z);
            case 2
                T_cluster_little(:,:,:)=spm_read_vols(spm_vol(T_little{i,:})).*Label_bin.*Masque;
                
                Ind=find(Label_bin==1);
                [x, y,z]=ind2sub(size(Label_bin),Ind);
                COM(1:3,i,j)=compute_centroid(T_cluster_little, x, y, z);
            case 4
                T_cluster_tongue(:,:,:)=spm_read_vols(spm_vol(T_tongue{i,:})).*Label_bin.*Masque;
              
                Ind=find(Label_bin==1);
                [x, y,z]=ind2sub(size(Label_bin),Ind);
                COM(1:3,i,j)=compute_centroid(T_cluster_tongue, x, y, z);
            case 5
                T_cluster_eyes(:,:,:)=spm_read_vols(spm_vol(T_eyes{i,:})).*Label_bin.*Masque;
             
                Ind=find(Label_bin==1);
                [x, y,z]=ind2sub(size(Label_bin),Ind);
                COM(1:3,i,j)=compute_centroid(T_cluster_eyes, x, y, z);
        end
%         else
%               COM(:,i,j)=NaN;
%         end
    end
       

end

% From voxel to mm
for j=1:NbSubj
    
    for i=1:NbLabels

        x0=364-COM(1,j,i);y0=COM(2,j,i);z0=COM(3,j,i);
        x1(j,i) = M(1,1)*x0 + M(1,2)*y0 + M(1,3)*z0 + M(1,4);
        y1(j,i) = M(2,1)*x0 + M(2,2)*y0 + M(2,3)*z0 + M(2,4);
        z1(j,i) = M(3,1)*x0 + M(3,2)*y0 + M(3,3)*z0 + M(3,4);
    end
end

% Perform the page test
xA=x1(:); xB=y1(:); xC=z1(:);

model=[xA xB xC];
[Coeff, Scores, Var]=princomp(model);
remapScores=(reshape(Scores(:,1),9,5 ));
 [p,P] = mcpage(remapScores,1000) ;
%mean(p <= P)
L=405
NewP=(12*L - 3 * 9 *5 *((5+1)^2))^2/(9 *25*24*6)

% Create plot of COG and first principat component

figure;plot(Scores(1:9,1),Scores(1:9,2),'b.', Scores(10:18,1),Scores(10:18,2),'c.', Scores(19:27,1),Scores(19:27,2),'g.', Scores(28:36,1),Scores(28:36,2),'y.', Scores(37:45,1),Scores(37:45,2),'r.' )

origin=[mean(xA) mean(xB) mean(xC) ];
%origin=[0 0 0];
Col={'b' 'c' 'g' [1 .5 0] 'r'};

hold on;
figure;
for j=1:NbSubj
    
for i=1:NbLabels
  
%scatter3(x1(:,i),y1(:,i),z1(:,i),40,Col{i},'.');hold on;
%plot(COM(1,:,i),COM(2,:,i)'.');hold on;
% if ~isnan(COM(1,j,i))||~isnan(COM(2,j,i))||~isnan(COM(3,j,i))


% x_coeff = M(1,1)*(364-Coeff(1,1)) + M(1,2)*(Coeff(2,1)) + M(1,3)*(Coeff(3,1)) + M(1,4);
% y_coeff = M(2,1)*(364-Coeff(1,1)) + M(2,2)*(Coeff(2,1)) + M(2,3)*(Coeff(3,1)) + M(2,4);
% z_coeff = M(3,1)*(364-Coeff(1,1)) + M(3,2)*(Coeff(2,1)) + M(3,3)*(Coeff(3,1)) + M(3,4);
% 
% x_origin = M(1,1)*(364-origin(1)) + M(1,2)*origin(2) + M(1,3)*origin(3) + M(1,4);
% y_origin = M(2,1)*(364-origin(1)) + M(2,2)*origin(2) + M(2,3)*origin(3) + M(2,4);
% z_origin = M(3,1)*(364-origin(1)) + M(3,2)*origin(2) + M(3,3)*origin(3) + M(3,4);

x_coeff=Coeff(1,1)
y_coeff=Coeff(2,1)
z_coeff=Coeff(3,1)

x_origin=origin(1)
y_origin=origin(2)
z_origin=origin(3)

  x_coeff=(x_coeff+x_origin);
  y_coeff=y_coeff+y_origin;
  z_coeff=z_coeff+z_origin;

xlim = [5 35];
m = (y_coeff-y_origin)/(x_coeff-x_origin);
n = y_coeff - x_coeff*m;
y_ext_1 = m*xlim(1) + n;
y_ext_2 = m*xlim(2)+  n;
subplot(2,2,1);scatter(x1(:,i),y1(:,i),800,Col{i},'.');hold on;line([xlim(1) xlim(2)],[y_ext_1 y_ext_2])  %line([x_origin x_coeff],[y_origin y_coeff],'LineWidth',1);

xlim = [5 35];
m = (z_coeff-z_origin)/(x_coeff-x_origin);
n = z_coeff - x_coeff*m;
y_ext_1 = m*xlim(1) + n;
y_ext_2 = m*xlim(2)+  n;
subplot(2,2,2);scatter(x1(:,i),z1(:,i),800,Col{i},'.');hold on; line([xlim(1) xlim(2)],[y_ext_1 y_ext_2]) %line([x_origin x_coeff],[z_origin z_coeff],'LineWidth',1);

xlim = [-20 -80];
m = (z_coeff-z_origin)/(y_coeff-y_origin);
n = z_coeff - y_coeff*m;
y_ext_1 = m*xlim(1) + n;
y_ext_2 = m*xlim(2) + n;

subplot(2,2,3);scatter(y1(:,i),z1(:,i),800,Col{i},'.');hold on; line([xlim(1) xlim(2)],[y_ext_1 y_ext_2])  %line([y_origin y_coeff],[z_origin z_coeff],'LineWidth',1);
set(gca,'Xdir','reverse')


end
end

N=inv(M);
       


%Cpmute euler distance.
for i=1:NbSubj
   for j=1:NbLabels
       for k=1:NbLabels
            Distance(i,j,k)=sqrt((x1(i,j)-x1(i,k))^2+(y1(i,j)-y1(i,k))^2+(z1(i,j)-z1(i,k))^2);
       end
   end
      
end

AvegDistance=squeeze(mean(Distance,1)); 
StdDistance=squeeze(std(Distance,1));

figure;imagesc(AvegDistance);
names = {'Toes'; 'Littles'; 'Thumbs'; 'Tongue'; 'Eyes'};
set(gca,'xtick',[1:5],'xticklabel',names)
set(gca,'ytick',[1:5],'yticklabel',names)
caxis([0 30]);

figure;imagesc(StdDistance)
names = {'Toes'; 'Littles'; 'Thumbs'; 'Tongue'; 'Eyes'};
set(gca,'xtick',[1:5],'xticklabel',names)
set(gca,'ytick',[1:5],'yticklabel',names)
caxis([0 30]);
%colorbar;


% model=[x1' x2' x3'];
% [Coeff, Scores, Var]=princomp(model);
% origin=[mean(x1) mean(x2) mean(x3) ];
% 
% figure;plot3([origin(1) Coeff(1,1)],[origin(2) Coeff(2,1)],[origin(3) Coeff(3,1)],'LineWidth',1);hold on;
% plot3(x1',x2',x3','.')

