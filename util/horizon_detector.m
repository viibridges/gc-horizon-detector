function [horizon_homo, stat] = horizon_detector(seglines, xres, yres, focal, deep, opt)

rng(1) % fix random seed


%% dealing with options
if ~exist('opt', 'var')
  opt=default_option();
end


%% centerize coordinates to image center and map geometry (lines/points) to homogeneous space
lines_homo = img2homo(seglines, xres, yres, focal);


%% sample horizon line

%
% find zenith VP
%
if opt.zenith_from_deep
  [zeniths_homo, zengroups] = vp_zenith_from_deep(lines_homo, deep, opt);
else
  [zeniths_homo, zengroups] = vp_zenith(lines_homo, opt);
end


if strcmp(opt.sampling_method, 'linear')
  %
  % zenith VP as constraint, horizon candidates' offsets sampled from image
  % space uniformly
  %
  [ortho_horlines_homo, infiniteVPs_homo] = sample_orthogonal_horlines(zeniths_homo, xres, yres, focal, opt);
  
elseif strcmp(opt.sampling_method, 'uniform')  
  %
  % zenith VP as constraint, horizon candidates' offsets sampled from image
  % space uniformly
  %
  [ortho_horlines_homo, infiniteVPs_homo] = sample_orthogonal_horlines_uniform(zeniths_homo, xres, yres, focal, opt);
  
elseif strcmp(opt.sampling_method, 'hybrid')
  %
  % zenith VP as constraint, horizon candidates' offsets sampled from deep network
  %
  [ortho_horlines_homo, infiniteVPs_homo] = sample_orthogonal_horlines_from_deep(zeniths_homo, xres, yres, focal, deep, opt);
  
elseif strcmp(opt.sampling_method, 'grid')
  %
  % try the given horizon lines
  %
  ortho_horlines_homo = img2homo(opt.grid.horizon_candidates, xres, yres, focal);
  infiniteVPs_homo = lines_normal(ortho_horlines_homo);
  
else
  %
  % zenith VP not as constraint (horizon line candidates directly sampled from deep network)
  %
  [ortho_horlines_homo, infiniteVPs_homo] = sample_horlines_from_deep(xres, yres, focal, deep, opt);
end


%% make code compatible with previous history

if size(infiniteVPs_homo, 2) == 1 % old code
  infiniteVPs_homo = repmat(infiniteVPs_homo, 1, size(ortho_horlines_homo, 2));
  zeniths_homo = repmat(zeniths_homo, 1, size(ortho_horlines_homo, 2));
  zengroups = repmat({zengroups}, 1, size(ortho_horlines_homo, 2));
end
  

%% score horizon lines

candidates = repmat(struct(), size(ortho_horlines_homo,2),1);
for i = 1:size(ortho_horlines_homo,2)
    
  % throw out useless vertical and horizontal linesegments
  helpfulIds = filter_verhor_lines(lines_homo, zeniths_homo(:,i), infiniteVPs_homo(:,i), opt);

  % randomly select dozens of LSs, compute their intersection with the horizon line
  rng(1)
  initialIds = randperm(numel(helpfulIds), min(numel(helpfulIds), 20));
  
  candidates(i).horizon_homo = ortho_horlines_homo(:,i);
  [candidates(i).sc, candidates(i).vps_homo, horgroups] = ...
    compute_orthogonal_horizontal_vps(lines_homo(:,helpfulIds), initialIds,...
    candidates(i).horizon_homo, opt);
    
  candidates(i).horgroups = cellfun(@(x) helpfulIds(x), horgroups, 'UniformOutput', false);
  
end


%% decide the horizon line
horCandidateScores = [candidates.sc];
[~,maxHorCandidateId] = max(horCandidateScores);

horizon_homo = candidates(maxHorCandidateId).horizon_homo;


%% output statisticas

stat = struct();

%
% vp related
%
stat.vps_homo = candidates(maxHorCandidateId).vps_homo;
stat.zen_homo = lines_normal(lines_homo(:,zengroups{maxHorCandidateId}));

stat.zengroup = zengroups{maxHorCandidateId};
stat.horgroup = candidates(maxHorCandidateId).horgroups;

stat.vpsgroup = [stat.zengroup; stat.horgroup];
stat.vps_homo = [stat.zen_homo, stat.vps_homo];

%
% score related
%
stat.horCandidates_homo = ortho_horlines_homo;
stat.horCandidateScores = horCandidateScores;
stat.maxHorCandidateId = maxHorCandidateId;
stat.allCandidates = candidates;
