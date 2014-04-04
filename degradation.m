%DEGRADATION given a temperature history and an initial degree of
%degradation, returns the final degree of degradation.
%    
%   [tspan, Deg] = DEGRADATION(TIME_MESH, TEMPERATURE) returns a final
%   degradation degree Ddeg given a temperature history and a time mesh.
%   temperature is a 1D-array (or 2D-Array) in Kelvin, where each line is
%   the temperature(s) at different time. time mesh is a 1D Array.
%    
%   [tspan, Ddeg] = DEGRADATION(TIME_MESH, TEMPERATURE, Deg_init) same as
%   above except that an initial degree of degreadation already exists.
%   default:Deg_init = 0.
%

function [tspan, Deg] = degradation(time_mesh, temperature, Deg_init)
t_f = time_mesh(end);

if (nargin==2)
    Deg_init = zeros(1,size(temperature,2));
end

assert(length(time_mesh) == size(temperature,1),...
    'your time_mesh and temperature discretization are not the same');
assert(length(Deg_init) == size(temperature, 2),...
	'your initial degree of degradation and temperature discretization are not the same');

% we will solve the Nam & Seferis 1992 evolution equation:
% dDdeg/dt = k(T) * F(Ddeg); where F(Ddeg) = y1(1-Ddeg) + y2*Ddeg*(1-Ddeg)

% this is a function that return the temperature given a time
fun_T = @(t) interp1(time_mesh, temperature, t);

%right hand side
RHS = @(t,Deg)   K(fun_T(t))' .* F(Deg);

%% solving the evolution equation using RK4 method:
options = odeset(...
    'NonNegative', 1);
[tspan, Deg] = ode45(RHS, [0, t_f], Deg_init, options);


%this arrhenius law for temperature dependency
function res = K(temperature)
Ea = 240.2e3 ;
A = 8.265e12;
R = 8.31;
res = A * exp(-Ea./R./temperature);

function res = F(Deg)
y1 = 0.0215;
y2 = 0.9785;
res = y1*(1-Deg) + y2*Deg.*(1-Deg);
