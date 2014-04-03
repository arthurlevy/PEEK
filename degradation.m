%DEGRADATION given a temperature history and an initial degree of
%degradation, returns the final degree of degradation.
%    
%   D = DEGRADATION(TEMPERATURE,dt) returns a final degradation degree Ddeg
%   given a temperature history and a time step dt. temperature is a 
%   2D-array, dt is a scalar.
%    
%   Ddeg = DEGRADATION(TEMPERATURE, dt, Ddeg_init) same as above except
%   that an initial degree of degreadation already exists.
%   default:Ddeg_init = 0.
%

%This file is part of ATP Simulation.
%
%    ATP Simulation is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    ATP Simulation is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with ATP Simulation.  If not, see <http://www.gnu.org/licenses/>.
%
% Copyright 2012 Arthur Levy
function Ddeg = degradation(temperature, dt, Ddeg_init)
nstep = size(temperature,2);
nthru = size(temperature,1);
t_f = (nstep-1)*dt;

if (nargin==2)
    Ddeg_init = zeros(nthru,1);
end

assert(length(Ddeg_init) == size(temperature, 1),...
    'your initial degree of degradation and temperature discretization are not the same');

% we will solve the nam & seferis evolution equation:
% dDdeg/dt = k(T) * F(Ddeg); wher F(Ddeg) = y1(1-Ddeg) + y2*Ddeg*(1-Ddeg)
y1 = 0.0215;
y2 = 0.9785;

% this is a fuunction that return the temperature given a time
fun_T = @(t) interp1(0:dt:t_f, temperature', t)';

%right hand side
RHS = @(t,Deg) ...
    K(fun_T(t)) .* ( y1*(1-Deg) + y2*Deg.*(1-Deg) );

%% solving the evolution equation using RK4 method:
options = odeset(...
    'Vectorized', 'on',... %RHS(R[in]) does not depend on R[in-1] nor R[in+1]
    'NonNegative', 1:nthru);
[~, Deg2d] = ode45(RHS, [0, t_f], Ddeg_init, options);

Ddeg = Deg2d(end,:)';




%this arrhenius law for temperature dependency
function res = K(temperature)
Ea = 240.2e3 ;
A = 8.265e12;
R = 8.31;
res = A * exp(-Ea./R./temperature);
