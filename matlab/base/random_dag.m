%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_delay, out_labels, out_range, out_equations] = random_dag(in_npi, in_nin, in_npo, in_mind, in_maxd)
poofs = in_npi + in_nin;
sz = poofs + in_npo;
inofs = in_npi;
iein = zeros(1, in_nin);
oein = zeros(1, in_nin);
out_delay = spalloc(sz, sz, (2 * in_nin) + in_npo);

for spo = randperm(in_npo)
    sin = datasample(find(oein == min(oein)), 1);
    out_delay(sin + inofs, spo + poofs) = random_delay();
    oein(sin) = oein(sin) + 1;
end

if (~try_fill()), error('Imposible.'); end

for spi = randperm(in_npi);
    fin = find(iein < 2);
    if (isempty(fin)), error('Imposible.'); end
    sin = datasample(fin, 1);    
    out_delay(spi, sin + inofs) = random_delay();
    iein(sin) = iein(sin) + 1;
end

takeninin = full(out_delay(1:(poofs), (in_npi + 1):(poofs)).' <= 0);
takeninin((1:(in_nin + 1):(in_nin ^ 2)) + (in_npi * in_nin)) = false;
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
    takeninin(tail, head) = false;
    adjtail = tail + inofs;
    out_delay(head, adjtail) = random_delay();
    if ((head > in_npi) && ~graphisdag(out_delay)), out_delay(head, adjtail) = 0; else iein(tail) = iein(tail) + 1; end
end

out_range = prepare_range(in_npi, in_nin, in_npo);
out_labels = node_labels(out_range);
out_equations = random_equations(out_delay, out_labels, out_range);

    function [out_delay] = random_delay()
    out_delay = randi([in_mind, in_maxd]);
    end

    function [out_ok] = try_fill()
    foe = find(oein < 1);
    if (isempty(foe))
        out_ok = true;
        return;
    end
    fie = find(iein < 2);
    if (isempty(fie))
        out_ok = false;
        return;
    end

    for oe = foe(randperm(numel(foe)))
        for ie = fie(randperm(numel(fie)))
            if (oe == ie), continue; end
            adjoe = oe + inofs;
            adjie = ie + inofs;
            if (out_delay(adjoe, adjie) > 0), continue; end
            out_delay(adjoe, adjie) = random_delay();
            if (graphisdag(out_delay))
                iein(ie) = iein(ie) + 1;
                oein(oe) = oein(oe) + 1;
                if (try_fill())
                    out_ok = true;
                    return;
                end
                iein(ie) = iein(ie) - 1;
                oein(oe) = oein(oe) - 1;
            end
            out_delay(adjoe, adjie) = 0;
        end
    end

    out_ok = false;
    end
end
