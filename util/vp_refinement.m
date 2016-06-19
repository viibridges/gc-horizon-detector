function vps_homo = vp_refinement(lines_homo, vps_homo, horizon_homo, opt)
% horizon_homo: must keep the refined points orthogonal to horizon_homo,
% ie. lies on the given horizon line in image space

rng(1)
Niters = opt.refineIters;
inlierThr = sind(opt.thetaThr);

Ngrps = size(vps_homo,2);

for ig = 1:Ngrps
  
  for it = 1:Niters
    goodIds = find(abs(vps_homo(:,ig)'*lines_homo) < inlierThr)';
    vps_homo(:,ig) = lines_normal(lines_homo(:,goodIds), horizon_homo);
  end
  
end
