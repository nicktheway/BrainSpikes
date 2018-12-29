%% Read the new data
% Number of cases
N = 4;
% Number of points
M = 1440000;

% Vars for storing the data.
spike_data = zeros(N, M);
spike_class = cell(N, 1);
spike_times = cell(N, 1);

for i = 1:N
    filename = sprintf("Data_Eval_E_%d.mat", i);
    load(filename);
    if length(data) ~= M
        disp("Data sizes not consistent. Check the M value");
        break;
    end
    spike_data(i, :) = data;
    spike_class{i} = spikeClass;
    spike_times{i} = spikeTimes;
    clear data spikeClass spikeTimes;
end

%% Noise standard deviation estimation
sigma = median(abs(spike_data), 2) ./ 0.6745;

%% Evaluate new data
k_predicted = zeros(N,1);
for i=1:N
   k_predicted(i) = feval(k_model, sigma(i)); 
end

%% Find spikes
spikeNumEst = zeros(N,1);
spikeTimesEst = cell(N, 1);
spikeHeigh = cell(N, 1);
for i = 1:N
    [peaks, locs] = findpeaks(spike_data(i,:)); %, 'MinPeakDistance', 64);
    threshold = k_predicted(i) * sigma(i);
    valid_locs = peaks > threshold;
    spikeHeigh{i} = peaks(valid_locs);
    spikeTimesEst{i} = locs(valid_locs);
    spikeNumEst(i) = size(spikeHeigh{i}, 2);
end

clear valid_locs threshold


%% Plot spikes
j = 1;
spikeEst = cell(N, 1);
figure('Name', "Sorted peaks")
for j=1:N
    subplot(2,2,j)
    spikeEst{j} = zeros(spikeNumEst(j), 65);
    for i=1:spikeNumEst(j)
        search_range = spikeTimesEst{j}(i) - 30: spikeTimesEst{j}(i) + 30;
        [~, min_idx] = min(spike_data(j, search_range));
        [~, max_idx] = max(spike_data(j, search_range));
        %center = min(min_idx + spikeTimesEst{j}(i)-30, spikeTimesEst{j}(i));
        center = min(min_idx, max_idx) + spikeTimesEst{j}(i) - 30;
        spikeEst{j}(i,:) = spike_data(j, center-20:center+44);
    end
    plot(spikeEst{j}')
    title(sprintf("Data Eval %d", j))
    xlim([0 65])
end
%{
%% Useful characteristics
spike_cycles = zeros(4,1);
for i=1:N
    spike_cycles(i) = mean(diff(spike_cl{i}));
end

%}
