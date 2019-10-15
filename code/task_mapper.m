function [taskName, description] = task_mapper(task)
if task == 1
    taskName = "lorenz_reconstruction";
    description = "Constructing the z component from the x component of the Lorenz system";
elseif task == 2
    taskName = "lorenz_prediction";
    description = "Predicting subsequent values of the Lorenz x time series";
elseif task == 3
    taskName = "mackey_glass";
    description = "Predicting subsequent values of the Mackey-Glass time series";
end
end