function [encoded_bits, trellis] = conv_encoder(input_bits, rate_str, constraint_length)
% CONV_ENCODER Convolutional encoder with standard generators
% Inputs:
%   input_bits: Binary input sequence (row vector)
%   rate_str: Code rate as string ('1/2', '1/3', etc.)
%   constraint_length: Constraint length K
% Outputs:
%   encoded_bits: Encoded bit stream
%   trellis: MATLAB trellis structure

% Get generator polynomials for given rate and constraint length
generators = get_standard_generators(rate_str, constraint_length);
num_outputs = length(generators);  % Number of output bits per input bit

% Convert octal generators to binary form
generator_matrix = zeros(num_outputs, constraint_length);
for i = 1:num_outputs
    generator_matrix(i,:) = octal_to_binary(generators(i), constraint_length);
end

% Add tail bits (K-1 zeros to flush the encoder)
padded_input = [input_bits, zeros(1, constraint_length-1)];
encoded_bits = [];
shift_register = zeros(1, constraint_length);

% Encoding process
for i = 1:length(padded_input)
    % Update shift register
    shift_register = [padded_input(i), shift_register(1:end-1)];

    % Calculate output bits
    output_bits = mod(shift_register * generator_matrix', 2);
    encoded_bits = [encoded_bits, output_bits];
end

% Create trellis structure for decoding
trellis = poly2trellis(constraint_length, generators);

% Helper functions
    function bin_vec = octal_to_binary(octal_num, K)
        % Convert octal number to binary vector
        binary_str = dec2bin(base2dec(num2str(octal_num), 8), K);
        bin_vec = double(binary_str) - 48;  % Convert char to numeric
    end
end

function generators = get_standard_generators(rate_str, K)
% GET_STANDARD_GENERATORS Returns generator polynomials for common configurations
switch rate_str
    case '1/2'
        if K == 3
            generators = [5 7];  % Rate 1/2, K=3 (g1=101, g2=111 in binary)
        elseif K == 7
            generators = [171 133];  % Rate 1/2, K=7
        else
            error('Unsupported constraint length for rate 1/2');
        end

    case '1/3'
        if K == 3
            generators = [5 7 7];  % Rate 1/3, K=3
        elseif K == 4
            generators = [13 15 17];  % Rate 1/3, K=4 (g1=1011, g2=1101, g3=1111)
        elseif K == 6
            generators = [65, 57, 71];  % Rate 1/3, K=6
        else
            error('Unsupported constraint length for rate 1/3');
        end

    otherwise
        error('Unsupported code rate');
end
end