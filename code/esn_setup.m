function [W, V, b] = esn_setup(l,n,sparsity)
% input value l: length of time series
% input value n: the number of neurons in the network
W = sprand(n,n,sparsity);% matrix that updates the hidden state. matrix is sparse with density 0.1
if max(eigs(W)) ~= 0
    W = W / max(eigs(W));
end
V = randn(n,l); % matrix that weights the forcing time series. sparsity same as W
b = randn(n,1); % bias vector