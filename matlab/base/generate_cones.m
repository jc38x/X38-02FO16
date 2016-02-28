%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_keys, out_cones] = generate_cones(in_order, in_iedge, in_oedge, in_range, in_K, in_DF)
inofs = in_range.szpi;
numelcones = ones(1, in_range.szin);
dupmap = containers.Map();
stack = false(1, in_range.sz);
out_cones = cell(1, in_range.szin);
out_keys = in_order(is_in(in_order, in_range));

for in = out_keys    
    iedge = in_iedge{in};
    inode = iedge(1, :);
    inpre = inode(is_in(inode, in_range));
    szin = numel(inpre);
    
    szall = 1;
    for n = 1:szin, szall = szall + nchoosek(szin, n); end
    all = cell(1, szall);
    
    all{1} = in;
    index = 1;
    for n = 1:szin
        parall = nchoosek(inpre, n);
        for m = 1:size(parall, 1)
            index = index + 1;
            all{index} = [in, parall(m, :)];
        end
    end
    
    szcones = 1;
    suball = all(2:end);
    for n = suball, szcones = szcones + prod(numelcones(n{1}(2:end) - inofs)); end
    cones = cell(5, szcones);
    index = 0;
    
    try_add_cone(all{1});
    for n = suball
        subcones = n{1}(2:end);
        szsc = numel(subcones);
        adjsc = subcones - inofs;
        selection = out_cones(adjsc);
        counter = ones(1, szsc);
        limit = numelcones(adjsc);
        
        while (counter(end) <= limit(end))
            stack = xor(stack, stack);
            for m = 1:szsc
                for e = selection{m}{1,counter(m)}, stack(e) = true; end
            end
            
            cid = 1;
            counter(1) = counter(1) + 1;
            while ((counter(cid) > limit(cid)) && (cid < szsc))
                counter(cid) = 1;
                cid = cid + 1;
                counter(cid) = counter(cid) + 1;
            end
            
            cone = unique([in, in_range.all(stack)]);
            key = char(cone);
            if (dupmap.isKey(key)), continue; end
            dupmap(key) = 1;
            try_add_cone(cone);
        end
    end

    cones = cones(:, 1:index);
    adjin = in - inofs;
    out_cones{adjin} = cones;
    numelcones(adjin) = index;
end

function try_add_cone(in_c)
    ie = [in_iedge{in_c}];
	iec = ismembc(ie(1, :), in_c);
    iee = ~iec;
    if (numel(unique(ie(1, iee))) > in_K), return; end

    nroot = in_c ~= in;
    oenr = cell2mat(in_oedge(in_c(nroot)));
    if (~isempty(oenr))
        oenr(:, ismembc(oenr(2, :), in_c)) = [];
        if (in_DF && ~isempty(oenr)), return; end
    end

    index = index + 1;
    
    cones{1, index} = [in, in_c(nroot)];
    cones{2, index} = ie(:, iec);
    cones{3, index} = ie(:, iee);
    cones{4, index} = in_oedge{in};
    cones{5, index} = oenr;
end
end
