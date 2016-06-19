function [left, right] = class_to_horizon(tilt_offset, width, height, base_xres, base_yres, Nbins, radius, distRange)

if ~exist('distRange', 'var')
  distRange = [-Inf Inf];
end

delta_theta = range(atan(distRange/radius));
min_theta = min(atan(distRange/radius));

% bin number start from 0
Nbins = Nbins - 1;

% recover tilt offset from bin number
tilt = pi * tilt_offset(1)/Nbins - pi/2;
offset = tan(delta_theta * tilt_offset(2)/Nbins + min_theta) * radius;

[left, right] = regress_to_horizon([tilt, offset], width, height, base_xres, base_yres, Nbins, radius);