function [segments, lines] = edges_from_file(edgeFile)
% segments: [x1, y1; x2, y2; nan, nan]; % plot(segments(:,1), segments(:,2))
% lines: [x1, y1, x2, y2] % for processing
% labels: cluster label (if any)

data = load(edgeFile);

lines = nan(size(data, 1), 4);
lines(:,1:2) = data(:,[1,2]);
lines(:,3:4) = data(:,[3,4]);

%% reorder endpoints to [leftpt, rightpt]
swapIds = lines(:,1) > lines(:,3);
temp = lines(swapIds,1:2);
lines(swapIds,1:2) = lines(swapIds,3:4);
lines(swapIds,3:4) = temp;

segments = line_to_segment(lines);