%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_onode] = get_onode(in_delay, in_node)
out_onode = find(sum(in_delay(in_node, :), 1));
end
