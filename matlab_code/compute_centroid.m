function COM=compute_centroid(T_cluster, x, y, z)
% Compute the COG based on the 50 highest t valeus

vec_T_cluster=T_cluster(:);
sorted=sort(vec_T_cluster,'descend');
sorted(isnan(sorted))=[];
Thr=sorted(50);



T_cluster(T_cluster<Thr)=0;


%if max(T_cluster)>0

    for i=1:length(x)  

        Cx(i)=T_cluster(x(i),y(i),z(i)).*x(i);
        Cy(i)=T_cluster(x(i),y(i),z(i)).*y(i);
        Cz(i)=T_cluster(x(i),y(i),z(i)).*z(i);


    end

    T_cluster(T_cluster==0)=0;
    T_cluster(isnan(T_cluster))=0;

    SCx=nansum(Cx)./sum(T_cluster(:));
    SCy=nansum(Cy)./sum(T_cluster(:));
    SCz=nansum(Cz)./sum(T_cluster(:));

    COM=[SCx SCy SCz];
%else
   % COM=[NaN NaN NaN]
%end
end