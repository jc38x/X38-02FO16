
function [out_str] = strremovespaces(in_str)
out_str = in_str(~isspace(in_str));
end
