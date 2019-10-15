function [X, neuron_data] = esn_evaluate(u, parameters)
% input value W: matrix that updates the hidden state
% input value V: matrix that weighs the forcing time series
% input value b: bias vector
% input value u: the "forcing" time series. MUST BE A COLUMN VECTOR AND
% MUST BE 1 LONGER THAN THE AMOUNT OF ITERATIONS
% input value x: the initial condition. MUST BE A COLUMN VECTOR
% input value i: number of iterations
% input value c: spectral radius
X = zeros(length(parameters.W),length(u)-1); % hidden state
X(:,1) = parameters.ic; % set initial condition
% This function simulates the echo-state network
neuron_data = [];
for j = 2:length(u)
    d = parameters.W*X(:,j-1); % d is the vector that results from updating the hidden state
    e = parameters.V*u(j); % e is the vector that applies the V matrix to the time series
    val = parameters.spectralRadius*d + e + parameters.b;
    X(:,j) = (1-parameters.leak)*X(:,j-1) + ...
        parameters.leak*parameters.function(val);
    neuron_data = [neuron_data; val];
end
X = [X;ones(1,length(X(1,:)))]; % add extra row of ones
X = X(:,ceil(parameters.transientCutoff*length(X)):end);



    
