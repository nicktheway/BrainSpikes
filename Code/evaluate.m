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
spike_num = zeros(N,1);
spike_locs = cell(N, 1);
spike_cl = cell(N, 1);
for i = 1:N
    [peaks, locs] = findpeaks(spike_data(i,:));
    threshold = k_predicted(i) * sigma(i);
    
    spike_locs{i} = locs(peaks > threshold);
    valid_locs = spike_locs{i}-[0 spike_locs{i}(1:end-1)] > 63;
    spike_cl{i} = peaks(valid_locs);
    spike_locs{i} = spike_locs{i}(valid_locs);
    spike_num(i) = size(spike_cl{i}, 2);
end

clear valid_locs threshold