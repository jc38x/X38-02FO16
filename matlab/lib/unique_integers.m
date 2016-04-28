%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_nodes] = unique_integers(in_vector, in_marker, in_map)
marker = in_marker;
marker(in_vector) = true;
out_nodes = in_map(marker);
end
