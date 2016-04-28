%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_cones] = generate_cones(in_range, in_K, in_delay)
scones = cell(1, in_range.sz);
ncones = zeros(1, in_range.sz);
out_cones = cell(1, in_range.sz);
allcones = [];
subindex = 0;

    %nodemarker = false(1, in_range.sz);
    
    
    
    
    
    
    
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
    
    scones{in} = cell_collapse(cones(1:index));
    ncones(in) = numel(scones{in});
end

[di, dj] = get_edges(in_delay);
edges = [di; dj];
edgemarker = false(size(di));

for in = in_range.in
    totalcones = ncones(in);
    rawcones = scones{in};
    fcone = cell(5, totalcones);

    for n = 1:totalcones
        cone = rawcones{n};

        head = edgemarker;
        tail = edgemarker;
        
        for node = cone,
            head = head | (di == node);
            tail = tail | (dj == node);
        end

        rout = di == cone(end);
        
        fcone{1, n} = cone;
        fcone{2, n} = edges(:,  head &  tail);
        fcone{3, n} = edges(:, ~head &  tail);
        fcone{4, n} = edges(:,          rout);
        fcone{5, n} = edges(:,  head & ~rout & ~tail);
    end

    out_cones{in} = fcone;
end

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
        nrc = scones{in_nr};
        allcones = cell(1, nnc);
        for k = 1:nnc, push_cone(sort([in, nrc{k}])); end
    case 2
        nr1 = in_nr(1);
        nr2 = in_nr(2);
        
        nnc1 = ncones(nr1);
        nrc1 = scones{nr1};
        v1 = 1:nnc1;
        
        keep1 = true(1, nnc1);
        for k = v1, keep1(k) = ~any(get_inode(in_delay, nrc1{k}) == nr2); end

        nnc2 = ncones(nr2);
        nrc2 = scones{nr2};
        v2 = 1:nnc2;
        
        keep2 = true(1, nnc2);
        for k = v2, keep2(k) = ~any(get_inode(in_delay, nrc2{k}) == nr1); end
        
        allcones = cell(1, sum(keep1) * sum(keep2));
        
        for k = v1(keep1)
            for l = v2(keep2), push_cone(unique_integers([in, nrc1{k}, nrc2{l}])); end%, nodemarker, in_range.all)); end
        end
        
        allcones = uniqueRowsCAvs(allcones(1:subindex).').';
        subindex = numel(allcones);
    otherwise
        error('Only 2-bounded networks are supported.');
    end
    
    index = index + 1;
    cones{index} = allcones(1:subindex);
    end
end
