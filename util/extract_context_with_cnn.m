function deep = extract_context_with_cnn(im, net)

sz = size(im);
sz = sz(1:2);

% setup parameters for cnn
config = horizon_setup();
crop_data = prepare_image(config, im, sz);

% deploy net
net.blobs('data').reshape([config.caffe_sz, 3, 1]);
net.blobs('data').set_data(crop_data.caffe_input);
net.forward_prefilled();
slope_dist = net.blobs('prob_slope').get_data;
offset_dist = net.blobs('prob_offset').get_data;

% net outputs to horizon line 
[~, slope_max_bin] = max(slope_dist);
[~, offset_max_bin] = max(offset_dist);
slope = bin2val(slope_max_bin, config.slope_bin_edges);
offset = bin2val(offset_max_bin, config.offset_bin_edges);
[o_l, o_r] = parse_caffe_output(slope, offset, config, sz, crop_data);
l = [sz(2)/2+o_l(1), sz(1)/2-o_l(2)]; 
r = [sz(2)/2+o_r(1), sz(1)/2-o_r(2)]; 

% figure(12);clf
% image(im)
% hold on
% plot([l(1) r(1)], [l(2) r(2)], 'y--', 'linewidth', 2)
% hold off
% axis off equal
% drawnow

% process deep network predictions
deep = struct();
deep.config = config;
deep.crop_data = rmfield(crop_data, {'c_im', 'caffe_input'});
deep.sz = sz(1:2);
deep.slope_dist = slope_dist;
deep.offset_dist = offset_dist;
deep.slope = slope;
deep.offset = offset;
deep.slope_bin_gaussian_model = hist2gaussian_model(slope_dist);
deep.offset_bin_gaussian_model = hist2gaussian_model(offset_dist);
deep.left_cnn = l;
deep.right_cnn = r;