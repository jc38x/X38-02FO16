%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_index] = flatten_index_2d(in_i, in_j, in_rows)
out_index = sum([in_i; (in_j - 1) * in_rows], 1);
end
