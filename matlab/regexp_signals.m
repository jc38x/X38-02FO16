%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_signals] = regexp_signals(in_string)%, in_sorted, in_trim)
%if (in_sorted), order = 'sorted'; else order ='stable'; end
out_signals = unique(regexp(in_string, '\[(\w+,)?\w+(\(\d+\))?(@[IO])?\]', 'match'));%, order);
%if (in_trim), out_signals = regexprep(out_signals, '[\[\]]', ''); end
end
