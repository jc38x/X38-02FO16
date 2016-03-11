%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_str] = strsplitntrim(in_str, in_delimiters)
split = textscan(in_str, '%s', 'delimiter', in_delimiters);
split = split{1};
out_str = strtrim(split);
end
