function opt = default_option()

opt = struct();

% common
opt.thetaThr = 2; % if l'*x < sind(thetaThr), l consistent with x
opt.score_function = @(x) (opt.thetaThr-x) .* (opt.thetaThr > x);

opt.zenith_from_deep = true; % if initialize zenith vp from CNN outputs
opt.thresZenithDiffAngleFromDeepTilt = 10;

% refinement
opt.horvp_refinement = true;
opt.refineIters = 3;
opt.distThr = cosd(33);
opt.subset_method = 'independent_set'; % finding subset
opt.maxVPs = 2;
opt.NhorizonCandidates = 300;

opt.pp = [0 0];

%
% linear sampling
%
opt.horRange = [-1.5, 2.5]; %filtering


opt.verLineNoiseThresAngle = 15;
opt.horLineNoiseThresAngle = 1.5;
opt.horYresRatioRange = [-Inf Inf];

opt.sampling_method = 'hybrid';