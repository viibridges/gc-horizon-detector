function [hl_left, hl_right] = compute_left_right_horizon_intersection(left,right,width)

hl_homo = cross([left 1], [right 1]);
hl_left_homo = cross(hl_homo, [-1 0 -width/2]);
hl_left = hl_left_homo(1:2)/hl_left_homo(end);
hl_right_homo = cross(hl_homo, [-1 0 width/2]);
hl_right = hl_right_homo(1:2)/hl_right_homo(end);

% this is not faster
% hl_homo = cross([left 1], [right 1]);
% hl_pt_homo = cross([hl_homo;hl_homo], [-1 0 -width/2; -1 0 width/2],2);
% hl_left = hl_pt_homo(1,1:2)/hl_pt_homo(1,end);
% hl_right = hl_pt_homo(2,1:2)/hl_pt_homo(2,end);
