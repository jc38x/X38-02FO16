%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_isit] = is_in(in_node, in_range)
out_isit = (in_node >= in_range.inlo) & (in_node <= in_range.inhi);
end
