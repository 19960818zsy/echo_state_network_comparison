function [] = compare_networks()
parameters = configure_parameter_struct();
task = parameters.task;
parameters.kappa = -1;
parameters.function = @sin; % sin, random network
parameters.spectralRadius = 0.6; % after optimization
performances_sinrand = esn_analysis(task, parameters);
parameters.function = @tanh; % tanh, random network
performances_tanhrand = esn_analysis(task, parameters);
parameters.spectralRadius = 1;
parameters.kappa = 0.5; % a.o.
parameters.alpha = 0.3; % a.o.
performances_tanhlattice = esn_analysis(task, parameters);
parameters.function = @sin;
parameters.alpha = 0.65; % a.o.
performances_sinlattice = esn_analysis(task, parameters);
hold on;
plot(parameters.range, performances_sinrand);
plot(parameters.range, performances_tanhrand);
plot(parameters.range, performances_tanhlattice);
plot(parameters.range, performances_sinlattice);
legend({"Sinusoidal, random", "Tanh, random", "Tanh, lattice", "Sinusoidal, lattice"} ... 
    , "Location", "southeast");
xlabel("Prediction window");
ylabel("Pearson correlation coefficient");
[~, description] = task_mapper(task);
title(description);
hold off;
end

