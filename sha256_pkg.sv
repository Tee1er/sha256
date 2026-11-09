package sha256_pkg;

// CONSTANTS
localparam [31:0] K [64] = '{
    32'h428a2f98, 32'h71374491, 32'hb5c0fbcf, 32'he9b5dba5,   // K[0..3]
    32'h3956c25b, 32'h59f111f1, 32'h923f82a4, 32'hab1c5ed5,   // K[4..7]
    32'hd807aa98, 32'h12835b01, 32'h243185be, 32'h550c7dc3,   // K[8..11]
    32'h72be5d74, 32'h80deb1fe, 32'h9bdc06a7, 32'hc19bf174,   // K[12..15]
    32'he49b69c1, 32'hefbe4786, 32'h0fc19dc6, 32'h240ca1cc,   // K[16..19]
    32'h2de92c6f, 32'h4a7484aa, 32'h5cb0a9dc, 32'h76f988da,   // K[20..23]
    32'h983e5152, 32'ha831c66d, 32'hb00327c8, 32'hbf597fc7,   // K[24..27]
    32'hc6e00bf3, 32'hd5a79147, 32'h06ca6351, 32'h14292967,   // K[28..31]
    32'h27b70a85, 32'h2e1b2138, 32'h4d2c6dfc, 32'h53380d13,   // K[32..35]
    32'h650a7354, 32'h766a0abb, 32'h81c2c92e, 32'h92722c85,   // K[36..39]
    32'ha2bfe8a1, 32'ha81a664b, 32'hc24b8b70, 32'hc76c51a3,   // K[40..43]
    32'hd192e819, 32'hd6990624, 32'hf40e3585, 32'h106aa070,   // K[44..47]
    32'h19a4c116, 32'h1e376c08, 32'h2748774c, 32'h34b0bcb5,   // K[48..51]
    32'h391c0cb3, 32'h4ed8aa4a, 32'h5b9cca4f, 32'h682e6ff3,   // K[52..55]
    32'h748f82ee, 32'h78a5636f, 32'h84c87814, 32'h8cc70208,   // K[56..59]
    32'h90befffa, 32'ha4506ceb, 32'hbef9a3f7, 32'hc67178f2   // K[60..63]
};

localparam [31:0] H_INIT [8] = '{
    32'h6a09e667, 32'hbb67ae85, 32'h3c6ef372, 32'ha54ff53a,
    32'h510e527f, 32'h9b05688c, 32'h1f83d9ab, 32'h5be0cd19
};

function [31:0] ch(input [31:0] x, input [31:0] y, input [31:0] z);
    ch = (x & y) ^ (~x & z);
endfunction

function [31:0] maj(input [31:0] x, input [31:0] y, input [31:0] z);
    maj = (x & y) ^ (x & z) ^ (y & z);
endfunction

function [31:0] rotr(input [31:0] x, input [4:0] n);
    rotr = (x >> n) | (x << (32 - n));
endfunction

function [31:0] Sigma0(input [31:0] x);
    Sigma0 = rotr(x, 2) ^ rotr(x, 13) ^ rotr(x, 22);
endfunction

function [31:0] Sigma1(input [31:0] x);
    Sigma1 = rotr(x, 6) ^ rotr(x, 11) ^ rotr(x, 25);
endfunction

function [31:0] sigma0(input [31:0] x);
    sigma0 = rotr(x, 7) ^ rotr(x, 18) ^ (x >> 3);
endfunction

function [31:0] sigma1(input [31:0] x);
    sigma1 = rotr(x, 17) ^ rotr(x, 19) ^ (x >> 10);
endfunction

endpackage


