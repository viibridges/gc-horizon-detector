function points_homo = normalize_point_homo(points_homo)

points_homo = bsxfun(@rdivide, points_homo, sqrt(sum(points_homo.^2,1)));
% keep in z-positive semisphere
points_homo = bsxfun(@times, points_homo, sign(points_homo(3,:)+ eps));