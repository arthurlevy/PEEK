%This function position randomly Ns strands in a 2D rectangular mould. It
%ensures the constrains that no strand are across the mould wall. the
%function returns a 3*Ns array 'configuration'. Each line represents a
%strand configuration by its coordinate x and y (column 1 and 2) and its
%orientation theata (column 3).
function configuration = random_distribution

%% mould size
Dx = 4*25.4e-3;%m
Dy = 4*25.4e-3;%m

%% strands dimensions
L = 1*25.4e-3;%m length
w = L/4; %width

%% number of strands to distribute
h = 6e-3;%m tplate thickness
th = 0.13e-3;%ply thickness
Ns_per_ply = Dx*Dy/(L*w);
Ns = round(Ns_per_ply * h/th);

%% initialize configuration
% first column is x position
% second column is y position
% last column is theta orientation
configuration = zeros(Ns,3);

%% loop for each strand
for i = 1:Ns

%suggest initial position
[x, y,theta] = throw_dice(Dx,Dy);
positionned = is_it_possible(x,y,theta,Dx,Dy,L,w);
while (~positionned) % try to position strand i
%suggest a position
[x, y,theta] = modify_position(x, y,theta, Dx,Dy);
%test if it is not braking constrains
positionned = is_it_possible(x,y,theta,Dx,Dy,L,w);

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
quiver(x,y,u,v);
rectangle('Position',[0 0 Dx Dy]);
figure

end


%generate a random configuration for a strand in the mould.
function [x, y, theta] = throw_dice(Dx,Dy)
x = rand * Dx;
y = rand * Dy;
theta = rand*2*pi; %theta should be between 0 and 360 deg
end


function [x, y,theta] = modify_position(x, y,theta, Dx,Dy)

dx = rand*Dx/30 - Dx/60;
dy = rand*Dy/30 - Dy/60;
dtheta = rand*2*pi/30;

x = x+dx;
y = y+dy;
if (x<0 || x>Dx); x=x-2*dx; end
if (y<0 || y>Dy); y=y-2*dy; end
theta = theta + dtheta;

end


%check if a configuration given by x, y and theta is possible (not
%constrained geometrically by mould walls. Dx and Dy are the mould
%dimensions. L and w the strands dimensions
function positionned = is_it_possible(x,y,theta,Dx,Dy,L,w)

positionned = ...
( (x - abs(cos(theta)*L/2)-abs(sin(theta)*w/2)) > 0 ) * ... not crossing left wall
( (x + abs(cos(theta)*L/2)+abs(sin(theta)*w/2)) < Dx) * ... not crossing right wall
( (y - abs(sin(theta)*L/2)-abs(cos(theta)*w/2)) > 0 ) * ... not crossing lower wall
( (y + abs(sin(theta)*L/2)+abs(cos(theta)*w/2)) < Dy) ;% not crossing upper wall
end