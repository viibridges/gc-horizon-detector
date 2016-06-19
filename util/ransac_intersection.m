function [M, inlierIdx] = ransac_intersection(lines_homo, ransacCoef)
rng(1);

minPtNum = 2;  % sample 2 LSs to find the VP
iterNum = ransacCoef.iterNum;
thInlrRatio = ransacCoef.thInlrRatio;
thDist = ransacCoef.thDist;
ptNum = size(lines_homo,2);
thInlr = round(thInlrRatio*ptNum);

if ptNum < minPtNum
  M = zeros(3,2);
  inlierIdx = [];
  N = 0;
  return
end

inlrNum = zeros(1,iterNum);
fLib = cell(1,iterNum);

for p = 1:iterNum
  % 1. fit using random points
  M = randIndex(lines_homo, ptNum, minPtNum);
  
	% 2. count the inliers, if more than thInlr, refit; else iterate
	dist = calcdist(M, lines_homo);
  
	inlier1 = find(dist < thDist);
	inlrNum(p) = length(inlier1);
	if length(inlier1) < thInlr, continue; end
	fLib{p} = M;
end

% 3. choose the coef with the most inliers
[~,idx] = max(inlrNum);
if ~isempty(fLib{idx})
  M = fLib{idx};
	dist = calcdist(M, lines_homo);
  inlierIdx = find(dist < thDist);
else
  disp('no enough inliers.')  
  % randomly generate M
  M = randIndex(lines_homo, ptNum, minPtNum);
  inlierIdx = [];
end



function [M, index] = randIndex(lines_homo, maxIndex,len)
%INDEX = RANDINDEX(MAXINDEX,LEN)
%   randomly, non-repeatedly select LEN integers from 1:MAXINDEX

index = randperm(maxIndex, len);

% normal of great circle consisting of 2 randomly sampled points.
M = cross(lines_homo(:, index(1)), lines_homo(:, index(2)));
M = M / norm(M);
M = M * sign(M(2) + eps); % stay in y-positive plane

function d = calcdist(M, X)

d = abs(M'*X);