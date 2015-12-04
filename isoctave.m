function tf = isoctave()
%ISOCTAVE  Determine if the environment is Octave
%   ISOCTAVE() true if the operating environment is Octave, otherwise
%   it returns false, indicating the environment is something else
%   (MATLAB, Scilab, FreeMat, etc).

persistent tf_;

if isempty(tf_)
  tf_ = exist('OCTAVE_VERSION','builtin') ~= 0;
end

tf = tf_;

end