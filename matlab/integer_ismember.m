%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_test] = integer_ismember(in_testee, in_tester)
out_test = false(size(in_testee));
for i = in_tester, out_test = or(out_test, in_testee == i); end
end
