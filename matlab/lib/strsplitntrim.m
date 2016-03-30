%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************
% References
% http://stackoverflow.com/questions/5286420/how-to-vectorize-this-string-split-function-in-matlab
%**************************************************************************

function [out_str] = strsplitntrim(in_str, in_delimiters)
out_str = textscan(in_str, '%s', 'delimiter', in_delimiters, 'MultipleDelimsAsOne', 1);
out_str = strtrim(out_str{:});
end
