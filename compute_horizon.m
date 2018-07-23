function compute_horizon(imageList, out_dir, opt)
%
% imagesList: cell array storing image pathes
% out_dir: output directory
% opt: option for horizon line detector.
%

% output directory
if ~exist(out_dir, 'dir'); mkdir(out_dir); end

N = numel(imageList);


%% set up parameters

LSD_BIN_ = 'assets/lsd/lsd';

disp('loading network...')
caffe.reset_all();
caffe.set_mode_cpu();
net = caffe.Net('assets/caffe_dh/deploy.net', 'assets/caffe_dh/googlenet_places.caffemodel', 'test');

for ix = 1:N 
  %
  % extract line segments
  %
  im = imread(imageList{ix});
  [seglines, temp_dir] =  extract_linesegment(im, LSD_BIN_);
  fprintf('extracting LS: %d / %d\n', ix, N);

  %
  % extract context with CNN
  %
  deep = extract_context_with_cnn(im, net);
  fprintf('extracting context: %d / %d\n', ix, N);
  
  % detect horizon line
  xres = size(im, 2);
  yres = size(im, 1);
  focal = max(xres, yres) / 2; % fake focal length
  [horizon_homo, stat] = horizon_detector(seglines, xres, yres, focal, deep, opt);
  
  hor = homo2img(horizon_homo, xres, yres, focal);
  left = hor(1,:); right = hor(2,:);
  
  prediction.name = imageList{ix};
  prediction.im_sz = [yres, xres];
  prediction.left = left;
  prediction.right = right;
  prediction.left_cnn = deep.left_cnn;
  prediction.right_cnn = deep.right_cnn;
  prediction.deep = deep;
  prediction.stat = stat;
  
  fprintf('detecting horizon: %d / %d\n', ix, N);
  
  %
  % save the predictions
  %
  save_path = sprintf('%s/%04d.mat', out_dir, ix);
  save(save_path, 'prediction')
  
end


%% clean up
if exist(temp_dir, 'dir')
  system(['rm -r ' temp_dir]);
end
