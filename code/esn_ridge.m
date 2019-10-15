function [Y,r] = esn_ridge(X,target, lambda)
% input value X: Sufficient iterations of the echo-state network x_i(t)
% input value target: A function we want to approximate using X.
%                   : must be of same dimension as u(t)
output = ridge(target, X', lambda, 0); % pseudoinverse
approx = output(1) + X'*output(2:end);
Y = output;
r = corr(target, approx);
end