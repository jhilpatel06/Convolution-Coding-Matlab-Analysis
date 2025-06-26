% Parameters
num_trials = 5000;                      % Monte Carlo trials
num_bits = 1000;                      % Bits per trial
EbN0_dB_range = 0:0.5:10;              % Range of Eb/N0 values (dB)
%% 0. Generate random input
input_bits = randi([0, 1], 1, num_bits);
% Define configurations
configs = {'1_2', 3;  '1_3', 4; '1_3', 6};  % Rate and constraint length

% Initialize results storage
results = struct();
for i = 1:size(configs, 1)
    r = configs{i,1};
    Kc = configs{i,2};
    config_name = sprintf('r_%s_Kc_%d', r, Kc);
    results.(config_name).EbN0_dB = EbN0_dB_range;
    results.(config_name).SNR_dB = zeros(size(EbN0_dB_range));
    results.(config_name).BER_hard = zeros(size(EbN0_dB_range));
    results.(config_name).BER_soft = zeros(size(EbN0_dB_range));
end

% Main Monte Carlo simulation loop
for i = 1:size(configs, 1)
    r = configs{i,1};
    Kc = configs{i,2};
    config_name = sprintf('r_%s_Kc_%d', r, Kc);
    fprintf('\n==============================\n');
    fprintf('Configuration: r = %s, Kc = %d\n', strrep(r, '_', '/'), Kc);
    fprintf('==============================\n');

    for j = 1:length(EbN0_dB_range)
        EbN0_dB = EbN0_dB_range(j);
        r_num = str2num(strrep(r, '_', '/'));  % Convert '1_2' -> 1/2
        EsN0_dB = EbN0_dB + 10*log10(r_num);
        results.(config_name).SNR_dB(j) = EsN0_dB;

        total_errors_hard = 0;
        total_errors_soft = 0;
        total_bits = 0;

        for trial = 1:num_trials
            
            %% 1. Convolutional Encoding
            [encoded_bits, Trellis] = conv_encoder(input_bits, strrep(r, '_', '/'), Kc);

            %% 2. BPSK Modulation
            bpsk_symbols = bpsk_modulator(encoded_bits);

            %% 3. AWGN Channel
            received_soft = awgn_channel(bpsk_symbols, EbN0_dB, r_num);

            %% 4. Hard Decision Decoding
            hard_received = received_soft < 0;
            decoded_hard = viterbi_hard(hard_received, Trellis);
            decoded_hard = decoded_hard(1:length(input_bits));

            %% 5. Soft Decision Decoding
            decoded_soft = viterbi_soft(received_soft, Trellis);
            decoded_soft = decoded_soft(1:length(input_bits));

            %% 6. Count Errors
            total_errors_hard = total_errors_hard + sum(decoded_hard ~= input_bits);
            total_errors_soft = total_errors_soft + sum(decoded_soft ~= input_bits);
            total_bits = total_bits + length(input_bits);
        end

        %% Average BER over all trials
        results.(config_name).BER_hard(j) = total_errors_hard / total_bits;
        results.(config_name).BER_soft(j) = total_errors_soft / total_bits;

        fprintf('Eb/N0 = %.1f dB | Hard BER: %.3e | Soft BER: %.3e\n', EbN0_dB, ...
            results.(config_name).BER_hard(j), results.(config_name).BER_soft(j));
    end
end




%% Plot Results

colors = ['b', 'r', 'g', 'k'];
markers = ['o', 's', 'd', '^'];

% Optional: Plot BER vs. Eb/N0 Hard decoding
figure;
hold on;
grid on;
for i = 1:size(configs, 1)
    r = configs{i,1};
    Kc = configs{i,2};
    config_name = sprintf('r_%s_Kc_%d', r, Kc);
    semilogy(results.(config_name).EbN0_dB, results.(config_name).BER_hard, [colors(i) markers(i) '-'], 'LineWidth', 1.5, 'DisplayName', sprintf('r=%s, Kc=%d ', strrep(r, '_', '/'), Kc));
end
xlabel('Eb/N0 (dB)');
ylabel('Bit Error Rate (BER)');
title('BER vs. Eb/N0 for Hard decoding');
legend('show');
set(gca, 'YScale', 'log');

% Plot BER vs. Eb/N0 Soft decoding
figure;
hold on;
grid on;
for i = 1:size(configs, 1)
    r = configs{i,1};
    Kc = configs{i,2};
    config_name = sprintf('r_%s_Kc_%d', r, Kc);
    semilogy(results.(config_name).EbN0_dB, results.(config_name).BER_soft, [colors(i) markers(i) '-'], 'LineWidth', 1.5, 'DisplayName', sprintf('r=%s, Kc=%d ', strrep(r, '_', '/'), Kc));
end
xlabel('Eb/N0 (dB)');
ylabel('Bit Error Rate (BER)');
title('BER vs. Eb/N0 for Soft decoding');
legend('show');
set(gca, 'YScale', 'log');

%% Performance Validation 
% =============================================
% Theoretical BER Calculation
% =============================================
EbN0_theoretical = 0:0.1:10;
BER_uncoded = 0.5 * erfc(sqrt(10.^(EbN0_theoretical/10)));

% =============================================
% Prepare Simulation Results for Comparison
% =============================================
% Extract results from your simulation
config_names = fieldnames(results);
BER_hard_sim = zeros(length(config_names), length(EbN0_dB_range));
BER_soft_sim = zeros(length(config_names), length(EbN0_dB_range));

for i = 1:length(config_names)
    BER_hard_sim(i,:) = results.(config_names{i}).BER_hard;
    BER_soft_sim(i,:) = results.(config_names{i}).BER_soft;
end

% =============================================
% Plot Theoretical vs. Simulated
% =============================================
figure;
semilogy(EbN0_theoretical, BER_uncoded, 'k--', 'LineWidth', 2); hold on;

colors = ['b', 'r', 'g'];
markers = ['o', 's', 'd'];

for i = 1:length(config_names)
    r = configs{i,1};
    Kc = configs{i,2};
    semilogy(EbN0_dB_range, BER_hard_sim(i,:),[colors(i) markers(i),'-'], 'LineWidth', 1.5,'MarkerFaceColor', colors(i),'DisplayName', sprintf('%s, Kc=%d (Sim)', strrep(r, '_', '/'), Kc));
    semilogy(EbN0_dB_range, BER_soft_sim(i,:),[colors(i) markers(i),'--'], 'LineWidth', 1.5, 'MarkerFaceColor', colors(i),'DisplayName', sprintf('%s, Kc=%d (Sim)', strrep(r, '_', '/'), Kc));
end

xlabel('E_b/N_0 (dB)');
ylabel('Bit Error Rate (BER)');
grid on;
title('Theoretical vs. Simulated BER (Hard Decision)');
legend('Uncoded BPSK', '1/2, Kc=3 (Hard)', '1/2, Kc=3 (Soft)','1/3, Kc=4 (Hard)', '1/3, Kc=4 (Soft)','1/3, Kc=6 (Hard)', '1/3, Kc=6 (Soft)', 'Location', 'northeast');
set(gca, 'YScale', 'log');
ylim([1e-6, 1]);

