%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_cones] = generate_cones(in_inorder, in_iedge, in_oedge, in_range, in_K, in_delay)
out_cones = cell(1, in_range.szin);
ncones = zeros(1, in_range.szin);

allcones = [];
subindex = 0;

    nodemarker = false(1, in_range.sz);
    %nodestring = strtrim(cellstr(num2str(in_range.all.')).');
    %for n = 1:numel(nodestring), nodestring{n} = [nodestring{n} '.']; end
    prune = 0;
    dup = 0;
    kcut = 0;
    
    %add_cone = @add_cone_2input;

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
    
    
    
    
    out_cones{adjin} = cell_collapse(cones(1:index));
    ncones(adjin) = numel(out_cones{adjin});
end
    



    prune
    dup
    kcut
    

    function [out_cone] = unique_nodes(in_c)
    pick = nodemarker;
    pick(in_c) = true;
    out_cone = in_range.all(pick);
    end


%cones = cell_collapse(cones(1:index));
    %nc = numel(cones);
    %keep = true(1, nc);
    %for n = 1:nc, keep(n) = test_k(cones{n}); end
    %cones(keep);
    %function [out_ok] = test_k(in_c)
    %iee = sum(in_delay(:, in_c), 2) > 0;
    %iee(in_c) = 0;
    %out_ok = sum(iee) <= in_K;
    %end

    function push_cone(in_c)
    iee = sum(in_delay(:, in_c), 2) > 0;
    iee(in_c) = 0;

    if (sum(iee) > in_K)
        kcut = kcut + 1;
        return;
    end

    subindex = subindex + 1;
    allcones{subindex} = in_c;
    end


    


    function add_cone(in_nr)
    nnr = numel(in_nr);
    subindex = 0;
    
    switch (nnr)
    case 0
        allcones = cell(1, 1);
        push_cone(in);
    case 1
        nr = in_nr - in_range.szpi;
        nnc = ncones(nr);
        nrc = out_cones{nr};
        allcones = cell(1, nnc);
        for k = 1:nnc, push_cone(unique_nodes([in, nrc{k}])); end
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
            for l = v2(keep2), push_cone(unique_nodes([in, nrc1{k}, nrc2{l}])); end
        end
        
        allcones = uniqueRowsCAvs(allcones(1:subindex).').';
        newsubindex = numel(allcones);
        dup = dup + subindex - newsubindex;
        subindex = newsubindex;
    otherwise
        error('Only 2-bounded networks are supported.');
    end
    
    index = index + 1;
    cones{index} = allcones(1:subindex);
    end







%{
    function add_cone_generic(in_nr)
    nnr = numel(in_nr);
    subindex = 0;
    
    if (nnr == 0)
        allcones = cell(1, 1);
        try_add_cone(in);
    else
        vec = cell(1, nnr);
        offset = zeros(nnr, 1);
        adjnr = in_nr - in_range.szpi;
        nrc = cell_collapse(out_cones(adjnr));
        allcones = cell(1, prod(ncones(adjnr)));
        
        for k = 1:nnr, vec{k} = 1:ncones(adjnr(k)); end
        for k = 1:(nnr - 1), offset(k + 1) = offset(k) + ncones(adjnr(k)); end
        
        for combo = combvec(vec{:}), try_add_cone(unique_nodes([in, [nrc{combo + offset}]])); end
    end

    index = index + 1;
    cones{index} = allcones(1:subindex);
    ncones(adjin) = ncones(adjin) + subindex;
    end
%}
%function push_cone_list()
    
    %end
%{
        
            %}

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
