function vpgroupIds = filter_orthogonal_LS(lines_homo, infiniteVP_homo, vpgroupIds, opt)

ortho_thres = sind(opt.horLineNoiseThresAngle);

lhomo = lines_homo(:,vpgroupIds);
cos_val = abs(lhomo'*infiniteVP_homo);

inlierId = cos_val > ortho_thres;
vpgroupIds = vpgroupIds(inlierId);

% figure(34);clf
% zs = zeros(1,size(lines_homo,2));
% plot3(zs, zs, zs, lines_homo(1,:), lines_homo(2,:), lines_homo(3,:), 'b.')
% hold on
% zs = zeros(1,numel(vpgroupIds));
% idx = vpgroupIds;
% plot3(zs, zs, zs, lines_homo(1,idx), lines_homo(2,idx), lines_homo(3,idx), 'm.')
% view([0 1 0])
% pause