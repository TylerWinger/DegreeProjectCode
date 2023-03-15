clc; clear;

%all the deimal numbers need to be converted to binary to compare to galois
%field vectors

%syndromes are outputed in reverse order compared to modelsim

m = 4;
n = 15;
k = 9;

msg = gf([0,0,0,0,0,0,0,14,0],m); %alpha 11 in decimal

genpoly = rsgenpoly(15,9);

encoded = rsenc(msg,n,k,genpoly);

fprintf('\n**************Encoded Message**************\n');
for i = 1:n
    j = 15-i;
    fprintf('X^%d: %4s \n',j,dec2bin(encoded.x(i),4));
end
fprintf('\n');
fprintf('Encoded Message = %d\n',encoded.x);

errors = gf([0 0 0 0 0 3 1 0 0 0 0 0 9 0 0],m);

noisycode = encoded + errors;
fprintf('\n');
fprintf('Noisy Message = %d\n',noisycode.x);

fprintf('\n**************Decoded Message**************\n')
rsDecoder(noisycode, m, 19, n, k) %genpoly is 19 in decimal
