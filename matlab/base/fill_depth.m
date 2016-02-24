%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_depth] = fill_depth(in_order, in_iedge, in_delay, in_range)
out_depth = zeros(1, in_range.sz);
for v = in_order
    for e = in_iedge{v}
        idx = e(1);
        d = out_depth(idx) + in_delay(idx, v);
        if (d > out_depth(v)), out_depth(v) = d; end
    end
end
end
