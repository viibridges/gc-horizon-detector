function [left, right] = regress_to_horizon(tilt_offset, width, height, base_xres, base_yres, Nbins, radius, distRange)

theta = tilt_offset(1);

% c = tilt_offset(2); % distance from image center to horizon center
c = tilt_offset(2) ./ cos(abs(theta)); % shortest distance from image center to horizon line (ie. offset_orth)

% left right to middle in small image
l = -tan(theta)*base_xres/2 + c;
r = tan(theta)*base_xres/2 + c;

% compute left, right to up-left in big image
[left, right] = regress_lr_horizon([l,r], width, height, base_xres, base_yres, Nbins, radius);