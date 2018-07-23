% get four corners, center, horizon for center

function crop_data = prepare_image(config, im, sz, left_center, right_center)

if nargin < 4
  left_center = []; right_center = [];
end

crop_data = struct();

%
% get max size center crop
%

bottom_crop = false;
side_length = min(sz);
if sz(1) > sz(2)
  ul_x = 1;
  if bottom_crop
    ul_y = sz(1) - side_length + 1;
  else
    ul_y = floor((sz(1)/2) - (side_length/2))+1;
  end
  x_inds = [ul_x, sz(2)];
  y_inds = [ul_y, ul_y+side_length-1];
else
  ul_x = floor((sz(2)/2) - (side_length/2))+1;
  ul_y = 1;
  x_inds = [ul_x, ul_x+side_length-1];
  y_inds = [ul_y, sz(1)];
end

c_im = im(y_inds(1):y_inds(2), x_inds(1):x_inds(2), :);
c_sz = size(c_im); c_sz = c_sz(1:2);

crop_data.c_im = c_im;
crop_data.c_sz = c_sz;
crop_data.x_inds = x_inds;
crop_data.y_inds = y_inds;
crop_data.caffe_input = preprocess_image(c_im, config.caffe_sz, config.mean_pixel);

%
% parameterize the horizon line
%

if ~isempty(left_center) && ~isempty(right_center)
  
  % TODO: revisit

end
