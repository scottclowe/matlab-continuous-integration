% NB: Need to use fullfile when adding paths so that Octave plays
% nicely with MOxUnit
addpath(genpath(fullfile(pwd,'funcs')));

if isoctave
    % Octave
    runtests('./tests_octave');
else
    % Matlab
    result = runtests(fullfile(pwd, 'funcs'), 'Recursively', true);
end
