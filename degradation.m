%DEGRADATION given a temperature history and an initial degree of
%degradation, returns the final degree of degradation.
%    
%   D = DEGRADATION(TIME_MESH, TEMPERATURE,dt) returns a final degradation
%   degree Ddeg given a temperature history and a time mesh. temperature is
%   a 1D-array (or 2D-Array) in Kelvin, where each line is the
%   temperature(s) at different time. time mesh is a 1D Array.
%    
%   Ddeg = DEGRADATION(TIME_MESH, TEMPERATURE, dt, Ddeg_init) same as above
%   except that an initial degree of degreadation already exists.
%   default:Ddeg_init = 0.
%

function [tspan, Deg] = degradation(time_mesh, temperature, Ddeg_init)
t_f = time_mesh(end);

if (nargin==2)
    Ddeg_init = zeros(1,size(temperature,2));
end

assert(length(time_mesh) == size(temperature,1),...
    'your time_mesh and temperature discretization are not the same');

% we will solve the Nam & Seferis evolution equation:
% dDdeg/dt = k(T) * F(Ddeg); wher F(Ddeg) = y1(1-Ddeg) + y2*Ddeg*(1-Ddeg)
y1 = 0.0215;
y2 = 0.9785;

% this is a function that return the temperature given a time
fun_T = @(t) interp1(time_mesh, temperature, t);

%right hand side
RHS = @(t,Deg) ...
    K(fun_T(t))' .* ( y1*(1-Deg) + y2*Deg.*(1-Deg) );

%% solving the evolution equation using RK4 method:
options = odeset(...
    'NonNegative', 1);
[tspan, Deg] = ode45(RHS, [0, t_f], Ddeg_init, options);





%this arrhenius law for temperature dependency
function res = K(temperature)
Ea = 240.2e3 ;
A = 8.265e12;
R = 8.31;
res = A * exp(-Ea./R./temperature);
