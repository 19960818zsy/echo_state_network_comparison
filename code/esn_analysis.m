function final_performances = esn_analysis(task, parameters)
taskName = task_mapper(task);
vals = [];
all_lambdas = [];
all_consistencies = [];
all_memory_capacities = [];
all_neuron_vals = [];
% data_size = 3*parameters.sampleLength*parameters.networks;
[u_input, training_target] = generate_test_data(parameters, taskName);
data_splits_u = split_into_folds(u_input, parameters.networks);
data_splits_z = split_into_folds(training_target, parameters.networks);
for j = 1:parameters.networks
    u = data_splits_u{j};
    z = data_splits_z{j};
    disp(strcat('Network ', num2str(j)));
    performances = zeros(1,length(parameters.range));
    lambdas = zeros(1,length(parameters.range));
    consistencies = zeros(1,length(parameters.range));
    memory_capacities = zeros(1,length(parameters.range));
    neuron_vals = [];
    index = 1;
    for ii = parameters.range
        parameters.(parameters.("toTest")) = ii;
        disp(ii);
        [performance_measure, consistency, best_lambda, memory_capacity ...
            , neuron_val] ... 
            = estimate_performance(u, z, parameters);
        performances(index) = performance_measure;
        lambdas(index) = best_lambda;
        consistencies(index) = consistency;
        memory_capacities(index) = memory_capacity;
        % neuron_vals = [neuron_vals neuron_val];
        index = index + 1;
    end
    vals = [vals;performances];
    all_lambdas = [all_lambdas;lambdas];
    all_consistencies = [all_consistencies;consistencies];
    all_memory_capacities = [all_memory_capacities; memory_capacities];
   % all_neuron_vals = [all_neuron_vals neuron_vals];
end
plot_obj = configure_plot_struct();
% error_vals = [];
for k = 1:length(parameters.range)
     plot_val = mean(vals(:,k));
     lambda_val = mean(all_lambdas(:,k));
     consistency_val = mean(all_consistencies(:,k));
     memory_capacity_val = mean(all_memory_capacities(:,k));
%     sd = sqrt(var(vals(:,k)));
     plot_obj.to_plot = [plot_obj.to_plot plot_val];
     plot_obj.to_plot_lambdas = [plot_obj.to_plot_lambdas lambda_val];
     plot_obj.to_plot_consistencies = [plot_obj.to_plot_consistencies consistency_val];
     plot_obj.to_plot_memories = [plot_obj.to_plot_memories memory_capacity_val];
%     error_vals = [error_vals sd];
end
% plot_obj.to_plot_neuron_vals = all_neuron_vals;
final_performances = plot_obj.to_plot; 
plot_code(parameters, plot_obj);
% plot_neuron_vals(parameters, plot_obj);
end


function plot_obj = configure_plot_struct()
plot_obj.to_plot = [];
plot_obj.to_plot_saturations = [];
plot_obj.to_plot_lambdas = [];
plot_obj.to_plot_consistencies = [];
plot_obj.to_plot_memories = [];
plot_obj.to_plot_neuron_vals = [];
end


function [] = plot_code(parameters, plot_obj)
figure;
plot(parameters.range, plot_obj.to_plot, 'b');
hold on
plot(parameters.range, plot_obj.to_plot_consistencies, 'r');
xlabel(parameters.toTest, 'Interpreter', 'latex', 'FontSize', 11);
ylabel("Pearson correlation coefficient $r$", 'Interpreter', 'latex', 'FontSize', 11);
title("Random network configuration with tanh nonlinearity");
legend({"Test performance", "Consistency"}, "Location", "southwest");
hold off
figure;
plot(parameters.range, plot_obj.to_plot_lambdas, 'g');
hold on
xlabel(parameters.toTest, 'Interpreter', 'latex');
ylabel("$\lambda$", 'Interpreter', 'latex');
title(title_generator(parameters));
hold off
figure;
plot(parameters.range, plot_obj.to_plot_memories, 'b');
hold on
xlabel(parameters.toTest, 'Interpreter', 'latex');
ylabel("Memory capacity", 'Interpreter', 'latex');
title(title_generator(parameters));
hold off
end

function [] = plot_neuron_vals(parameters, plot_obj)
figure;
hold on;
for ii = 1:length(parameters.range)
    xc = floor(sqrt(length(parameters.range)));
    yc = ceil(sqrt(length(parameters.range)));
    subplot(xc, yc+1, ii);
    hists = plot_obj.to_plot_neuron_vals;
    value = parameters.range(ii);
    hist(hists(:,ii));
    title(num2str(value));
end
hold off;
end

% function [] = plot_code(parameters, plot_obj)
% figure;
% subplot(2,1,1);
% plot(parameters.range, plot_obj.to_plot, 'b');
% hold on
% xlabel(parameters.toTest, 'Interpreter', 'latex', 'FontSize', 11);
% ylabel(strcat('Parameter: $\quad$', parameters.perfType , ' performance $r$'), 'Interpreter', 'latex', 'FontSize', 11);
% title(strcat(num2str(parameters.networks), ' echo-state networks reconstructing Lorenz z from Lorenz x'));
% hold off
% subplot(2,1,2);
% plot(parameters.range, plot_obj.to_plot_consistencies, 'r');
% hold on
% xlabel(parameters.toTest, 'Interpreter', 'latex', 'FontSize', 11);
% ylabel('Consistency measure $\gamma$', 'Interpreter', 'latex', 'FontSize', 11);
% title(strcat(num2str(parameters.networks), ' echo-state networks reconstructing Lorenz z from Lorenz x'));
% hold off
% end
