%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_iedge, out_oedge, out_inode, out_onode] = prepare_edges(in_delay, in_range)
out_iedge = cell(1, in_range.sz);
out_oedge = cell(1, in_range.sz);
out_inode = cell(1, in_range.sz);
out_onode = cell(1, in_range.sz);
for n = in_range.all
    nv = find(in_delay(:, n).');
    out_inode{n} = nv;
    out_iedge{n} = [nv; repmat(n, 1, numel(nv))];
    nv = find(in_delay(n, :));
    out_onode{n} = nv;
    out_oedge{n} = [repmat(n, 1, numel(nv)); nv];
end
end
