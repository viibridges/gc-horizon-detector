function model = hist2gaussian_model(bins)

rng(1)

bins_norm = [0; bins];
bins_norm = bins_norm / sum(bins_norm);
cdf = cumsum(bins_norm);

Nsamples = 5000;
[~, samples] = histc(rand(Nsamples,1), cdf);

model = fitdist(samples, 'Normal');
model = truncate(model, 1, numel(bins)); % truncate the model

% if we get a dirac distribution, degrade it to a discrete distribution
if model.sigma == 0
  model = makedist('Binomial','N',1,'p',1);
end

% %
% % visualize
% %
% figure(112);clf
% bar(bins_norm)
% hold on
% plot(pdf(model,1:numel(bins)), 'r')
% axis tight