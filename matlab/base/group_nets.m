%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_delay, out_labels, out_range, out_equations] = group_nets(in_dl, in_ll, in_rl, in_el)
n = numel(in_dl);
offset = zeros(1, n);
nets = 1:n;

mapi  = containers.Map('KeyType', 'double', 'ValueType', 'any');
mapj  = containers.Map('KeyType', 'double', 'ValueType', 'any');
mappi = containers.Map('KeyType', 'double', 'ValueType', 'any');
mapin = containers.Map('KeyType', 'double', 'ValueType', 'any');
mappo = containers.Map('KeyType', 'double', 'ValueType', 'any');

sz   = 0;
szpi = 0;
szin = 0;
szpo = 0;

for k = 1:(n - 1), offset(k + 1) = in_rl{k}.sz; end

for k = nets
    [di, dj] = find(in_dl{k});
    bp = offset(k);
    
    mapi(k) = di.' + bp;
    mapj(k) = dj.' + bp;
    
    r = in_rl{k};
    
    sz   = sz   + r.sz;
    szpi = szpi + r.szpi;
    szin = szin + r.szin;
    szpo = szpo + r.szpo;
    
    mappi(k) = r.pi + bp;
    mapin(k) = r.in + bp;
    mappo(k) = r.po + bp;
end

uidall = 1:sz;
keys = num2cell(nets);

pi = mappi.values(keys);
in = mapin.values(keys);
po = mappo.values(keys);

uidremap = C_remap([[pi{:}], [in{:}], [po{:}]], uidall);
allremap = uidremap.remap(uidall);

i = mapi.values(keys);
j = mapj.values(keys);

out_delay = sparse(uidremap.remap([i{:}]), uidremap.remap([j{:}]), 1, sz, sz);

out_labels = cell(1, sz);
out_labels(allremap) = [in_ll{:}];

out_equations = cell(1, sz);
out_equations(allremap) = [in_el{:}];

out_range = prepare_range(szpi, szin, szpo);
end
