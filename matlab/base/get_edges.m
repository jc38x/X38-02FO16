%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_i, out_j, out_s] = get_edges(in_delay)
[out_i, out_j, out_s] = find(in_delay);
out_i = out_i.';
out_j = out_j.';
out_s = out_s.';
end
