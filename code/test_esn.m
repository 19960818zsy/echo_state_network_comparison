function [performance_measure, best_lambda, neuron_values] = test_esn(u, z, parameters)
data_splits_u = split_into_folds(u, 3);
data_splits_z = split_into_folds(z, 3);
lambda_values = -5:0.1:5;
best_lambda = -5;
opt = -1;
all_weights = [];
trained_weights = [];
for l = lambda_values
    parameters.ic = 2*rand(parameters.neurons,1) - 1;
    training_sample_u = data_splits_u{1};
    training_sample_z = data_splits_z{1};
    training_sample_z = training_sample_z(ceil(parameters.transientCutoff*length(training_sample_z)):end);
    X_training = esn_evaluate(training_sample_u, parameters);
    output_weights = ridge(training_sample_z, X_training', exp(l), 0);
    all_weights = [all_weights; output_weights(1)*output_weights(2:end)];
    validation_sample_u = data_splits_u{2};
    validation_sample_z = data_splits_z{2};
    validation_sample_z = validation_sample_z(ceil(parameters.transientCutoff*length(validation_sample_z)):end);
    X_val = esn_evaluate(validation_sample_u, parameters);
    approx_val = output_weights(1) + X_val'*output_weights(2:end);
    val_performance = parameters.performanceMeasure(approx_val, validation_sample_z);
    if val_performance > opt
        opt = val_performance;
        trained_weights = output_weights;
        best_lambda = exp(l);
    end
end
test_sample_u = data_splits_u{3};
test_sample_z = data_splits_z{3};
test_sample_z = test_sample_z(ceil(parameters.transientCutoff*length(test_sample_z)):end);
[X_test, neuron_values] = esn_evaluate(test_sample_u, parameters);
if length(trained_weights) == 0
    performance_measure = -1;
else
    approx_test = trained_weights(1) + X_test'*trained_weights(2:end);
    performance_measure = parameters.performanceMeasure(approx_test, test_sample_z);
end

% UNCOMMENT TO PLOT OUTPUT WEIGHT HISTOGRAM
% histogram(all_weights, 100);
% hold on
% title(strcat(num2str(parameters.alpha), " = alpha, distribution of output weights"));
% xlabel("Values of output weights");
% ylabel("Frequency");
% hold off