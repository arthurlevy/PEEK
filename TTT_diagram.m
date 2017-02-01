% This function produces a Time-Temperature-Transformation diagram for the
% crystallization phenomenon while solidifying a PEEK polymer.
function [ tspan, Tspan, alpha ] = TTT_diagram
%    TTT_diagram is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    Fractal Dic is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with TTT_diagram.  If not, see <http://www.gnu.org/licenses/>.

%% mesh
nbpoint_t = 1000;
tspan = linspace(0,20,nbpoint_t); %s

%% load Nakamura kinetics:
%read experimental data from excel file
Tspan = xlsread('Donnee_cinetique.xlsx','A2:A19');
K = xlsread('Donnee_cinetique.xlsx','B2:B19');

% fit a parabola (in the log space)
Fitting = fit(Tspan, log(K), 'poly2');

%and propose a finer mesh for Tspan and K:
nbpoint_T = 40;
Tspan = linspace(190, 280, nbpoint_T);
K = exp(...
    Fitting.p1 * (Tspan).^2 ...
    + Fitting.p2   * (Tspan)...
    + Fitting.p3 );

%% initialize alpha (the field that we try to plot)
alpha = zeros(nbpoint_T,nbpoint_t); %initialization

%% solve the ODE for each temperature
for iter_temperature = 1:nbpoint_T
    [~, alpha(iter_temperature,:)] = ode45(...
        @(t,a) K(iter_temperature) * GNakamura(a),... % my Right hand side
        tspan, 0);%solve over tspan, with initial condition alpha = 0
end

%% contour plot
[~,h] = contour(tspan,Tspan,alpha, ...
    [0.05, 0.5, 0.95]); %with only 3 levrels
colormap([0 0 0]); %all black

xlabel('Time (s)')
ylabel('Temperature (^{\circ}C)');

set(gca,'XScale','log', ...
    'xlim', [3e-2, 20]);

set(h,'ShowText','on'); %to write actual values on iso-lines
title ('TTT Diagram, iso-degree of Crystallization')

end
