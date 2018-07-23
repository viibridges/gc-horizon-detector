function [zenith_homo, zengroupIds] = vp_zenith_from_deep(lines_homo, deep, opt)

%
% threshold zenith LSs ids
%
% tilt of line that orthogonal to segments
lines_tilt_ortho = atand(-lines_homo(2,:) ./ lines_homo(1,:)); 
verticalInd = find(abs(lines_tilt_ortho - deep.slope) < opt.thresZenithDiffAngleFromDeepTilt);


%% ransac to find great circle that goes through the horline_homo

[zenith_homo, inlierId] = vp_ransac_refinement(lines_homo(:,verticalInd), opt);
zengroupIds = verticalInd(inlierId);