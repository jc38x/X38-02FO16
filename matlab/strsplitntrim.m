
function [out_str] = strsplitntrim(in_str, in_delimiters)
split = textscan(in_str,'%s','delimiter',in_delimiters,'multipleDelimsAsOne',1);
split = split{1};
out_str = strtrim(split);
end
