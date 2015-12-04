function test_suite=rectifiedCubic_moxunit_test()
    initTestSuite
end

function test_rectifiedCubic_main()
    assert(isequal(8, rectifiedCubic(2)))
    assert(isequal(0, rectifiedCubic(-2)))
    assert(isequal(27, rectifiedCubic(3)))
end