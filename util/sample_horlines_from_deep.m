function [ortho_horlines_homo, infiniteVP_homo] = sample_horlines_from_deep(xres, yres, focal, deep, opt)

sz = deep.sz;
config = deep.config;
crop_data = deep.crop_data;

Nsamples = opt.NhorizonCandidates;
rng(1) % fix random seed

slope_binIds = random(deep.slope_bin_gaussian_model, Nsamples, 1);
offset_binIds = random(deep.offset_bin_gaussian_model, Nsamples, 1);
lefts = nan(Nsamples,1); rights = nan(Nsamples,1);
for ix = 1:Nsamples
  slope = bin2val(slope_binIds(ix), config.slope_bin_edges);
  offset = bin2val(offset_binIds(ix), config.offset_bin_edges);
  [o_l, o_r] = parse_caffe_output(slope, offset, config, sz, crop_data);
  lefts(ix) = sz(1)/2 - o_l(2); rights(ix) = sz(1)/2 - o_r(2);
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