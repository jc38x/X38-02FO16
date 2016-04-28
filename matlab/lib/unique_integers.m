%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_nodes] = unique_integers(in_vector)
out_nodes = sort(in_vector);
out_nodes = out_nodes([true, diff(out_nodes) ~= 0]);
end
