%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_delay, out_range] = random_dag(in_npi, in_nin, in_npo, in_mind, in_maxd)
sz = in_npi + in_nin + in_npo;
out_delay = spalloc(sz, sz, (2 * in_nin) + in_npo);
inofs = in_npi;
poofs = in_npi + in_nin;
iein = zeros(1, in_nin);
oein = zeros(1, in_nin);

for spo = randperm(in_npo)
    sin = datasample(find(oein == min(oein)), 1);
    oein(sin) = oein(sin) + 1;
    new_edge(sin + inofs, spo + poofs);
end

solstop = false;
solg = [];
soliein = [];
soloein = [];

try_fill(out_delay, oein, iein);

if (~solstop), error('Imposible'); end

out_delay = solg;
iein = soliein;
oein = soloein;

takenpiin = zeros(1, in_npi);

for spi = randperm(in_npi);
    fin = find(iein < 2);
    if (isempty(fin)), error('Imposible'); end
    sin = datasample(fin, 1);
    takenpiin(spi) = sin;
    iein(sin) = iein(sin) + 1;
    new_edge(spi, sin + inofs);
end

takeninin = true(in_nin, poofs);
for i = 1:in_nin, takeninin(i, i + inofs) = false; end
for i = 1:in_npi, takeninin(takenpiin(i), i) = false; end
piin = 1:poofs;

while (~all(iein >= 2))
    fin = find(iein < 2);
    tail = datasample(fin, 1);
    head = datasample(piin(takeninin(tail, :)), 1);
    adjtail = tail + inofs;
    takeninin(tail, head) = false;
    if ((head > in_npi) && ~try_new_edge(out_delay, head, adjtail)), continue; end
    new_edge(head, adjtail);
    iein(tail) = iein(tail) + 1;
    adjhead = head - in_npi;
    if (adjhead >= 1), oein(adjhead) = oein(adjhead) + 1; end
end

%{
takeninin = cell(1, in_nin);

for i = 1:in_nin, takeninin{i} = i + inofs; end
for i = 1:in_npi
    for e = takenpiin{i}, takeninin{e} = [takeninin{e}, i]; end
end

piin = 1:(in_npi + in_nin);

while (~all(iein >= 2))
    fin = find(iein < 2);
    tail = datasample(fin, 1);
    head = datasample(setdiff(piin, takeninin{tail}), 1);
    adjtail = tail + inofs;
    takeninin{tail} = [takeninin{tail}, head];
    if ((head > in_npi) && ~try_new_edge(out_delay, head, adjtail)), continue; end
    new_edge(head, adjtail);
    iein(tail) = iein(tail) + 1;
    adjhead = head - in_npi;
    if (adjhead >= 1), oein(adjhead) = oein(adjhead) + 1; end
end
%}

i1 = 1;
in = in_npi;
v1 = in + 1;
vn = in + in_nin;
o1 = vn + 1;
on = vn + in_npo;
out_range = prepare_range(i1, in, v1, vn, o1, on);

function [out_bool] = try_new_edge(in_g, in_o, in_i)
    in_g(in_o, in_i) = 1;
    out_bool = graphisdag(in_g);
end

function [out_delay] = random_delay()
    out_delay = randi([in_mind, in_maxd]);
end

function new_edge(in_o, in_i)
    out_delay(in_o, in_i) = random_delay();
end

function try_fill(in_g, in_oein, in_iein)
    foe = find(in_oein < 1);        
    if (isempty(foe))
        solg = in_g;
        soloein = in_oein;
        soliein = in_iein;
        solstop = true;
        return;
    end

    fie = find(in_iein < 2);
    if (isempty(fie)), return; end

    for oe = foe(randperm(numel(foe)))
        for ie = fie(randperm(numel(fie)))
            if (oe == ie), continue; end
            cpg = in_g;
            adjoe = oe + inofs;
            adjie = ie + inofs;
            if (try_new_edge(cpg, adjoe, adjie))
                cpg(adjoe, adjie) = random_delay();
                cpiein = in_iein;
                cpoein = in_oein;
                cpiein(ie) = cpiein(ie) + 1;                    
                cpoein(oe) = cpoein(oe) + 1;
                try_fill(cpg, cpoein, cpiein);
                if (solstop), return; end
            end
        end
    end
end
end
