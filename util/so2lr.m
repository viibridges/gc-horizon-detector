%
% given slope / offset (image heights), compute left / right (centered)
%

function [left, right] = so2lr(slope, offset, sz)

% convert offset from image heights to pixels
offset = offset .* sz(1);

% compute distance from image center to horizon center
c = offset ./ cos(abs(slope)); 
left = [repmat(-sz(2)/2, size(c)) -tan(slope)*sz(2)/2 + c];
right = [repmat(sz(2)/2, size(c)) tan(slope)*sz(2)/2 + c];