%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_keys, out_cones] = generate_cones(in_order, in_iedge, in_oedge, in_range, in_K, in_DF)
out_cones = cell(1, in_range.szin);
out_keys = in_order(is_in(in_order, in_range));
pos = 0;

for in = out_keys
    iedge = in_iedge{in};
    inode = iedge(1, :);
    inpre = inode(is_in(inode, in_range));
    szin = numel(inpre);

    szcone = 1 + (4 * szin)  + (4 .^ szin);
    cones = cell(5, szcone);
    idx = 0;
    
    try_add_cone(in);
    for n = 1:szin
        all = nchoosek(inpre, n);
        for m = 1:size(all, 1)
            sel = all(m, :);
            count = ones(1, n);
            limit = zeros(1, n);
            ws = cell(1, n);
            for i = 1:n
                lc = out_cones{out_keys == sel(i)};
                ws{i} = lc(1, :);
                limit(i) = size(lc, 2);
            end
            while (count(end) <= limit(end))
                tcsz = 1;
                for i = 1:n
                    car = ws{i};
                    tcsz = tcsz + numel(car{count(i)});
                end
                tc = zeros(1, tcsz);
                tc(1) = in;
                tci = 2;
                for i = 1:n
                    car = ws{i};
                    for cae = car{count(i)}
                        tc(tci) = cae;
                        tci = tci + 1;
                    end
                end
                tc = unique(tc, 'stable');
                try_add_cone(tc);
                cni = 1;
                while (true)
                    count(cni) = count(cni) + 1;
                    if (count(cni) <= limit(cni)), break; end
                    if (cni >= n), break; end;
                    count(cni) = 1;
                    cni = cni + 1;
                end
            end
        end
    end
    if (szcone <= idx || szcone >= 1024)
    disp(['Estimado: ' num2str(szcone)]);
    disp(['Utilizado: ' num2str(idx)]);
    end
    

    cones = cones(:, 1:idx);
    rem = false(1, idx);
    for i = 1:idx
        for j = (i+1):idx, rem(j) = rem(j) || isempty(setxor(cones{1, i}, cones{2, j})); end        
    end
    pos = pos + 1;
    out_cones{pos} = cones(:, ~rem);
end

function try_add_cone(in_c)
    ie = [in_iedge{in_c}];
    iec = ismember(ie(1, :), in_c);
    iee = ~iec;
    if (numel(unique(ie(1, iee))) > in_K), return; end

    oenr = cell2mat(in_oedge(in_c(2:end)));
    if (~isempty(oenr))
        oenr(:, ismember(oenr(2, :), in_c)) = [];
        if (in_DF && ~isempty(oenr)), return; end
    end

    idx = idx + 1;

    cones{1, idx} = in_c;
    cones{2, idx} = ie(:, iec);
    cones{3, idx} = ie(:, iee);
    cones{4, idx} = in_oedge{in_c(1)};
    cones{5, idx} = oenr;
end
end
