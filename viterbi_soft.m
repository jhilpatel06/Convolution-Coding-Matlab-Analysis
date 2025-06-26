function decoded_bits = viterbi_soft(received_symbols, trellis)
% SOFT DECISION VITERBI DECODER (Unquantized)
% Inputs:
%   received_symbols - soft symbols from channel (real values)
%   trellis - MATLAB trellis structure
% Output:
%   decoded_bits - decoded information bits

% Initialize parameters
num_states = trellis.numStates;
num_input_symbols = trellis.numInputSymbols;
num_output_bits = log2(trellis.numOutputSymbols);

% Calculate number of decoding stages
L = length(received_symbols) / num_output_bits;

% Initialize path metrics and survivor memory
path_metric = inf(num_states, L + 1);
path_metric(1, 1) = 0; % Start from state 0
survivor = zeros(num_states, L);
input_record = zeros(num_states, L);

% Viterbi algorithm - forward pass
for t = 1:L
    % Extract received symbols for this time step
    rx = received_symbols((t-1)*num_output_bits + 1 : t*num_output_bits);

    for prev_state = 0:num_states-1
        if path_metric(prev_state+1, t) == inf
            continue; % Skip if previous state is unreachable
        end

        for input = 0:num_input_symbols-1
            % Get next state and output
            next_state = trellis.nextStates(prev_state+1, input+1);
            output_bits = int_to_bits(trellis.outputs(prev_state+1, input+1), num_output_bits);

            % Calculate Euclidean distance metric
            expected_symbols = 1 - 2 * output_bits;% BPSK mapping (0→+1, 1→-1)
            metric = -sum(rx .* expected_symbols); % Correlation metric (better for soft decoding)
            new_metric = path_metric(prev_state+1, t) + metric;

            % Update if we found a better path
            if new_metric < path_metric(next_state+1, t+1)
                path_metric(next_state+1, t+1) = new_metric;
                survivor(next_state+1, t) = prev_state;
                input_record(next_state+1, t) = input;
            end
        end
    end
end

% Traceback - backward pass
decoded_bits = zeros(1, L); % For rate 1/n codes
[~, state] = min(path_metric(:, end));

for t = L:-1:1
    input = input_record(state, t);
    decoded_bits(t) = input;
    state = survivor(state, t) + 1; % MATLAB uses 1-based indexing
end
    function bits = int_to_bits(val, bit_len)
        % Convert integer to binary representation (LSB first)
        bits = zeros(1, bit_len);
        for i = 1:bit_len
            bits(i) = mod(floor(val / (2^(bit_len-i))), 2);
        end
    end
end