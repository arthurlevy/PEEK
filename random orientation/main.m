%% fill the mould
configuration = random_distribution;

%% get orientation tensor
[ xmesh, ymesh, a, Ns ] = map_orientation_tensor( configuration );
clear DA;

for i=1:length(xmesh)
	for j = 1:length(ymesh)
		DA(i,j) = degree_of_anisotropy(a(:,:,i,j));
	end
end

surf(xmesh, ymesh, DA);
xlabel('x position');
ylabel('y position');
title('Degree of anisotropy')
