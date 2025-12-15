function vol_rgb = vol_color_overlay(vol_ovl,cm,crange,vol_bg_rgb)

vol_ind = max(1,min(size(cm,1),interp1(crange,[1 size(cm,1)],vol_ovl.imgs,'linear','extrap')));
vol_ovl_rgb = vol_ovl;
vol_ovl_rgb.imgs = reshape(cm(round(vol_ind(:)),:),[size(vol_ind) 3]);

if exist('vol_bg_rgb','var') & ~isempty(vol_bg_rgb)
  wtvol = repmat(max(vol_ovl_rgb.imgs,[],4),[1 1 1 3]);
  vol_rgb = vol_bg_rgb;
  vol_rgb.imgs = (1-wtvol).*vol_bg_rgb.imgs + wtvol.*vol_ovl_rgb.imgs;
else
  vol_rgb = vol_ovl_rgb;
end

%showVol(vol_rgb)

