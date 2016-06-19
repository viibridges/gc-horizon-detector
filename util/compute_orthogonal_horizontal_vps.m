function [sc, horvps_homo, horgroups] = compute_orthogonal_horizontal_vps(lines_homo, initialIds, horizon_homo, opt)

Nvps = opt.maxVPs;
distThr = opt.distThr;

Npicks = numel(initialIds);

% compute the intersection homo
inter_homo = bsxfun(@cross, lines_homo(:,initialIds), horizon_homo);
inter_homo = normalize_point_homo(inter_homo);

% sort inter_homo by it's location in image (indespensable for subset search)
inter_pts = bsxfun(@rdivide, inter_homo(1:2,:), inter_homo(3,:));
[~, sort_inds] = sort(inter_pts(1,:));
inter_homo = inter_homo(:, sort_inds);

%
% compute scores
%
[scores, horgroups] = vp_score(inter_homo, lines_homo, opt.score_function);


%
% subset search
%
% eliminate close intersections while guarantee the maximum number of LSs
% in total, sounds like a NP-Hard, try the naive method
dist_mat = abs(inter_homo'*inter_homo);
tooclose = (dist_mat > distThr) - eye(Npicks);
survivorIds = subset_search(scores, tooclose, opt.subset_method);

% survivor of the best
horvps_homo = inter_homo(:,survivorIds);

%
% refinement and rescore
%
if opt.horvp_refinement
  horvps_homo = vp_refinement(lines_homo, horvps_homo, horizon_homo, opt);
  [scores, horgroups] = vp_score(horvps_homo, lines_homo, opt.score_function);
else
  horgroups = horgroups(survivorIds);
  scores = scores(survivorIds);
end


% sorted by score
[scores, sortIds] = sort(scores, 'descend');
horvps_homo = horvps_homo(:,sortIds);
horgroups = horgroups(sortIds);

%
% score horizon
%
% only the top two (or one) horizontal VPs are used for computing horizon line score
Nvps = min(numel(horgroups), Nvps);
sc = sum(scores(1:Nvps));


function [score, horgroup] = vp_score(vp_homo, lines_homo, score_function)

cos_mat = vp_homo'*lines_homo;
theta_mat = abs(asind(cos_mat));
score_mat = score_function(theta_mat);

tmp = mat2cell(score_mat, ones(size(score_mat,1),1), size(score_mat,2));
horgroup = cellfun(@find, tmp, 'uniformoutput', false);
score = cellfun(@sum, tmp);


function survivorIds = subset_search(scores, tooclose, method)

switch method
  
  case 'independent_set'
    ok_neighbors = ~(tooclose | eye(size(tooclose)));
    survivorIds = max_weighted_independent_set(scores, ok_neighbors);
    
  case 'greedy_search'
    survivorIds = true(numel(scores),1);
    while any(tooclose(:))
      [I, J] = find(tooclose);
      Ni = scores(I(1));
      Nj = scores(J(1));
      if Ni > Nj
        survivorIds(J(1)) = false;
      else
        survivorIds(I(1)) = false;
      end
      tooclose(I(1), J(1)) = false;
      tooclose(J(1), I(1)) = false;
    end
    
  case 'top_two'
    [I, J] = find(triu(~tooclose,1));
    if ~isempty(I)
      [~, maxIds] = max(sum(scores([I,J])'));
      survivorIds = [I(maxIds), J(maxIds)];
    else
      [~, survivorIds] = max(scores);
    end
        
  otherwise
    disp('wrong subset method')
    
end