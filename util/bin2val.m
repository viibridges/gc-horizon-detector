%
% Convert from bin id to bin center.
%
% Note: the value X(i) is in the kth bin if edges(k) ≤ X(i) < edges(k+1)
%

function val = bin2val(bin_id, bin_edges)

assert(bin_id > 0 && bin_id < numel(bin_edges), 'impossible bin_id') 

% handle infinite bins, choose left/right edge as appropriate
if (bin_id <= 2 && bin_edges(1) == -Inf)
  val = bin_edges(2);
elseif (bin_id >= numel(bin_edges)-1 && bin_edges(end) == Inf)
  val = bin_edges(end-1);
else
  val = interp1(1:numel(bin_edges), bin_edges, bin_id, 'linear'); % allow sub bin res
end
