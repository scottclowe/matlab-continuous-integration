function roots = quadraticSolver(a, b, c)
% quadraticSolver returns solutions to the
% quadratic equation a*x^2 + b*x + c = 0.

assert(isnumeric(a), 'Coefficient a must be numeric');
assert(isnumeric(b), 'Coefficient b must be numeric');
assert(isnumeric(c), 'Coefficient c must be numeric');

roots(1) = (-b + sqrt(b^2 - 4*a*c)) / (2*a);
roots(2) = (-b - sqrt(b^2 - 4*a*c)) / (2*a);

end
