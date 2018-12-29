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
peak_num = zeros(N,1);
for i = 1:N
    peak_num(i) = sum(findpeaks(spike_data(i,:)) > k_predicted(i)*sigma(i));
end