%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************
% References
% http://fmv.jku.at/aiger/
%**************************************************************************

function [out_delay, out_labels, out_range] = sample_aaglatch()
[out_delay, out_labels, out_range] = aag2mat([mfilename('fullpath') '.aag']);
end
