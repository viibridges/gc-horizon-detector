function [zenith_homo, zengroupIds] = vp_zenith(lines_homo, opt)

% find the zenith LSs id
vertical_thres = sind(opt.thresZenithDiffAngleFromDeepTilt);
verticalInd = find(lines_homo(2,:) < vertical_thres);


%% ransac to find great circle that goes through the horline_homo

[zenith_homo, inlierId] = vp_ransac_refinement(lines_homo(:,verticalInd), opt);
zengroupIds = verticalInd(inlierId);