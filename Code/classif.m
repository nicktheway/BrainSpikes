%% spike classification
maxA = cell(N, 1);
zc = cell(N, 1);
for j = 1:N
    maxA{j} = zeros(spikeNumEst(j), 1);
    zc{j} = zeros(spikeNumEst(j), 1);
    for i = 1:spikeNumEst(j)
        spike = spikeEst{j}(i, :);
        maxA{j}(i) = max(spike)-min(spike);
        zc{j}(i) = sum(spike(1:end-1) <= 0 & spike(2:end) > 0) + sum(spike(1:end-1) > 0 & spike(2:end) > 0);
    end
end

clear spike

%% Scatter plot
figure('Name', 'Scatter plots')
characteristics = cell(N, 1);
for j = 1:N
    subplot(2,2, j)
    valid_idx = spike_pairs{j} ~= 0;
    found = spike_pairs{j}(valid_idx);
    characteristics{j}(:,1) = zc{j}(valid_idx);
    characteristics{j}(:,2) = maxA{j}(valid_idx);
    characteristics{j}(:,3) = spike_class{j}(found);
    gscatter(zc{j}(valid_idx), maxA{j}(valid_idx), spike_class{j}(found))
end

%% Classification
pc1 = MyClassify(characteristics{1}(:, 1:2), characteristics{1}(:, 3));
%{
%% Useful characteristics
spike_cycles = zeros(4,1);
for i=1:N
    spike_cycles(i) = mean(diff(spike_cl{i}));
end

%}