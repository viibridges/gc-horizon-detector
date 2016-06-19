function deep = extract_context_with_cnn(im, net)

crop_size = 256;
pixel_mean = 115; % can't use mean file in matcaffe

im_resized = imresize(im, [crop_size, crop_size]); % resize
im_mean = double(im_resized) - pixel_mean;         % center
caffe_im = single(permute(im_mean(:,:,[3,2,1]), [2,1,3]));

out = net.forward({caffe_im});
slope_bins = out{1};
offset_bins = out{2};

%
% detect horizon line
%
xres = size(im, 2);
yres = size(im, 1);

% cnn horizon line
radius = crop_size / 5;
offset_range = [-Inf, Inf];
Nbins = numel(slope_bins);
[~, slope_bin] = max(slope_bins); slope_bin = slope_bin - 1;
[~, offset_bin] = max(offset_bins); offset_bin = offset_bin - 1;
[l, r] = class_to_horizon([slope_bin, offset_bin], xres, yres, crop_size, crop_size, Nbins, radius, offset_range);

% process deep network predictions
deep = struct();
deep.tilt_bins = slope_bins;
deep.offset_bins = offset_bins;
deep.base_xres = crop_size;
deep.base_yres = crop_size;
deep.radius = deep.base_yres / 5;
deep.tilt_bin_gaussian_model = hist2gaussian_model(deep.tilt_bins);
deep.offset_bin_gaussian_model = hist2gaussian_model(deep.offset_bins);
deep.offset_range = [-Inf, Inf];
deep.left_cnn = [0 l];
deep.right_cnn = [xres r];