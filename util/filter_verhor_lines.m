%
% filter line segments that is not much helpful locating horizontal VPs
%

function helpfulLineIds = filter_verhor_lines(lines_homo, zenith_homo, infiniteVP_homo, opt)

% most vertical lines are nuisances for horizon line detection next, execute them
helpfulLineIds = filter_vertical_LS(lines_homo, zenith_homo, opt);


% further filter LSs that produce infinite VPs
helpfulLineIds = filter_orthogonal_LS(lines_homo, infiniteVP_homo, helpfulLineIds, opt);