function geometry_img = homo2img(geometry_homo, xres, yres, focal, isline)

if nargin == 5 && ~isline  %% if input_homo is point in image frame
  p = geometry_homo;
  geometry_img = bsxfun(@rdivide, p(1:2, :), p(3,:))';
  geometry_img = bsxfun(@plus, (geometry_img * focal), [xres, yres]/2);
else
  h = geometry_homo;
  
  pl = (0 - xres/2) / focal;
  pr = (xres - xres/2) / focal;
  ly = (yres/2 -((h(1,:)*pl + h(3,:))./h(2,:)) * focal)';
  ry = (yres/2 -((h(1,:)*pr + h(3,:))./h(2,:)) * focal)';
  
  geometry_img = [zeros(size(ly)), ly, xres*ones(size(ry)), ry];
  geometry_img = line_to_segment(geometry_img);
end