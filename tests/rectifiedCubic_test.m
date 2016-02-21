% Tests for rectifiedCubic, implemented with the MOxUnit framework

function test_suite=rectifiedCubic_test()
    % Top level function should call initTestSuite and return the
    % variable test_suite (which initTestSuite will put into the
    % workspace for us).
    initTestSuite;
end

function test_input_handling()  %#ok<*DEFNU>
    % Check that an error is thrown for a bad input. The second
    % parameter is the expected error message, which in our case is
    % omitted because rectifiedCubic throws the error with a call to
    % `assert()`, not `error()`.
    % Throw an error if input is a string.
    assertExceptionThrown(@()rectifiedCubic('foobar'), '');
end

function test_integer()
    % Check the function works as expected for integer inputs.
    assertEqual(rectifiedCubic(2), 8);
    assertEqual(rectifiedCubic(-2), 0);
    assertEqual(rectifiedCubic(3), 27);
end

function test_int8()
    % Check the function preserves the class for int8 input.
    assertEqual(rectifiedCubic(int8(5)), int8(125));
end

function test_float()
    % Check the function works as expected for float inputs.
    % We need to use assertElementsAlmostEqual due to the very real
    % possibility of a floating point inaccuracy.
    assertElementsAlmostEqual(rectifiedCubic(1.2), 1.728);
    assertElementsAlmostEqual(rectifiedCubic(-1.2), 0);
end

function test_empty()
    % Test empty vector input
    assertEqual(rectifiedCubic([]), []);
end

function test_vector()
    % Check the function works for row vectors
    assertEqual(rectifiedCubic([0, 2, -2]), [0, 8, 0]);
    % and for column vectors too
    assertEqual(rectifiedCubic([0; 2; -2]), [0; 8; 0]);
end

function test_colon()
    % Need to use assertElementsAlmostEqual when working with colon
    % because the elements it generates are not precisely integers.
    assertElementsAlmostEqual(rectifiedCubic(-3:3), [0, 0, 0, 0, 1, 8, 27]);
end

function test_nan_skip()
    % We can skip a test function with this MOxUnit utility.
    moxunit_throw_test_skipped_exception('Skip test with NaN input.');
    % If we use the builtin `==` or `isequal` functions, they will
    % say NaNs are unequal.
    assertTrue(rectifiedCubic(NaN)==NaN);
    assertTrue(isequal(rectifiedCubic(NaN), NaN));
end

function test_nan()
    % We can use the MOxUnit function `assertEqual` to compare two
    % NaNs with each other.
    assertEqual(rectifiedCubic(NaN), NaN);
    % Alternatively, we could use `isnan` and wrap it in assertTrue,
    % but this is less elegant and will lead to worse feedback from
    % MOxUnit in the event of an error.
    assertTrue(isnan(rectifiedCubic(NaN)));
end
