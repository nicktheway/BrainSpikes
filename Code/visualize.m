%% Read the test data
% Number of cases
N = 8;
% Number of points
M = 1440000;
% Vars for storing the data.
spike_data = zeros(N, M);
spike_num = zeros(N, 1);
for i = 1:N
    filename = sprintf("Data_Test_%d.mat", i);
    load(filename);
    if length(data) ~= M
        disp("Data sizes not consistent. Check the M value");
        break;
    end
    spike_data(i, :) = data;
    spike_num(i) = spikeNum;
    clear data spikeNum;
end

%% Display the signals
sample_size = 10000;
figure('Name', "Head of the test signals");
for i = 1:8
    subplot(4,2,i)
    plot(spike_data(i, 1:sample_size))
    title(sprintf("Test Data %d", i))
end

%% Noise standard deviation estimation
sigma = median(abs(spike_data), 2) ./ 0.6745;
%% Find spikes
ks = 2:0.1:5;
k_size = size(ks, 2);
peak_num = zeros(N,k_size);
for i = 1:N
    cnt = 1;
    for k = ks
        peak_num(i,cnt) = sum(findpeaks(spike_data(i,:)) > k*sigma(i));
        cnt = cnt + 1;
    end
end

%% Plot spikes
figure('Name', "Spikes vs k")
for i = 1:8
    subplot(4,2,i);
    hold on;
    plot(ks, peak_num(i, :))
    xlabel('k')
    ylabel('Spike Number');
    title(sprintf("Test Data %d", i))
    plot(ks, spike_num(i) * ones(k_size))
end
   
%% Best ks
k_best = zeros(N, 1);
for i = 1:N
    [~, idx] = min(abs(peak_num(i,:)-spike_num(i)));
    k_best(i) = ks(idx);
end

%% Data for creating models
model_sigmas = sigma;
model_k = k_best;

%% Create model for k
% k_model = kfit(model_sigmas, model_k);
k_model = kfit2(model_sigmas, model_k);

clear sigma k_best

