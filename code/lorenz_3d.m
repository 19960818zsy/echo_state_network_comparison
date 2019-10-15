function t_series = lorenz_3d(n,st)
% This function returns a time series of the Lorenz equation.
% return value t_series: the time series
% input value n: length of the time series
% input value d: which dimension the time series is of
% d=1 denotes x, d=2 denotes y, d=3 denotes z
% input value st: sampling time 
sigma = 10;
beta = 8/3;
rho = 28;
f = @(t,a) [-sigma*a(1) + sigma*a(2); rho*a(1) - a(2) - a(1)*a(3); -beta*a(3) + a(1)*a(2)];
[t,a] = ode23(f,0:st:n,[1 1 1]);
plot3(a(:,1), a(:,2), a(:,3));
