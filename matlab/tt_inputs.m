%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_inputs] = tt_inputs(in_npi, in_filter)
out_inputs = num2cell(repmat([1, 0], in_npi, 1), 2);
out_inputs = combvec(out_inputs{:});
if (~isempty(in_filter)), out_inputs = out_inputs(:, in_filter); end
end
