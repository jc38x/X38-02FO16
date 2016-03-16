%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_delay, out_labels, out_range, out_edges] = sample_ISE_mapped(in_flatten)
[out_delay, out_labels, out_range, out_edges] = edif2mat([mfilename('fullpath') '.edif'], in_flatten);
end
