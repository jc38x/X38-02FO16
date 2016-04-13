%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_inputs] = tt_inputs(in_npi)
out_inputs = num2cell(repmat([1, 0], in_npi, 1), 2);
out_inputs = combvec(out_inputs{:});
end
