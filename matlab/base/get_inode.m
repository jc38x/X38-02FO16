%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_inode] = get_inode(in_delay, in_node)
out_inode = find(in_delay(:, in_node).');
end
