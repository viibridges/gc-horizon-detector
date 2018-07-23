%
% predict horizon line given image name list
%

addpath util
addpath /path/to/caffe/matlab  % Change it to your matcaffe path

imgDir = 'assets/imgs/';  % directory of input images
outDir = 'outputs/';      % directory for storing results

imgList = glob([imgDir, '*.jpg']);
nImages = numel(imgList);

% get default configuration
opt = default_option();

compute_horizon(imgList, outDir, opt);


%% visualize results

predFiles = glob([outDir, '*.mat']);

for ix = 1:numel(predFiles)
  
  pred = load(predFiles{ix});
  pred = pred.prediction;
  im = imread(pred.name);
  
  figure(1);clf
  image(im)
  hold on
  plot([pred.left(1) pred.right(1)], [pred.left(2) pred.right(2)], 'r', 'linewidth', 2)
  plot([pred.left_cnn(1) pred.right_cnn(1)], [pred.left_cnn(2) pred.right_cnn(2)], 'b--', 'linewidth', 2)
  hold off
  axis off equal tight
  legend('FINAL Horizon', 'CNN Horizon')
  disp(ix)
  pause(.5)
  
end