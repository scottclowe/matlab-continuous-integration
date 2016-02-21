% Tests for abs, implemented with the MOxUnit framework
% Copied from MOxUnit.

% Copyright (c) 2015 Nikolaas N. Oosterhof
%
% Permission is hereby granted, free of charge, to any person obtaining a
% copy of this software and associated documentation files (the
% "Software"), to deal in the Software without restriction, including
% without limitation the rights to use, copy, modify, merge, publish,
% distribute, sublicense, and/or sell copies of the Software, and to permit
% persons to whom the Software is furnished to do so, subject to the
% following conditions:
%
% The above copyright notice and this permission notice shall be included
% in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
% OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
% NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
% DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
% OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
% USE OR OTHER DEALINGS IN THE SOFTWARE.

function test_suite=my_test_of_abs
    initTestSuite

function test_abs_scalar  %#ok<*DEFNU>
    assertTrue(abs(-1)==1)
    assertEqual(abs(-NaN),NaN);
    assertEqual(abs(-Inf),Inf);
    assertEqual(abs(0),0)
    assertElementsAlmostEqual(abs(-1e-13),0)

function test_abs_skip
    moxunit_throw_test_skipped_exception('2 is not really 3.');
    assertEqual(2, 3);

function test_abs_vector
    assertEqual(abs([-1 1 -3]),[1 1 3]);

function test_abs_exceptions
    % GNU Octave and Matlab use different error identifiers
    if moxunit_util_platform_is_octave()
        assertExceptionThrown(@()abs(struct),'');
    else
        assertExceptionThrown(@()abs(struct),...
                             'MATLAB:UndefinedFunction');
    end
