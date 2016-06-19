function [ortho_horlines_homo, infiniteVP_homo] = sample_orthogonal_horlines_from_deep(zenith_homo, xres, yres, focal, deep, opt)


%
% sample horizon line
%

Nsamples = opt.NhorizonCandidates;
Nbins = numel(deep.offset_bins);
radius = deep.radius;
rng(1) % fix random seed

% find tilt in small image from zenith
x = zenith_homo(1)/zenith_homo(3) - opt.pp(1)/focal; 
y = zenith_homo(2)/zenith_homo(3) - opt.pp(2)/focal;
resize_scale = deep.base_yres * xres / deep.base_xres / yres;
tilt = atan(x/y * resize_scale); % just some math


% horizon candidates as [left, right] height
lefts = nan(Nsamples, 1);
rights = nan(Nsamples, 1);

delta_theta = range(atan(deep.offset_range/radius));
min_theta = min(atan(deep.offset_range/radius));

offset_binIds = random(deep.offset_bin_gaussian_model, Nsamples, 1);
offsets = tan(delta_theta * offset_binIds/(Nbins-1) + min_theta) * radius;

for ix = 1:Nsamples
  
  offset = offsets(ix);
  
  [lefts(ix), rights(ix)] = regress_to_horizon([tilt, offset], xres, yres,...
    deep.base_xres, deep.base_yres, Nbins, radius);
  
end

% filter unlikely horizon lines
yRange = yres*opt.horYresRatioRange;
hor_middle = (lefts + rights) / 2;
validIds = find(hor_middle > yRange(1) & hor_middle < yRange(2));

lefts = lefts(validIds);
rights = rights(validIds);

% sort and unique
[lefts, sortId] = unique(lefts);
rights = rights(sortId);


%
% [lefts, rights] -> homogeneous space
%
hor_seglines = [zeros(size(lefts(:))), lefts(:), xres*ones(size(rights(:))), rights(:)];
ortho_horlines_homo = img2homo(hor_seglines, xres, yres, focal);

infiniteVP_homo = lines_normal(ortho_horlines_homo);