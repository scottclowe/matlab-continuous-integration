function roots = quadraticSolver(a, b, c)
% quadraticSolver returns solutions to the 
% quadratic equation a*x^2 + b*x + c = 0.

if ~isa(a,'numeric') || ~isa(b,'numeric') || ~isa(c,'numeric')
    error('quadraticSolver:InputMustBeNumeric', ...
        'Coefficients must be numeric.');
end

roots(1) = (-b + sqrt(b^2 - 4*a*c)) / (2*a);
roots(2) = (-b - sqrt(b^2 - 4*a*c)) / (2*a);

%roots = real(roots); % Make imaginary fail

end

%!test
%!  actSolution = quadraticSolver(1,-3,2);
%!  expSolution = [2 1];
%!  assert(isequal(actSolution,expSolution))

%!test
%!  actSolution = quadraticSolver(1,2,10);
%!  expSolution = [-1+3i -1-3i];
%!  assert(isequal(actSolution,expSolution))