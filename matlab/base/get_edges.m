%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_i, out_j, out_s] = get_edges(in_delay)
[i, j, s] = find(in_delay);
out_i = i.';
out_j = j.';
out_s = s.';
end