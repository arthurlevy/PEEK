% This function produces a Time-Temperature-Transformation diagram for the
% crystallization phenomenon while solidifying a PEEK polymer.
function [ tspan, Texpe, alpha ] = TRC_diagram
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
%time
nbpoint_t = 5000;
tspan = linspace(0,350,nbpoint_t); %s

%% load Nakamura kinetics:
%read experimental data from excel file
Texpe = xlsread('Donnee_cinetique.xlsx','A2:A19');
Kexpe = xlsread('Donnee_cinetique.xlsx','B2:B19');
% fit a parabola (in the log space)
Fitting = fit(Texpe, log(Kexpe), 'poly2');

%% define cooling rate
nb_cooling_rate = 8;
r = linspace(2.5, 20, nb_cooling_rate)/60; %degrees per seconds
T_init = 300; %initial temperature

%% initialization 
alpha = zeros(nb_cooling_rate,nbpoint_t); %initialization
figure; hold all;
xlabel('Time (s)')
ylabel ('Temperature(^\circC)')

for iter_cooling_rate = 1:nb_cooling_rate
    
    %% first define function K versus time
    T = @(t) T_init - r(iter_cooling_rate) * t;
    K = @(t) exp(...
        Fitting.p1 * (T(t))^2 ...
        + Fitting.p2   * (T(t))...
        + Fitting.p3 );
    
    %% solve the ODE
    [~, current_alpha] = ode45(...
        @(t,a) K(t) * GNakamura(a),... % my Right hand side
        tspan, 0);%solve over tspan, with initial condition alpha = 0
    
    %% plot cooling straignt lines
    plot(tspan,T(tspan), 'k')
    text(tspan(fix(nbpoint_t/4)),...
        T(tspan(fix(nbpoint_t/4))),...
        [num2str(round(r(iter_cooling_rate)*60,1)), '^\circC/min']);
    
    %% store alpha result for global output
    alpha(iter_cooling_rate,:) = current_alpha;
end

%% Plot
plot_TCR(tspan, r, alpha, T_init)
end


function plot_TCR(tspan, r, alpha, T_init)
%% initialization
nb_cooling_rate = length(r);
t_start = zeros(nb_cooling_rate, 1);
t_middle = zeros(nb_cooling_rate, 1);
t_end = zeros(nb_cooling_rate, 1);
T_start = zeros(nb_cooling_rate, 1);
T_middle = zeros(nb_cooling_rate, 1);
T_end = zeros(nb_cooling_rate, 1);

for iter_cooling_rate = 1:length(r)
    T = @(t) T_init - r(iter_cooling_rate) * t;
    current_alpha = alpha(iter_cooling_rate, :);
    
    % find times when alpha = 0.1, 0.5 and 0.9
    t_interp = interp1(current_alpha(current_alpha<0.95),...
        tspan(current_alpha<0.95),...
        [0.1, 0.5, 0.9]);
    
    t_start(iter_cooling_rate) = t_interp(1);
    t_middle(iter_cooling_rate) = t_interp(2);
    t_end(iter_cooling_rate) = t_interp(3);
    
    % and associated temperatures
    T_start(iter_cooling_rate) = T( t_start(iter_cooling_rate) );
    T_middle(iter_cooling_rate) = T( t_middle(iter_cooling_rate) );
    T_end(iter_cooling_rate) = T( t_end(iter_cooling_rate) );
    
end

%% Plot
start_plot = plot(t_start,T_start,'g', 'LineWidth',3);
middle_plot = plot(t_middle,T_middle, 'k:');
end_plot = plot(t_end,T_end, 'r', 'LineWidth',3);
legend([start_plot, middle_plot, end_plot] ,'\alpha = 0.1', '\alpha = 0.5', '\alpha = 0.9')
ylim([270 300])

end
