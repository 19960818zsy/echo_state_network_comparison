function [performance_measure, ...
    consistency, best_lambda, ...
    memory_capacity, ...
    neuron_values] = estimate_performance(u_input, training_target, parameters)
norm_u_input = u_input; % needs to be normalized to avoid saturation
norm_z_target = training_target; % needs to be normalized in order for ridge regression to work
if parameters.kappa == -1
    [parameters.W, parameters.V, parameters.b] = esn_setup(...
        length(norm_u_input(1)), ...
        parameters.neurons, ....
        parameters.sparsity ...
        ); % setting up W, V and b 
else
    parameters.W = esn_setup_oscillators(parameters.neurons, ...
                                         parameters.kappa, ...
                                         parameters.alpha);
    [~, parameters.V, parameters.b] = esn_setup( ...
        length(norm_u_input(1)), ...
        parameters.neurons, ...
        parameters.sparsity ...
        ); % setting up W, V and b for an echo state network
end
% [X, neuron_data] = esn(W, V, b, norm_u_input, x, length(norm_u_input)-1, parameters.spectralRadius, parameters.leak, parameters.function);
consistency = measure_consistency(norm_u_input, parameters);
memory_capacity = -1;
if parameters.perfType == "test"
    if parameters.lambda == -1
        [performance_measure, best_lambda, neuron_values] = test_esn(norm_u_input, norm_z_target, parameters);
    else
        [performance_measure, best_lambda] = test_esn_no_validation(norm_u_input, norm_z_target, parameters);
    end
elseif parameters.perfType == "training"
    [~,performance_measure] = esn_ridge(X, norm_z_target, 0.001);
elseif parameters.perfType == "memory"
    memory_capacity = measure_memory_capacity(parameters);
    performance_measure = -1;
    best_lambda = -1;
    neuron_values = [];
else
    performance_measure = -1;
end
end