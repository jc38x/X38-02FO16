%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_delay, out_range] = random_dag(in_npi, in_nin, in_npo, in_mind, in_maxd)
sz = in_npi + in_nin + in_npo;
out_delay = spalloc(sz, sz, (2 * in_nin) + in_npo);
inofs = in_npi;
inbse = in_npi+1;
poofs = in_npi + in_nin;
iein = zeros(1, in_nin);
oein = zeros(1, in_nin);



for spo = randperm(in_npo)
    sin = datasample(find(oein == min(oein)), 1);
    out_delay(sin + inofs, spo + poofs) = random_delay();
    oein(sin) = oein(sin) + 1;
end

solstop = false;
solg = [];
soliein = [];

try_fill(out_delay, oein, iein);
if (~solstop), error('Imposible'); end

out_delay = solg;
iein = soliein;

for spi = randperm(in_npi);
    fin = find(iein < 2);
    if (isempty(fin)), error('Imposible'); end
    sin = datasample(fin, 1);    
    out_delay(spi, sin + inofs) = random_delay();
    iein(sin) = iein(sin) + 1;
end

takeninin = full(out_delay(1:(poofs), (inbse):(poofs)).' <= 0);
piin = 1:poofs;

while (~all(iein >= 2))
    fin = find(iein < 2);
    tail = datasample(fin, 1);
    available = piin(takeninin(tail, :));
    if (isempty(available))
        iein(tail) = 2;
        continue;
    end
    head = datasample(available, 1);
    adjtail = tail + inofs;
    takeninin(tail, head) = false;    
    if (~try_new_edge(out_delay, head, adjtail)), continue; end
    out_delay(head, adjtail) = random_delay();
    iein(tail) = iein(tail) + 1;
end

i1 = 1;
in = in_npi;
v1 = inbse;
vn = poofs;
o1 = vn + 1;
on = vn + in_npo;
out_range = prepare_range(i1, in, v1, vn, o1, on);

function [out_delay] = random_delay()
    out_delay = randi([in_mind, in_maxd]);
end


%function new_edge(in_o, in_i)
%    out_delay(in_o, in_i) = random_delay();
%end





%takenpiin = zeros(1, in_npi);
    %takenpiin(spi) = sin;

%{
takeninin = true(in_nin, poofs);
for i = 1:in_nin, takeninin(i, i + inofs) = false; end
for i = 1:in_npi, takeninin(takenpiin(i), i) = false; end
    %}








function [out_bool] = try_new_edge(in_g, in_o, in_i)
    if ((in_g(in_o, in_i) > 0) || (in_o == in_i))
        out_bool = false;
    elseif (in_o <= in_npi)
        out_bool = true;
    else
        in_g(in_o, in_i) = 1;
        out_bool = graphisdag(in_g);
    end
end

function try_fill(in_g, in_oein, in_iein)
    foe = find(in_oein < 1);
    if (isempty(foe))
        solg = in_g;
        soliein = in_iein;
        solstop = true;
        return;
    end

    fie = find(in_iein < 2);
    if (isempty(fie)), return; end

    for oe = foe(randperm(numel(foe)))
        for ie = fie(randperm(numel(fie)))
            adjoe = oe + inofs;
            adjie = ie + inofs;
            if (try_new_edge(in_g, adjoe, adjie))
                cpg = in_g;
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
