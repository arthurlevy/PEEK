%MAP_ORIENTATION_TENSOR( configuration ) outputs a map of orientation
%tensors approximation for a given configuration input vector.
%Configuration is has three column (x position, y position and theta angle)
%where each line represents a strand configuration. xmesh and y mesh are
%arrays for the space mesh. a is a 4D array where first and second
%dimensions are used for the 2x2 orientation matrix and the third and
%fourth are the positions (according to xmesh and ymesh). Ns is a 2D array
%giving the number of strands found at each positions.
%
function [ xmesh, ymesh, a, Ns ] = map_orientation_tensor( configuration )

%% MESH
nx = 20;
ny = nx;
xmax = max(configuration(:,1));
xmesh = linspace(0,xmax, nx);

ymax = max(configuration(:,2));
ymesh = linspace(0,ymax, ny);

%% initialize
a = zeros( 2, 2, nx, ny);% the orientation tensor (2x2 matrix) at each x and y position 
Ns = zeros(nx, ny);%number of strands at each positions

%% loop for each strand
for i=1:size(configuration,1)
    
    %get current strand configuration
    curr_x = configuration(i,1);
    curr_y = configuration(i,2);
    curr_theta = configuration(i,3);

    % get the index of the position of the strand in the mesh
    ind_x = find(curr_x <= xmesh, 1, 'first')-1;
    ind_y = find(curr_y <= ymesh, 1, 'first')-1;

    % a at this position should be updated
    a(:,:,ind_x,ind_y) = update_orientation_tensor(...
        a(:,:,ind_x,ind_y), Ns(ind_x,ind_y), curr_theta);
    
    % there is a new strand at this position
    Ns(ind_x,ind_y) = Ns(ind_x,ind_y)+1;
end

%% cleaning
%positions with no strands (binary matrix)
no_strands = (Ns == 0);
%set orientation tensor to NaN at these positions
a(:,:,no_strands) = NaN;


%% plotting
surf (   xmesh,   ymesh,    squeeze( a(1,1,:,:) )'      );
xlabel('x position');
ylabel('y position');
zlabel('Orientation tensor, xx coordinate');

end


function a = update_orientation_tensor(a, Ns, theta)

%unit direction vector for the strand orientation theta
p = [cos(theta) sin(theta)];

%update a = sum(p'*p)/Ns
a = ( a*Ns + (p'*p) )  / (Ns+1);

end


