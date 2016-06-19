function [zenith_homo, inlierId] = vp_ransac_refinement(lines_homo, opt)

option = struct();
option.iterNum = 50;
option.thInlrRatio = .02; % this may change
option.thDist = sind(opt.thetaThr);

[~, inlierId] = ransac_intersection(lines_homo, option);
zenith_homo = lines_normal(lines_homo(:,inlierId));