%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_iedge, out_oedge] = fill_edges(in_delay, in_range)
out_iedge = cell(1, in_range.sz);
out_oedge = cell(1, in_range.sz);

for n = in_range.all
    nv = get_inode(in_delay, n); 
    out_iedge{n} = [nv; repmat(n, 1, numel(nv))];
    nv = get_onode(in_delay, n);
    out_oedge{n} = [repmat(n, 1, numel(nv)); nv];
end
end
