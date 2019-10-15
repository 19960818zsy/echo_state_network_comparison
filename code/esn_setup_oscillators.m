function W = esn_setup_oscillators(n,kappa, alpha)
% input value n: the number of neurons in the network
% input value kappa: coupling strength
% input value alpha: between 0 and 1
W = zeros(n,n);
for i = 1:n
    for j = 1:n
        if i ~= j
            W(i,j) = kappa*(alpha^mod((j-i) - 1,n));
        end
        
    end
end