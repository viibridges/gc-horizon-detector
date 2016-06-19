function segments = line_to_segment(lines)
% generate segments for plotting out of lines
% lines: [x1, y1, x2, y2]
% segments: [x11, y11; x12, y12; nan, nan; ...]

segments = nan(size(lines,1)*3, 2);
segments(1:3:end,:) = lines(:,[1,2]);
segments(2:3:end,:) = lines(:,[3,4]);