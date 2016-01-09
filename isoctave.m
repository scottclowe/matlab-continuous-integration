%ISOCTAVE  Determine if the environment is Octave
%   ISOCTAVE() true if the operating environment is Octave, otherwise
%   it returns false, indicating the environment is something else
%   (MATLAB, Scilab, FreeMat, etc).
function tf = isoctave()

    % Cache the value because it can't change
    persistent tf_cached;

    % If this is the first call, check if we are in octave.
    % We can tell because the 'OCTAVE_VERSION' function will exist.
    if isempty(tf_cached)
      tf_cached = exist('OCTAVE_VERSION','builtin') ~= 0;
    end

    % Set the return value equal to the cached value
    tf = tf_cached;

end
