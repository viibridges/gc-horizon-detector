function caffe_input = preprocess_image(im, caffe_sz, mean_pixel)

caffe_input = im(:, :, [3, 2, 1]); % make bgr
caffe_input = permute(caffe_input, [2, 1, 3]); % make width the fastest dimension
caffe_input = single(caffe_input); % convert from uint8 to single
caffe_input = imresize(caffe_input, caffe_sz, 'bilinear');
caffe_input = bsxfun(@minus, caffe_input, reshape(mean_pixel, [1 1 3])); % subtract mean