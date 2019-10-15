function [u_input, z_target] = generate_test_data(parameters, taskName)
if taskName == "lorenz_reconstruction"
    n = 3*parameters.sampleLength*parameters.networks;
    st = parameters.samplingTime;
    u = normalize_data(lorenz(n, 1, st));
    wn_u = 0.1*randn(n, 1);
    u_input = u(:, 2) + wn_u;
    z = normalize_data(lorenz(n, 3, st));
    wn_z = 0.1*randn(n, 1);
    z_target = z(:, 2) + wn_z;
elseif taskName == "lorenz_prediction"
    window = parameters.predictionWindow;
    n = 3*(parameters.sampleLength + window) * parameters.networks;
    lorenz_t_series = normalize_data(lorenz(n, 1, parameters.samplingTime));
    total_data_set = lorenz_t_series(:,2) + 0.1*randn(n, 1);
    [u_input, z_target] = prepare_data_for_prediction(total_data_set, parameters, window);
elseif taskName == "mackey_glass"
    window = parameters.predictionWindow;
    n = 3*(parameters.sampleLength + window) * parameters.networks;
    mg_t_series = normalize_data(mackey_glass(n));
    total_data_set = mg_t_series + 0.1*randn(n, 1);
    [u_input, z_target] = prepare_data_for_prediction(total_data_set, parameters, window);
end
end

function [u, z] = prepare_data_for_prediction(total_data_set, parameters, window)
    u = [];
    z = [];
    total_len = length(total_data_set);
    for network_index = 0:parameters.networks-1
       network_data_set = total_data_set(network_index + 1:((network_index+1)/parameters.networks)*total_len);
       for split_index = 0:2
           indic = split_index*parameters.sampleLength;
           curr_input = network_data_set(1+indic:parameters.sampleLength+indic);
           curr_target = network_data_set(1+indic+window:parameters.sampleLength+indic+window);
           u = [u;curr_input];
           z = [z;curr_target];
       end
    end
end