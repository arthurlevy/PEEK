%VISCOSITY  returns the viscosity of the fibre/matrix bed using an
%Arrhenius law
%
%   mu = VISCOSITY(T) returns the viscosity mu given a Kelvin temperature
%   T.
%
%   [mu, sensib] = VISCOSITY(T) also returns the sensibility to temperature
%   d(mu)/d(T). useful for non-linear solving.
%
% See also : COUPLED_PB, CONSOLSUB_FREE, CONSOLSUB_GIVEN_PRESSURE


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
function [mu, sensib] = viscosity(T)


%% Lee and Springer (PEEK)
% A = 1.13e-10;
% B = 19100;
% 
%% Lee and Springer (APC2)
% A = 1.14e-12;
% B = 26300;
% 
%% Mantell and Springer (PEEK)
% A = 1.13e-10;
% B = 19100;

%% Mantell and Springer (APC2) or Tierney and Gillespie (APC2) or Sonmez et Hahn
A = 132.95;
B = 2969;

%% Nicodeau (PEEK)
% A = 5.6e-3;
% B = 7.44e4/8.31;

%% Khan et al (APC2)
% A = 643;
% B = 4367;


%% Colton et al (PEEK)
% A = 244.9;
% B = 1969.8;


Tg = 143+273.16;

mu = A*exp(B./T);

if(mu < A*exp(B./Tg) * eps )
    warning('viscosity:low',...
        'the viscosity is lower than the machine zero');
end


%derivative
if (nargout == 2)
    sensib = - B* mu .* T.^(-2) ;
end
