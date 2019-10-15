function [] = compare_networks_prediction()
parameters = configure_parameter_struct();
task = parameters.task;
prediction_range = parameters.range;
performances_sinrand = zeros(length(prediction_range), 1);
performances_tanhrand = zeros(length(prediction_range), 1);
performances_tanhlattice = zeros(length(prediction_range), 1);
performances_sinlattice = zeros(length(prediction_range), 1);
for ii = prediction_range
    disp("Prediction window: " + num2str(ii));
    parameters.predictionWindow = ii;
    parameters.range = ii;
    parameters.kappa = -1;
    parameters.function = @sin; % sin, random network
    parameters.spectralRadius = 0.6; % after optimization
    performance_sinrand = esn_analysis(task, parameters);
    performances_sinrand(ii) = performance_sinrand;
    parameters.function = @tanh; % tanh, random network
    performance_tanhrand = esn_analysis(task, parameters);
    performances_tanhrand(ii) = performance_tanhrand;
    parameters.spectralRadius = 1;
    parameters.kappa = 0.5; % a.o.
    parameters.alpha = 0.3; % a.o.
    performance_tanhlattice = esn_analysis(task, parameters);
    performances_tanhlattice(ii) = performance_tanhlattice;
    parameters.function = @sin;
    parameters.alpha = 0.65; % a.o.
    performance_sinlattice = esn_analysis(task, parameters);
    performances_sinlattice(ii) = performance_sinlattice;

end
hold on;
plot(prediction_range, performances_sinrand);
plot(prediction_range, performances_tanhrand);
plot(prediction_range, performances_tanhlattice);
plot(prediction_range, performances_sinlattice);
legend({"Sinusoidal, random", "Tanh, random", "Tanh, lattice", "Sinusoidal, lattice"} ... 
    , "Location", "southeast");
xlabel("Prediction window");
ylabel("Pearson correlation coefficient");
[~, description] = task_mapper(task);
title(description);
hold off;
end

