function config = horizon_setup()

config = struct();

% parameterization settings
tmp = load('assets/caffe_dh/cdf/bins.mat');
config.num_bins = tmp.num_bins;
config.slope_bin_edges = tmp.slope_bin_edges;
config.offset_bin_edges = tmp.offset_bin_edges;

config.mean_pixel = [104 117 123];
config.caffe_sz = [224 224];