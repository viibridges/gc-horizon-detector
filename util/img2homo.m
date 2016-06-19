%
% convert lines or points from cartesian system (image frame) to homogenous system
%
function geometry_homo = img2homo(geometry_img, xres, yres, focal)

% centerize coordinates to image center
geometry_normalized = coordinates_filter(geometry_img, xres, yres, focal);

N = size(geometry_normalized, 1);

if size(geometry_normalized, 2) == 2 % the input is points
  geometry_homo = [geometry_normalized ones(N, 1)]';
  % all points should be in z-positive half sphere
  geometry_homo = bsxfun(@times, geometry_homo, sign(geometry_homo(3,:) + eps));
else  % the input is lines
  x1 = img2homo(geometry_img(:,[1,2]), xres, yres, focal);
  x2 = img2homo(geometry_img(:,[3,4]), xres, yres, focal);
  
  geometry_homo = cross(x1, x2);
  
  % all lines should be in y-positive half sphere, y axis is pointing down
  geometry_homo = bsxfun(@times, geometry_homo, sign(geometry_homo(2,:) + eps));
end


% normalize
geometry_homo = bsxfun(@rdivide, geometry_homo, sqrt(sum(geometry_homo.^2, 1)));