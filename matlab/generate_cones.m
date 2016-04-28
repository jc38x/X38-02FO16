%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_cones] = generate_cones(in_inorder, in_iedge, in_oedge, in_range, in_K, in_delay)
out_cones = cell(1, in_range.sz);%in_range.szin);
ncones = zeros(1, in_range.sz);%in_range.szin);

allcones = [];
subindex = 0;

    nodemarker = false(1, in_range.sz);
    
    %prune = 0;
    %dup = 0;
    %kcut = 0;
    
    
    
    
    
    
for in = get_inorder(in_delay, in_range)
    inode = get_inode(in_delay, in);
    inpre = inode(is_in(inode, in_range));
    szin = numel(inpre);
    
    szall = 1;
    for n = 1:szin, szall = szall + nchoosek(szin, n); end
    cones = cell(1, szall);
    index = 0;
    
    add_cone([]);
    for n = 1:szin
        parall = nchoosek(inpre, n);
        for m = 1:size(parall, 1), add_cone(parall(m, :)); end
    end
    
    out_cones{in} = cell_collapse(cones(1:index));
    ncones(in) = numel(out_cones{in});
end
    





    %mean(ncones)
    %max(ncones)

    %prune
    %dup
    %kcut
    

    %function [out_cone] = unique_nodes(in_c)
    %pick = nodemarker;
    %pick(in_c) = true;
    %out_cone = in_range.all(pick);
    %end




    


    
    function push_cone(in_c)
    iee = sum(in_delay(:, in_c), 2);
    iee(in_c) = 0;
    if (nnz(iee) > in_K), return; end
    subindex = subindex + 1;
    allcones{subindex} = in_c;
    end

    function add_cone(in_nr)
    subindex = 0;
    
    switch (numel(in_nr))
    case 0
        allcones = cell(1, 1);
        push_cone(in);
    case 1        
        nnc = ncones(in_nr);
        nrc = out_cones{in_nr};
        allcones = cell(1, nnc);
        for k = 1:nnc, push_cone(sort([in, nrc{k}])); end
    case 2
        nr1 = in_nr(1);
        nr2 = in_nr(2);
        
        nnc1 = ncones(nr1);
        nrc1 = out_cones{nr1};
        v1 = 1:nnc1;
        
        keep1 = true(1, nnc1);
        for k = v1, keep1(k) = ~any(get_inode(in_delay, nrc1{k}) == nr2); end

        nnc2 = ncones(nr2);
        nrc2 = out_cones{nr2};
        v2 = 1:nnc2;
        
        keep2 = true(1, nnc2);
        for k = v2, keep2(k) = ~any(get_inode(in_delay, nrc2{k}) == nr1); end
        
        allcones = cell(1, sum(keep1) * sum(keep2));
        
        for k = v1(keep1)
            for l = v2(keep2), push_cone(unique_integers([in, nrc1{k}, nrc2{l}], nodemarker, in_range.all)); end
        end
        
        allcones = uniqueRowsCAvs(allcones(1:subindex).').';
        subindex = numel(allcones);
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
