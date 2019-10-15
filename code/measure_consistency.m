function consistency = measure_consistency(u, parameters)
% input value X: an echo-state network
parameters.ic = 2*rand(length(parameters.W),1) - 1;
X_0 = esn_evaluate(u, parameters);
parameters.ic = 2*rand(length(parameters.W),1) - 1;
X_1 = esn_evaluate(u, parameters);
corrs = zeros(length(X_0(:,1)),1);
for k = 1:length(corrs)-1
    corrs(k) = corr(X_0(k,:)', X_1(k,:)');
    if isnan(corrs(k))
        corrs(k) = 1;
    end
end
corrs(end) = 1; 
consistency = mean(corrs);
end
