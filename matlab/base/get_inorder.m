%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_inorder] = get_inorder(in_delay, in_range)
out_inorder = get_order(in_delay);
out_inorder = out_inorder(is_in(out_inorder, in_range));
end
