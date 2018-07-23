function [o_l, o_r] = parse_caffe_output(slope_pred, offset_pred, config, sz, crop_data)

[caffe_left_pred, caffe_right_pred] = so2lr(slope_pred, offset_pred, config.caffe_sz);

c_sz = crop_data.c_sz;
x_inds = crop_data.x_inds;
y_inds = crop_data.y_inds;

% scale from caffe image to cropped image
c_left_pred = caffe_left_pred(2) * (c_sz(1) / config.caffe_sz(1));
c_right_pred = caffe_right_pred(2) * (c_sz(1) / config.caffe_sz(1));

% scale from cropped image to original image
center = [(sz(2)+1)/2 (sz(1)+1)/2];
crop_center = [x_inds*[.5; .5]-center(1) center(2)-y_inds*[.5; .5]];
tmp_left = [-c_sz(2)/2 c_left_pred] + crop_center;
tmp_right = [c_sz(2)/2 c_right_pred] + crop_center;
[o_l, o_r] = compute_left_right_horizon_intersection(tmp_left, tmp_right, sz(2));