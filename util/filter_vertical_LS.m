function vpgroupIds = filter_vertical_LS(lines_homo, zenith_homo, opt)

% vertical_thres = sind(12);
% vpgroupIds = find(lines_homo(2,:) > vertical_thres);

vertical_thres = sind(opt.verLineNoiseThresAngle);

lhomo = lines_homo;
cos_val = abs(lhomo'*zenith_homo);

inlierId = cos_val > vertical_thres;
vpgroupIds = find(inlierId);