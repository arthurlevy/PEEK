%This function position randomly Ns strands in a 2D rectangular mould. It
%ensures the constrains that no strand are across the mould wall. the
%function returns a 3*Ns array 'configuration'. Each line represents a
%strand configuration by its coordinate x and y (column 1 and 2) and its
%orientation theata (column 3).
function configuration = random_distribution

%% mould size
Dx = 4*25e-3;%m
Dy = 4*25e-3;%m

%% number of strands to distribute
Ns = 5000;

%% strands dimensions
L = 0.5*25.4e-3;%m length
w = L/4; %width

%% initialize configuration
% first column is x position
% second column is y position
% last column is theta orientation
configuration = zeros(Ns,3);

%% loop for each strand
for i = 1:Ns
	positionned = false; %we did not manage yet to position it
	
	while (~positionned) % try to position strand i	
		%suggest a position
		[x, y, theta] = through_dice(Dx,Dy);
		%test if it is not braking constrains
		positionned = is_it_possible(x,y,theta,Dx,Dy, L,w);
		
	end
	
	%store the configuration of strand i
	configuration(i,:) = [x,y,theta];
end

%% visualisation

u = cos(configuration(:,3)) * L; %x dimension of each vector
v = sin(configuration(:,3)) * L; %y dimension of each vector
x = configuration(:,1) - u/2; %starting x position of each vector
y = configuration(:,2) - v/2; %starting y position of each vector
% arrows plot:
quiver(x, y, u,v)

end


%generate a random configuration for a strand in the mould.
function [x, y, theta] = through_dice(Dx,Dy)
x = rand * Dx;
y = rand * Dy;
theta = rand*pi; %theta should be between 0 and 180 deg
end


%check if a configuration given by x, y and theta is possible (not
%constrained geometrically by mould walls. Dx and Dy are the mould
%dimensions. L and w the strands dimensions
function positionned = is_it_possible(x,y,theta,Dx,Dy,L,w)

positionned = ...
	(   (x - abs(cos(theta)*L))    >  0 ) * ... not crossing left wall
	(   (x + abs(cos(theta)*L))    <  Dx) * ... not crossing right wall
	(   (y - sin(theta)*L)    >  0 ) * ... not crossing lower wall
	(   (y + sin(theta)*L)    <  Dy) ;%    not crossing upper wall

%note that currently, we consider "slender" strands (ie w = 0);
end