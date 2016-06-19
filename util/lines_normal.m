function vp_homo = lines_normal(line_homo, b)
% this function solve the homogeneous least squares prob
% A = line_homo', find x s.t. min(||Ax||)
% if b is given, then add a constraint: b'x = 0, which means x is forced to
% be orthogonal to b.

if ~exist('b', 'var')
  
  [U, ~, ~] = svd(line_homo*line_homo');
  vp_homo = U(:,3);
  
else
  
  [U, ~, ~] = svd(b);
  p = U(:,2); q = U(:,3);
  Am = line_homo'*[p,q];
  [U, ~, ~] = svd(Am'*Am);
  lambda = U(:,end);
  vp_homo = [p,q]*lambda;
  vp_homo = vp_homo / norm(vp_homo);
  
end

% force to the z-positive semisphere
vp_homo = vp_homo * sign(vp_homo(3)+eps);

% [0 0 0] -> [0 1 0]
if sum(vp_homo) == 0
  vp_homo = [0 1 0]';
end