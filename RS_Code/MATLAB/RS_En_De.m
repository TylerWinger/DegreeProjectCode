clc;clear;

m = 4;
n = 15;
k = 9;

msg = gf([0,0,0,0,0,0,0,14,0],m); %alpha 11 in decimal

genpoly = rsgenpoly(15,9);

code = rsenc(msg,n,k,genpoly);

for i = 1:n
    j = 15-i;
    fprintf('X^%d: %4s \n',j,dec2bin(code.x(i),4));
end

errors = gf([0 0 0 0 0 0 2 0 0 15 0 0 0 0 0],m);
noisycode = code + errors;

[rxcode,numCorrectedErrors] = rsdec(noisycode,n,k)