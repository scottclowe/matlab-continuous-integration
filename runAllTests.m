addpath(genpath('funcs'));

if isoctave
    % Octave
    runtests('./tests_octave');
else
    % Matlab
    result = runtests(fullfile(pwd, 'funcs'), 'Recursively', true);
end
