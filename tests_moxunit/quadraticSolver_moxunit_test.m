function test_suite=quadraticSolver_moxunit_test
    initTestSuite
end

function test_RealSolution()
    actSolution = quadraticSolver(1,-3,2);
    expSolution = [2 1];
    assertEqual(actSolution,expSolution)
end

function test_ImaginarySolution()
    actSolution = quadraticSolver(1,2,10);
    expSolution = [-1+3i -1-3i];
    assertEqual(actSolution,expSolution)
end