function model = hist2gaussian_model(bins)

rng(1)

bins_norm = [0; bins];
bins_norm = bins_norm / sum(bins_norm);
cdf = cumsum(bins_norm);

Nsamples = 5000;
[~, samples] = histc(rand(Nsamples,1), cdf);

model = fitdist(samples, 'Normal');

model = truncate(model, 1, numel(bins)); % truncate the model

% %
% % visualize
% %
% figure(112);clf
% bar(bins_norm)
% hold on
% plot(pdf(model,1:numel(bins)), 'r')
% axis tight