%DEGREE_OF_ANISOTROPY(orientation_tensor) computes the degree of anistropy
%given an 2D array orientation tensor.
function DA = degree_of_anisotropy(orientation_tensor)

if (isnan (orientation_tensor))
	DA = NaN;
else
	eigenvalues = eig(orientation_tensor);
	DA = 1-min(eigenvalues)/max(eigenvalues);
end