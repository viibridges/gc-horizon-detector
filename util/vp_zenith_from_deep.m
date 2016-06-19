function [zenith_homo, zengroupIds] = vp_zenith_from_deep(lines_homo, deep, opt)

%
% threshold zenith LSs ids
%
[~, maxtiltid] = max(deep.tilt_bins);
tilt = tand(pi * maxtiltid/(numel(deep.tilt_bins)-1) - pi/2)*deep.radius;

% tilt of line that orthogonal to segments
lines_tilt_ortho = atand(-lines_homo(2,:) ./ lines_homo(1,:)); 
verticalInd = find(abs(lines_tilt_ortho - tilt) < opt.thresZenithDiffAngleFromDeepTilt);


%% ransac to find great circle that goes through the horline_homo

[zenith_homo, inlierId] = vp_ransac_refinement(lines_homo(:,verticalInd), opt);
zengroupIds = verticalInd(inlierId);


%% vp refinement without constraint

% figure(88);clf
% plot3(lines_homo(1,:), lines_homo(2,:), lines_homo(3,:), '.')
% hold on
% plot3(lines_homo(1,verticalInd), lines_homo(2,verticalInd), lines_homo(3,verticalInd), 'r*')
% hold off

% zenith_homo = lines_normal(lines_homo(:,verticalInd));
% [zenith_homo, inlierId] = vp_refinement_noncon(lines_homo(:,verticalInd), zenith_homo, opt);
% zengroupIds = verticalInd(inlierId);