
% rsync -av --delete ~/Dropbox/matlab ~/Dropbox/matlab_new ip24.ucsd.edu:

load('~dale/tmp/rgbsnap.mat');

vol_prerend = struct;
vol_prerend.Mvxl2lph = vol_rgb.Mvxl2lph;
vol_prerend.imgs1 = cell(1,volsz_atl(3),1);
for i = 1:length(vol_prerend.imgs1), vol_prerend.imgs1{i} = flipdim(flipdim(imread(sprintf('~dale/tmp/FOD/FOD_s%03d.tif',i)),1),2); end % Axial
vol_prerend.imgs2 = cell(1,volsz_atl(1));
for i = 1:length(vol_prerend.imgs2), vol_prerend.imgs2{i} = flipdim(imread(sprintf('~dale/tmp/FOD/FOD_r%03d.tif',i)),2); end % Sagittal
vol_prerend.imgs3 = cell(1,volsz_atl(2));
for i = 1:length(vol_prerend.imgs3), vol_prerend.imgs3{i} = imread(sprintf('~dale/tmp/FOD/FOD_c%03d.tif',i)); end % Coronal

showVol(vol_aseg_rgb,vol_fiber_rgb,vol_rgb,vol_prerend) 



% Fix cursor (Draw lines in front of images)
% Allow for overlay of labels (selectable)


% Show correlation maps

load('~dale/Dropbox/tmp/vols_corr_snap.mat');
for ind = 1:prod(size(vols_corr)), vols_corr{ind}(~isfinite(vols_corr{ind})) = 0; end
for ind = 1:prod(size(vols_corr_zyg)), vols_corr_zyg{ind}(~isfinite(vols_corr_zyg{ind})) = 0; end

for modi = 1:length(modlist)
  sfigure(666); subplot(2,2,modi); plot(diag(Ss{modi}/Ss{modi}(1,1)).^2,'LineWidth',2); h=title(modlist{modi});
  sfigure(667); subplot(2,2,modi); semilogy(diag(Ss{modi}/Ss{modi}(1,1)).^2,'LineWidth',2); h=title(modlist{modi});
  drawnow;
end

ncomps = 10;
vols_comps = zeros([volsz_atl ncomps length(modlist)]);
for modi = 1:length(modlist)
  for compi = 1:ncomps
    vol_tmp = zeros(volsz_atl);
    vol_tmp(ivec_mask) = Us{modi}(:,compi);
    vol_tmp = vol_tmp/max(abs(vol_tmp(:)));
    vols_comps(:,:,:,compi,modi);
  end
end
showVol(vols_comps(:,:,:,:,4));


loci = 1; initialRCS = [62 64 72]; % Nucleus Accumbens

loci = 2; initialRCS = [59 70 67]; % GP

loci = 3; initialRCS = [59 71 73]; % Putamen

loci = 9; initialRCS = [56 68 72]; % ALIC

loci = 10; initialRCS = [56 70 62]; % PLIC

loci = 11; initialRCS = [57 61 51]; % SCC

loci = 12; initialRCS = [54 60 80]; % GCC


%showVol(reorient(vols_corr{loci,1,1}),reorient(vols_corr{loci,2,1}),reorient(vols_corr{loci,3,1}),reorient(vols_corr{loci,4,1}),vol_T1_rgb,vol_aseg_rgb,vol_rgb,vol_fiber_rgb,struct('RCS',initialRCS));
showVol(reorient(vols_corr{loci,1,2}),reorient(vols_corr{loci,2,2}),reorient(vols_corr{loci,3,2}),reorient(vols_corr{loci,4,2}),vol_T1_rgb,vol_aseg_rgb,vol_rgb,vol_fiber_rgb,struct('RCS',initialRCS));

suffi = 2; modi = 4;
showVol(reorient(vols_corr{loci,modi,suffi}),reorient(vols_corr_zyg{loci,modi,suffi,1}),reorient(vols_corr_zyg{loci,modi,suffi,2}),vol_T1_rgb,vol_aseg_rgb,vol_rgb,vol_fiber_rgb,vol_prerend,struct('RCS',initialRCS,'crange',[-1 1],'cmap',blueblackred));
showVol(reorient(vols_corr{loci,modi,suffi}),reorient(vols_corr_zyg{loci,modi,suffi,1}),reorient(vols_corr_zyg{loci,modi,suffi,2}),vol_T1_rgb,vol_aseg_rgb,vol_rgb,vol_fiber_rgb,vol_prerend,struct('RCS',initialRCS,'crange',[0 1],'cmap',gray(256)));
showVol(reorient(vols_corr{loci,modi,suffi}),reorient(vols_corr_zyg{loci,modi,suffi,1}),reorient(vols_corr_zyg{loci,modi,suffi,2}),vol_T1_rgb,vol_aseg_rgb,vol_rgb,vol_fiber_rgb,vol_prerend,struct('RCS',initialRCS,'crange',[0 1],'cmap',fire(256)));

suffi = 1;
showVol(reorient(vols_corr{loci,1,suffi}),reorient(vols_corr{loci,2,suffi}),reorient(vols_corr{loci,3,suffi}),reorient(vols_corr{loci,4,suffi}),vol_T1_rgb,vol_aseg_rgb,vol_rgb,vol_fiber_rgb,vol_prerend,struct('RCS',initialRCS,'crange',[-1 1],'cmap',blueblackred));
suffi = 2;
showVol(reorient(vols_corr{loci,1,suffi}),reorient(vols_corr{loci,2,suffi}),reorient(vols_corr{loci,3,suffi}),reorient(vols_corr{loci,4,suffi}),vol_T1_rgb,vol_aseg_rgb,vol_rgb,vol_fiber_rgb,vol_prerend,struct('RCS',initialRCS,'crange',[-1 1],'cmap',blueblackred));

suffi = 2;
showVol(reorient(vols_corr_zyg{loci,1,suffi,1}),reorient(vols_corr_zyg{loci,2,suffi,1}),reorient(vols_corr_zyg{loci,3,suffi,1}),reorient(vols_corr_zyg{loci,4,suffi,1}),vol_T1_rgb,vol_aseg_rgb,vol_rgb,vol_fiber_rgb,struct('RCS',initialRCS));
showVol(reorient(vols_corr_zyg{loci,1,suffi,2}),reorient(vols_corr_zyg{loci,2,suffi,2}),reorient(vols_corr_zyg{loci,3,suffi,2}),reorient(vols_corr_zyg{loci,4,suffi,2}),vol_T1_rgb,vol_aseg_rgb,vol_rgb,vol_fiber_rgb,struct('RCS',initialRCS));


% ToDo
%   change "darken" and "contrast" to "level" and "window" 



% Show statmaps -- see ABCD_dMRI_stats.m

showVol(vol_aseg_rgb,vol_fiber_rgb,vol_rgb,vol_prerend,vols_logp_rgb(1,:))


% Test mmil_dct_brainmask_amd

meanvol_T1_ctx = ctx_mgh2ctx(meanvol_T1,M_atl);

[brainmask_ctx,M_Atl_to_Subj,regStruct] = mmil_dct_brainmask_amd(meanvol_T1_ctx);

meanvol_T1_volm_ctx = vol_resample_amd(meanvol_T1_ctx,regStruct.volm,regStruct.M_atl_to_vol_af,1);
meanvol_T1_volm_dct_ctx = volMorph(regStruct.volm,meanvol_T1_ctx,regStruct.VL,regStruct.VP,regStruct.VH,1);
showVol(meanvol_T1_volm_ctx,meanvol_T1_volm_dct_ctx,regStruct.volm)

volm_meanvol_T1_ctx = vol_resample_amd(regStruct.volm,meanvol_T1_ctx,inv(regStruct.M_atl_to_vol_af),1);
tic
volm_meanvol_T1_dct_ctx = dctMorph_Inv(meanvol_T1_ctx,regStruct.volm,regStruct.Tr,regStruct.M_atl_to_vol_af,1); % Too slow!
toc
showVol(volm_meanvol_T1_ctx,meanvol_T1_ctx)

% Perform dct morph in opposite direction (after resampling by M_reg_aff)

% Transform regStruct into voxel index deformation field -- look at volm = volMorph(volt, voll, V_l, V_p, V_h,  [interpm], [padding], [bcalmp], [range], [voltmask]) 
% Also look at [volm, ind, ilph, iVl iVp iVh]=dctMorph_Inv(volt, vol, Tr, M_volt_to_vol_af, varargin)
% vxlmap = getDCTVxlMapping(vol, regStruct, atlmask) -- make into dI, dJ, dK



% ToDo
%   Draw lines in front of images
%   Fix high-res x- and y- axis ticks (make consistent with low-res)

%   Fix window/level controls

%   Enable heatmap overlay, with settable threshold + max
%   Should flip A/P in sagittal view, to be consistent with radiological conventions
%   Enable overlay with transparency/opacity
%   Allow for multiple surfaces, labled ROIs
