function bpsk_symbols = bpsk_modulator(encoded_bits)
% BPSK Modulation according to function given in Appendix A
% s = 1 - 2*b : maps 0 to +1, 1 to -1
bpsk_symbols = 1 - 2 * encoded_bits;
end