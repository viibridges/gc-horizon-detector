function [ortho_horlines_homo, infiniteVP_homo] = sample_orthogonal_horlines_uniform(zenith_homo, xres, yres, focal, opt)

zenith_img = homo2img(zenith_homo, xres, yres, focal, false);
zenith = zenith_img - [xres yres] / 2;

% the horizon line (h_i) orthogonal to the up direction (line of pp and zenith
% VP) takes the form: y = tan(tilt)*x + offset_i

tan_tilt = -tan((zenith(1)-opt.pp(1)) / (zenith(2)-opt.pp(2)));
offset_i = random_interval(opt.horRange(1)*yres, opt.horRange(2)*yres, [1, opt.NhorizonCandidates]);
offset_i = sort(offset_i);

% left and right height
Xs = repmat([0 xres], numel(offset_i), 1);
Ys = tan_tilt * Xs + [offset_i(:) offset_i(:)];

ortho_horlines_homo = img2homo([Xs(:,1) Ys(:,1) Xs(:,2) Ys(:,2)], xres, yres, focal);

infiniteVP_homo = lines_normal(ortho_horlines_homo);


function val = random_interval(low, high, sz)

assert(low <= high)

val = (high-low).*rand(sz) + min(low);