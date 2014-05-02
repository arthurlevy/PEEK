%This function outputs the orientation tensor approximation for a given
%number of orientations. the orientation 1D-array listing the orientations
%should have "a lot" of elements.
function orientation_tensor = get_orientation_tensor(orientations)

psi = 1/length(orientations); % equi-probability to have each element in the vector

u = cos(orientations);
v = sin(orientations);

orientation_tensor(1,1) = sum(u.*u)*psi;
orientation_tensor(1,2) = sum(u.*v)*psi;
orientation_tensor(2,2) = sum(v.*v)*psi;
orientation_tensor(2,1) = orientation_tensor(1,2);

