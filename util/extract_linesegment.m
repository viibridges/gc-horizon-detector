function [seglines, temp_dir] =  extract_linesegment(im, LSD_BIN_)

% temp directory for LS extraction
temp_dir = '/tmp/ls_extraction_temp/';
if exist(temp_dir, 'dir'); system(['rm -r ' temp_dir]); end
mkdir(temp_dir);

% generate random path
SET = char(['a':'z' '0':'9']) ;
ids = ceil(length(SET)*rand(1,20)) ; % with repeat
name = SET(ids) ;

pgm_path = [temp_dir name '.pgm'];
imwrite(im, pgm_path);

segFile = [pgm_path '.txt'];
system(sprintf('%s %s %s', LSD_BIN_, pgm_path, segFile));
[~, seglines] = edges_from_file(segFile);