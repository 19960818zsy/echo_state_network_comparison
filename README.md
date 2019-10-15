# Echo State Network Comparison Library
An echo state network library allowing for the comparison of lattice-based network configurations with the classical random echo state network (ESN) network configuration.

## Installing
To run the code, you must have the MATLAB programming language. There are two ways to install this repository. 

### Method 1: using command line
* If not already installed, install `git` from `https://git-scm.com/book/en/v2/Getting-Started-Installing-Git`. 
* Using a command line interface, navigate to to a location in which the code is to be installed.
* Type
```
git clone https://github.com/r0bmar/echo_state_network_comparison.git
```
in order to clone the repository to your local machine

The advantage of this method is that changes can be automatically updated locally by running `git pull` when changes are made.

### Method 2: downloading a zip from GitHub
On the home page of the repository
```
https://github.com/r0bmar/echo_state_network_comparison
```
select the option Clone or Download > Download ZIP. This downloads a ZIP file to your computer. Unzip the file, now the repository contents have been downloaded to your computer.

### Setup
Once the code is on your machine, open MATLAB (any version should work, as long as it's not too old). Set the current working directory to be the `echo_state_network_comparison > code` folder. Now code can be run in the Command Window.

## Running a simple parameter analysis
To run a simple example, the following must be done:
* In the directory `echo_state_network_comparison > code`, open the file `configure_parameter_struct.m`.
The contents of this file are 
```
function parameters = configure_parameter_struct()
parameters.W = [];
parameters.V = [];
parameters.b = [];
parameters.ic = [];
parameters.networks = 1;
parameters.neurons = 50;
parameters.kappa = -1;
parameters.alpha = 0.3;
parameters.sparsity = 0.10;
parameters.leak = 1;
parameters.spectralRadius = 1;
parameters.function = @tanh;
parameters.toTest = "alpha";
parameters.range = 0:0.1:1;
parameters.perfType = "test";
parameters.performanceMeasure = @(x,y)(corr(x,y));
parameters.transientCutoff = 0.01;
parameters.samplingTime = 0.1;
parameters.lambda = -1;
parameters.sampleLength = 1000;
parameters.predictionWindow = 0;
parameters.task = 1;
end
```
This is a list of parameters that the code will use in order to construct an echo state network with the desired configuration. In this example, an echo state network will be run over a parameter range and the performance plotted, together with the consistency. 

### Important parameters to set
The following parameters are crucial to the code working correctly and must be set in order to perform any analysis.  Note that the first four parameter fields are initialized internally and should not be changed by the user.
* `parameters.toTest` is the name of this parameter which is to be varied. The field `parameters.range` is then assigned to this parameter in the code in order to construct a parameter range over which the network is tested. Note that this must be a string, and must correspond exactly to the name of any parameter listed above.
* `parameters.range` is the parameter range over which the echo state network re-trains and performs tests. This must be a MATLAB vector. Typically, a range that is too fine will lead to very long execution time.
* `parameters.networks` denotes the number of network realizations that will be set up in order to perform tests. A low number of networks may lead to imprecise performance readings, however too many networks will lead to extremely long training time. By default, this parameter is set to 1.
* `parameters.neurons` denotes the number of neurons that each network will be initialized with. Too few neurons will lead to a low number of degrees of freedom, and too many neurons will again lead to long training time and infeasible computation. By default, this parameter is set to 50.
* `parameters.kappa` sets the value of kappa, which is the coupling strength of the internal weight matrix used by the lattice ESN. **If this is set to -1, this indicates the use of a random ESN configuration. If the lattice network configuration is to be used, please set this parameter to a positive value**.
* `parameters.alpha` sets the value of alpha, which is the decay parameter of the internal weight matrix used by the lattice ESN.
* `parameters.spectralRadius` sets the value of the spectral radius. **If the lattice network configuration is to be used, please set this parameter to 1**. 
* `parameters.function` sets the activation function of the ESN. Typically, this is `@tanh`, but other activation functions such as `@sin` or any other single-output function can be used here.
* `parameters.predictionWindow` sets the prediction time step for a prediction task. **If a reconstruction task is to be performed, this parameter will be ignored. Else this must be set.** By default, this is set to 0.
* `parameters.task` represents the task that will be performed in this experiment. Descriptions of tasks are provided below.

### Description of tasks
```
parameters.task = 1: "Reconstructing the Lorenz z time series with 10% observational noise from the Lorenz x time series with 10% observational noise."
parameters.task = 2: "Predicting parameters.predictionWindow further values of the Lorenz x time series."
parameters.task = 3: "Predicting parameters.predictionWindow further values of the Mackey-Glass time series."
```

### Code to run
With the default values of the parameter struct outlined above, a simple test can be performed:
```
parameters = configure_parameter_struct();
task = parameters.task;
performances = esn_analysis(task, parameters);
```
These lines of code will perform an analysis of a lattice ESN (since `parameters.kappa = 0.5` and `parameters.spectralRadius = 1`) while changing `parameters.alpha` between 0 and 1, with an offset of 0.1 (see `parameters.range`). Since `parameters.task = 1`, the Lorenz z time series is being reconstructed from the Lorenz x time series. As a result, a plot of performance and consistency is returned, while alpha is being changed.

Parameter values can be adjusted at will in order to investigate other properties of the random and lattice ESNs. 



