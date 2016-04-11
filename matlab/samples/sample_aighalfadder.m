%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************
% References
% http://fmv.jku.at/aiger/
%**************************************************************************

function [out_delay, out_labels, out_range, out_equations] = sample_aighalfadder()
[out_delay, out_labels, out_range, out_equations] = aiger2mat([mfilename('fullpath') '.aig']);
end
