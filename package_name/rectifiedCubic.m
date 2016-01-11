function y = rectifiedCubic(x)
% Returns the rectified value of the cube of X.
% If X is positive, this is the cube of X, if X is negative it is 0.

assert(isnumeric(x), 'Input must be numeric');

y = max(0, x.^3);

end
