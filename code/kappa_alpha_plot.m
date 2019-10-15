function [] = kappa_alpha_plot()
parameters = configure_parameter_struct();
alpha_range = 0:0.025:1;
kappa_range = 0:0.05:2;
performance_grid = [];
for k = kappa_range
    parameters.range = alpha_range;
    parameters.toTest = "alpha";
    parameters.kappa = k;
    performances_for_k = esn_analysis(parameters);
    performance_grid = [performance_grid; performances_for_k];
end
alpha_grid = repmat(alpha_range, length(kappa_range), 1);
kappa_grid = repmat(kappa_range', 1, length(alpha_range));
surf(alpha_grid, kappa_grid, performance_grid);
hold on;
xlabel('alpha');
ylabel('kappa');
zlabel('Test performance');
hold off;