function [set_opt, score_opt] = find_subset(scores, ok_neighbors)

N = numel(scores);

assert(all([N N] == size(ok_neighbors)), 'Neighbor matrix must be N x N')

%
% solve for optimal subset of points
%
sets = cell(1,N); % will hold the optimal subset, up to and including ix
score_subset = zeros(1,N); % the score of the best subset up to ix

% setup the base case
sets{1} = 1;
score_subset(1) = scores(1);

for ix = 2:N
  
  % solve for the first column
  %   score_subset(ix, 1) = max(score(ix) + ok_neighbors(1:ix-1,ix) .* score_subset(1:ix-1,ix));
  
  % could use last_best to speed this up...
  score_prev = score_subset(1:ix-1) + ok_neighbors(ix,1:ix-1)*scores(ix);
  
  % semantics: max( ) picks the first maximum ind... so we can use that one to
  % check if it is far enough away
  [score_tmp, ind] = max(score_prev);
  
  if ok_neighbors(ix,ind)
    % since it is ok to add, add it!
    sets{ix} = [sets{ind} ix];
    score_subset(ix) = score_tmp;
  else
    if score_subset(ind) < scores(ix)
      % none of the previous subsets is better
      sets{ix} = ix;
      score_subset(ix) = scores(ix);
    else
      % the previous one is better, so keep it
      sets{ix} = sets{ind};
      score_subset(ix) = score_tmp;
    end
  end
  
end

[score_opt, ind] = max(score_subset);
set_opt = sets{ind};

