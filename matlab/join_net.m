%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_delay, out_labels, out_range, out_equations] = join_net(in_dd, in_ld, in_rd, in_ed, in_ds, in_ls, in_rs, in_es, in_join)
offset = in_rd.sz;
jl = [in_ld, in_ls];

signal2uid = containers.Map(jl, num2cell([in_rd.all, in_rs.all + offset]));
nj = size(in_join, 2);
edges = zeros(2, nj);

for edgesindex = 1:nj, edges(:, edgesindex) = [signal2uid(in_join{1, edgesindex}); signal2uid(in_join{2, edgesindex})]; end

[id, jd] = find(in_dd);
[is, js] = find(in_ds);

if (isempty(edges))
    edgesi = [];
    edgesj = [];
else
    edgesi = edges(1, :);
    edgesj = edges(2, :);
end

sz = in_rd.sz + in_rs.sz;
uidall = 1:sz;
uidremap = C_remap([in_rd.pi, in_rs.pi + offset, in_rd.in, in_rs.in + offset, in_rd.po, in_rs.po + offset], uidall);
allremap = uidremap.remap(uidall);

out_delay = sparse(uidremap.remap([id.', is.' + offset, edgesi]), uidremap.remap([jd.', js.' + offset, edgesj]), 1, sz, sz);

out_labels = cell(1, sz);
out_labels(allremap) = jl;

out_equations = cell(1, sz);
out_equations(allremap) = [in_ed, in_es];

out_range = prepare_range(in_rd.szpi + in_rs.szpi, in_rd.szin + in_rs.szin, in_rd.szpo + in_rs.szpo);
end
