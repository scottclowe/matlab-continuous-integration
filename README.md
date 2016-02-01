[![Travis build](https://travis-ci.org/scottclowe/matlab-continuous-integration.svg?branch=master)](https://travis-ci.org/scottclowe/matlab-continuous-integration)
[![Shippable build](https://img.shields.io/shippable/565d50661895ca44742504ec/master.svg?label=shippable)](https://app.shippable.com/projects/565d50661895ca44742504ec)
[![Coveralls report](https://coveralls.io/repos/scottclowe/matlab-continuous-integration/badge.svg?branch=master&service=github)](https://coveralls.io/github/scottclowe/matlab-continuous-integration?branch=master)
[![Codecov report](https://codecov.io/github/scottclowe/matlab-continuous-integration/coverage.svg?branch=master)](https://codecov.io/github/scottclowe/matlab-continuous-integration?branch=master)

# matlab-ci

A method of doing Continuous integration on a CI server when developing in MATLAB.

Tests are run in Octave on the server using the MOxUnit package.

You can run your tests locally in MATLAB in addition to this, since the MOxUnit test framework supports both environments.
