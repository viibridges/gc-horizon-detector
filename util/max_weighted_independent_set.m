function [set_opt, score_opt] = max_weighted_independent_set(scores, ok_neighbors)
N = size(ok_neighbors,1);

all_inds = 1:N;

sets = cell(1,N);
set_scores = nan(1,N);

% we don't need to try all nodes, instead we pick the node with the fewest
% exclusive neighbors and try all of its neighbors... one of them has to be
% in the final set

[~, ind] = max(sum(ok_neighbors));
must_try = find(~ok_neighbors(ind,:));

% for ix = 1:N
for ix = must_try

  % assume that ix will be in the final set, optimize for the rest

  % rotate it so that ix is first
  shift = circshift(all_inds, [0 1-ix]);
  tmp_inds = all_inds(shift);
  tmp_scores = scores(shift);
  tmp_ok_neighbors = ok_neighbors(shift,shift);
  
  % only keep nodes that can be in the set with ix
  tmp_ok = tmp_ok_neighbors(tmp_inds == ix,:) | tmp_inds == ix;
  tmp_inds = tmp_inds(tmp_ok);
  tmp_scores = tmp_scores(tmp_ok);
  tmp_ok_neighbors = tmp_ok_neighbors(tmp_ok,tmp_ok);
  
  [tmp_set, set_scores(ix)] = find_subset(tmp_scores, tmp_ok_neighbors);

  % get original indexes
  sets{ix} = tmp_inds(tmp_set);
  
  % comment this out if you want it to run faster
  assert(all(all(eye(numel(sets{ix})) == ~ok_neighbors(sets{ix},sets{ix}))), 'Invalid subset, two nodes that cannot be neighbors were chosen.')

end

[score_opt, ind] = max(set_scores);
set_opt = sets{ind};