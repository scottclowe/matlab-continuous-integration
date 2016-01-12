%rectifiedCubic    Rectified value of the cube of the input.
%   Y = rectifiedCubic(X) returns the element-wise rectified-cubic value
%   of X. For positive elements, this is the cube of the element. For
%   negative elements, this is 0.
%
%   NaN values in the input are preserved in the output.

function y = rectifiedCubic(x)

    assert(isnumeric(x), 'Input must be numeric');

    y = max(0, x.^3);

end
