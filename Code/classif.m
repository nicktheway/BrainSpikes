%% spike classification
maxA = cell(N, 1);
zc = cell(N, 1);
maxPos = cell(N, 1);
means = cell(N, 1);
energy = cell(N, 1);
cycles = cell(N, 1);
for j = 1:N
    maxA{j} = zeros(spikeNumEst(j), 1);
    zc{j} = zeros(spikeNumEst(j), 1);
    maxPos{j} = zeros(spikeNumEst(j), 1);
    means{j} = zeros(spikeNumEst(j), 1);
    energy{j} = zeros(spikeNumEst(j), 1);
    cycles{j} = zeros(spikeNumEst(j), 1);
    for i = 1:spikeNumEst(j)
        spike = spikeEst{j}(i, :);
        maxA{j}(i) = max(spike)-min(spike);
        [~, maxPos{j}(i)] = max(spike);
        zc{j}(i) = sum(spike(1:end-1) <= 0 & spike(2:end) > 0) + sum(spike(1:end-1) > 0 & spike(2:end) > 0);
        means{j}(i) = mean(spike);
        F = fft(spike);
        energy{j}(i) = sum(F.*conj(F));
        cycles{j}(i) = mean(diff(spike));
    end
end

clear spike

%% Extract characteristics
Data = cell(N, 1);
group = cell(N, 1);
for j = 1:N
    valid_idx = spike_pairs{j} ~= 0;
    found = spike_pairs{j}(valid_idx);
    Data{j}(:,1) = zc{j}(valid_idx);
    Data{j}(:,2) = maxA{j}(valid_idx);
    Data{j}(:,3) = means{j}(valid_idx);
    Data{j}(:,4) = maxPos{j}(valid_idx);
    Data{j}(:,5) = energy{j}(valid_idx);
    Data{j}(:,6) = cycles{j}(valid_idx);
    % Normalize
    Data{j} = Data{j} ./ max(Data{j});
    group{j}(:,1) = spike_class{j}(found);
end

%% Scatter plot
figure('Name', 'Scatter plots')
for j = 1:N
    subplot(2,2, j)
    gscatter(Data{j}(:,2), Data{j}(:,5), group{j})
    title(sprintf("Data Eval %d", j));
    xlabel("Max peak2peak")
    ylabel("Energy")
end

%% Classification
pcs = zeros(4, 1);
for i=1:N
    pcs(i) = MyClassify(Data{i}(:, [1,2,3,5,6]), group{i});
end
%{
%% Useful characteristics
spike_cycles = zeros(4,1);
for i=1:N
    spike_cycles(i) = mean(diff(spike_cl{i}));
end

%}