if isoctave
    % Octave
    runtests('./');
else
    % Matlab
    result = runtests(pwd, 'Recursively', true);
end