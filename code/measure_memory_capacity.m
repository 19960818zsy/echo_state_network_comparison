function memory_capacity = measure_memory_capacity(parameters)
len = parameters.sampleLength;
data_sample = randn(6*len,1);
u_input = [data_sample(len+1:2*len);data_sample(3*len+1:4*len);data_sample(5*len+1:6*len)];
tau_range = 1:parameters.sampleLength;
performances = [];
% % REMOVE IF USING THIS FUNCTION INDEPENDENTLY OF ESN_ANALYSIS
% if parameters.kappa == -1
%     [parameters.W, parameters.V, parameters.b] = esn_setup(...
%         length(u_input(1)), ...
%         parameters.neurons, ....
%         parameters.sparsity ...
%         ); % setting up W, V and b 
% else
%     parameters.W = esn_setup_oscillators(parameters.neurons, ...
%                                          parameters.kappa, ...
%                                          parameters.alpha);
%     [~, parameters.V, parameters.b] = esn_setup( ...
%         length(u_input(1)), ...
%         parameters.neurons, ...
%         parameters.sparsity ...
%         ); % setting up W, V and b for an echo state network
% end
% %
usual_performance_measure = parameters.performanceMeasure;
parameters.performanceMeasure = @(x,y)(corr(x,y));
for tau = tau_range
    z_target = [data_sample(len+1 - tau:2*len - tau); ...
                data_sample(3*len+1 - tau:4*len - tau); ...
                data_sample(5*len+1 - tau:6*len - tau)];
    performance = test_esn(u_input, z_target, parameters);
    if performance <= 0
        break;
    end
    performances = [performances performance];
end
taus = 1:1:length(performances);
memory_capacity = trapz((performances.^2).*taus);
parameters.performanceMeasure = usual_performance_measure;
end



