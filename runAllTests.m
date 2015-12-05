% NB: Need to use fullfile when adding paths so that Octave plays
% nicely with MOxUnit
addpath(genpath(fullfile(pwd,'funcs')));

if true
    % Do nothing
elseif isoctave
    % Octave
    disp('Builtin octave test suite');
    runtests('./tests_octave');
else
    % Matlab
    disp('Builtin Matlab test suite');
    result = runtests(fullfile(pwd, 'funcs'), 'Recursively', true);
end

disp('MOxUnit test suite');
moxunit_runtests tests_moxunit -verbose -junitxml testresults.xml;
