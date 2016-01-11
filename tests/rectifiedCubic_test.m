% Tests for rectifiedCubic, implemented with the MOxUnit framework

function test_suite=rectifiedCubic_test()
    initTestSuite
end

function test_rectifiedCubic_input_handling()
    assertExceptionThrown(@()rectifiedCubic('string'), '');
end

function test_rectifiedCubic_main()
    assert(isequal(8, rectifiedCubic(2)))
    assert(isequal(0, rectifiedCubic(-2)))
    assert(isequal(27, rectifiedCubic(3)))
end

function ignored_test_rectifiedCubic_fails()
    % This is ok
    assert(isequal(27, rectifiedCubic(3)))
    % This is not and should fail
    assert(isequal(27, rectifiedCubic(-3)))
    % This is ok
    assert(isequal(1, rectifiedCubic(1)))
    % This is not and should fail
    assert(isequal(1, rectifiedCubic(-1)))
end

function test_rectifiedCubic_skips()
    % This is ok
    assert(isequal(27, rectifiedCubic(3)))
    % This is not and should fail
    moxunit_throw_test_skipped_exception('hmm this shouldnt work');
    assert(isequal(27, rectifiedCubic(-3)))
    % This is ok
    assert(isequal(1, rectifiedCubic(1)))
    % This is not and should fail
    moxunit_throw_test_skipped_exception('hmm nor should this');
    assert(isequal(1, rectifiedCubic(-1)))
end

function test_skip_success()
    moxunit_throw_test_skipped_exception('this might not be skipped');
    assertTrue(true);
end

function test_timing()
    pause(0.5);
    assertTrue(true);
end

function ignored_test_string_equality_failure()
    assertEqual('foo','bar');
end

function ignored_test_cell_equality_failure()
    assertEqual({},{'bar'});
end

function ignored_test_class_equality_failure()
    assertEqual('foo',{'bar'});
end
