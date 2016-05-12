%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_delay, out_labels, out_range, out_equations] = group_nets(in_dl, in_ll, in_rl, in_el)
n = numel(in_dl);
offset = zeros(1, n);
nets = 1:n;

mapi  = cell(1, n);
mapj  = cell(1, n);
maps  = cell(1, n);
mappi = cell(1, n);
mapin = cell(1, n);
mappo = cell(1, n);

sz   = 0;
szpi = 0;
szin = 0;
szpo = 0;

for k = 1:(n - 1), offset(k + 1) = offset(k) + in_rl{k}.sz; end

for k = nets
    [di, dj, ds] = get_edges(in_dl{k});
    bp = offset(k);
    
    mapi{k} = di + bp;
    mapj{k} = dj + bp;
    maps{k} = ds;

    r = in_rl{k};
    
    sz   = sz   + r.sz;
    szpi = szpi + r.szpi;
    szin = szin + r.szin;
    szpo = szpo + r.szpo;

    mappi{k} = r.pi + bp;
    mapin{k} = r.in + bp;
    mappo{k} = r.po + bp;
end

uidall = 1:sz;
uidremap = C_remap([cell_collapse(mappi), cell_collapse(mapin), cell_collapse(mappo)], uidall);
allremap = uidremap.remap(uidall);

out_delay = sparse(uidremap.remap(cell_collapse(mapi)), uidremap.remap(cell_collapse(mapj)), cell_collapse(maps), sz, sz);
out_labels = cell(1, sz);
out_labels(allremap) = cell_collapse(in_ll);
out_equations = cell(1, sz);
out_equations(allremap) = cell_collapse(in_el);
out_range = prepare_range(szpi, szin, szpo);
end
