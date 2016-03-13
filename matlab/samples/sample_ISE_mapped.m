%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_delay, out_labels, out_range] = sample_ISE_mapped()
[out_delay, out_labels, out_range] = edif2mat([mfilename('fullpath') '.edif'], false);
end
