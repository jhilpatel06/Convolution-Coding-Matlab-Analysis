function received_symbols = awgn_channel(bpsk_symbols, EbN0_dB, rate)
% rate is the code rate (e.g., 1/3)
EbN0 = 10^(EbN0_dB/10);
EsN0 = EbN0 * rate; % Energy per symbol
N0 = 1/EsN0;
sigma_n = sqrt(N0/2);

noise = sigma_n * randn(1, length(bpsk_symbols));
received_symbols = bpsk_symbols + noise;
end
