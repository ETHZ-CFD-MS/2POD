function varargout = run_tests()
%RUN_TESTS Summary of this function goes here
%   Detailed explanation goes here

import matlab.unittest.TestSuite;

dir_test = [pwd filesep 'tests'];
suite = TestSuite.fromFolder(dir_test);
results = suite.run();
varargout{1} = results;
end

