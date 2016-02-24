%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_isit] = is_po(in_node, in_range)
out_isit = (in_node >= in_range.polo) & (in_node <= in_range.pohi);
end
