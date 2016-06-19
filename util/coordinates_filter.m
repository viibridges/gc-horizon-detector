function points_or_lines_new = coordinates_filter(points_or_lines, xres, yres, focal)

center = [xres, yres] / 2;

if size(points_or_lines, 2) == 2
  points_or_lines_new = bsxfun(@minus, points_or_lines, center) / focal;
else
  points_or_lines_new = bsxfun(@minus, points_or_lines, [center, center]) / focal;
end