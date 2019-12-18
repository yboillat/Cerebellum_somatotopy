% This code can be used to generate the label maps using a winner-take-all approach based on the T and F maps. 

spm_get_defaults 
%p = 0.01;

%th = spm_invFcdf(1-p,10,314);
th=4.18; % Select statistical threshold
%V=spm_vol(cellstr(spm_select));

 V(1) = spm_vol('spmT_0002.nii');
 V(3) = spm_vol('spmT_0003.nii');
 V(2) = spm_vol('spmT_0004.nii');
 V(4) = spm_vol('spmT_0005.nii');
 V(5) = spm_vol('spmT_0006.nii');
 Y = spm_read_vols(V);




funcmask = spm_read_vols(spm_vol('spmF_0001.nii'));
[maxY, I] = max(Y,[],4);
Iout = I.*(funcmask > th);


Vout = V(1);
Vout.fname = 'Somato_XX.nii';
Vout = spm_create_vol(Vout);
spm_write_vol(Vout, Iout);
