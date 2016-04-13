%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_signals] = regexp_signals(in_string)
out_signals = unique(regexp(in_string, '\[(\w+,)?\w+(\(\d+\))?(@[IO])?\]', 'match'));
end
