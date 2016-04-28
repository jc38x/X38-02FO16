%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************
% References
% 10.1109/TCAD.2006.882119
%**************************************************************************

function [out_af, out_noedge] = fill_af(in_delay, in_range)
out_af     = zeros(1, in_range.sz);
out_noedge = zeros(1, in_range.sz);
for v = get_order(in_delay)
    Av = double(is_in(v, in_range));
    for e = get_inode(in_delay, v)
        out_noedge(e) = numel(get_onode(in_delay, e));
        Av = Av + (out_af(e) / out_noedge(e));
    end
    out_af(v) = Av;
end
end
