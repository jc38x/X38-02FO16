%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_depth] = fill_depth(in_delay, in_range)
out_depth = zeros(1, in_range.sz);
for v = get_order(in_delay);
    for e = get_inode(in_delay, v)
        d = out_depth(e) + in_delay(e, v);
        if (d > out_depth(v)), out_depth(v) = d; end
    end
end
end
