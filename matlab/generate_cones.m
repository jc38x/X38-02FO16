%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_cones] = generate_cones(in_inorder, in_iedge, in_oedge, in_range, in_K, in_delay)
out_cones = cell(1, in_range.szin);
ncones = zeros(1, in_range.szin);


    nodemarker = false(1, in_range.sz);
    nodestring = strtrim(cellstr(num2str(in_range.all.')).');
    for n = 1:numel(nodestring), nodestring{n} = [nodestring{n} '.']; end
    prune = 0;
    dup = 0;
    kcut = 0;

for in = in_inorder
    %conemap = containers.Map();
    %conelist = [];
    
    
    iedge = in_iedge{in};
    inode = iedge(1, :);
    inpre = inode(is_in(inode, in_range));
    szin = numel(inpre);
    adjin = in - in_range.szpi;
    
    szall = 1;
    for n = 1:szin, szall = szall + nchoosek(szin, n); end
    cones = cell(1, szall);
    index = 0;
    
    add_cone([]);
    for n = 1:szin
        parall = nchoosek(inpre, n);
        for m = 1:size(parall, 1), add_cone(parall(m, :)); end
    end
    
    
    scones = cell_collapse(cones(1:index));
    %sortc = zeros(1, ncones(adjin));
    %for n = 1:ncones(adjin), sortc(n) = numel(scones{n}); end
    %[~, sortc] = sort(sortc);
    
    
    out_cones{adjin} = scones;%scones(sortc);
    %ncones(adjin) = numel(scones);
end
    

checkmap = containers.Map();
for n = 1:in_range.szin
    c = out_cones{n};
    for m = 1:numel(c)
        key = [nodestring{c{m}}];
        if (checkmap.isKey(key)), disp(['DUP: ' num2str(checkmap(key)) ' : ' num2str([n, m])]); end
        checkmap(key) = [n, m];
    end
end

    prune
    dup
    kcut
    


    function add_cone(in_nr)
    nnr = numel(in_nr);
    subindex = 0;
    
    switch (nnr)
    case 0
        allcones = cell(1, 1);
        try_add_cone(in);
    case 1
        nr = in_nr - in_range.szpi;
        nnc = ncones(nr);
        nrc = out_cones{nr};
        allcones = cell(1, nnc);
        for k = 1:nnc, try_add_cone(unique_nodes([in, nrc{k}])); end
    case 2
        nr1 = in_nr(1);
        nr2 = in_nr(2);

        adjnr1 = nr1 - in_range.szpi;
        nnc1 = ncones(adjnr1);
        nrc1 = out_cones{adjnr1};
        v1 = 1:nnc1;
        
        keep1 = true(1, nnc1);
        for k = v1, keep1(k) = ~any(get_inode(in_delay, nrc1{k}) == nr2); end
        
        adjnr2 = nr2 - in_range.szpi;
        nnc2 = ncones(adjnr2);
        nrc2 = out_cones{adjnr2};
        v2 = 1:nnc2;
        
        keep2 = true(1, nnc2);
        for k = v2, keep2(k) = ~any(get_inode(in_delay, nrc2{k}) == nr1); end
        
        nnc = sum(keep1) * sum(keep2);
        prune = prune + (nnc1 * nnc2) - nnc;
        allcones = cell(1, nnc);
        
        for k = v1(keep1)
            for l = v2(keep2), try_add_cone(unique_nodes([in, nrc1{k}, nrc2{l}])); end
        end
        
        trim_cones();
    otherwise
        error('Unsupported operation.');
    end
    
    index = index + 1;
    cones{index} = allcones(1:subindex);
    ncones(adjin) = ncones(adjin) + subindex;
    
        function [out_cone] = unique_nodes(in_c)
        pick = nodemarker;
        pick(in_c) = true;
        out_cone = in_range.all(pick);
        end

        function trim_cones()
        testcones = allcones(1:subindex);
        nc = zeros(1, subindex);
        prevsubindex = subindex;
        allcones = cell(1, subindex);
        subindex = 0;
        
        for j = 1:prevsubindex, nc(j) = numel(testcones{j}); end
        
        for j = unique(nc)
            tc = uniqueRowsCA(testcones(nc == j).');
            ntc = numel(tc);
            allcones((1:ntc) + subindex) = tc.';
            subindex = subindex + ntc;
        end
        
        dup = dup + prevsubindex - subindex;
        end
        
        function try_add_cone(in_c)
        iee = sum(in_delay(:, in_c), 2) > 0;
        iee(in_c) = 0;
        
        if (sum(iee) > in_K)
            kcut = kcut + 1;
            return;
        end
        
        subindex = subindex + 1;
        allcones{subindex} = in_c;
        end
    end






%{
    function add_cone(in_c)
    ie = [in_iedge{in_c}];
    iec = ismember(ie(1, :), in_c);
    iee = ~iec;
    
    oenr = [in_oedge{in_c(in_c ~= in)}];
    if (~isempty(oenr)), oenr(:, ismember(oenr(2, :), in_c)) = []; end
    
    index = index + 1;

    cones{1, index} = in_c;
    cones{2, index} = ie(:, iec);
    cones{3, index} = ie(:, iee);
    cones{4, index} = in_oedge{in};
    cones{5, index} = oenr;
    end
%}



%{
function try_add_cone(in_c)
    ie = [in_iedge{in_c}];
    iec = ismembc(ie(1, :), in_c);
    iee = ~iec;
    if (numel(unique(ie(1, iee))) > in_K), return; end

    nroot = in_c ~= in;
    oenr = cell2mat(in_oedge(in_c(nroot)));
    if (~isempty(oenr)), oenr(:, ismembc(oenr(2, :), in_c)) = []; end

    index = index + 1;

    cones{1, index} = [in, in_c(nroot)];
    cones{2, index} = ie(:, iec);
    cones{3, index} = ie(:, iee);
    cones{4, index} = in_oedge{in};
    cones{5, index} = oenr;
end
%}
end
