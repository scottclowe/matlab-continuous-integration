function tf = isoctave()
%ISOCTAVE  Determine if the environment is Octave
%   ISOCTAVE() true if the operating environment is Octave, otherwise
%   it returns false, indicating the environment is something else
%   (MATLAB, Scilab, FreeMat, etc).

persistent tf_cached;

if isempty(tf_cached)
  tf_cached = exist('OCTAVE_VERSION','builtin') ~= 0;
end

tf = tf_cached;

end
