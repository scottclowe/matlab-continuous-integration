function tests = solverTest
tests = functiontests(localfunctions);
end

%!test
%!  actSolution = quadraticSolver(1,-3,2);
%!  expSolution = [2 1];
%!  assert(isequal(actSolution,expSolution))

%!test
%!  actSolution = quadraticSolver(1,2,10);
%!  expSolution = [-1+3i -1-3i];
%!  assert(isequal(actSolution,expSolution))
