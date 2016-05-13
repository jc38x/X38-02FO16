%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_cones] = generate_cones2(in_delay, in_range, in_K)
out_cones = cell(1, in_range.sz);
[di, dj] = get_edges(in_delay);
edges = [di; dj];
maxcones = 1000;

scones =  cell(1, in_range.sz);
ncones = zeros(1, in_range.sz);
pcones = zeros(1, in_range.sz);
allcones = [];
subindex = 0;

scones(in_range.top) = {{[]}};



for in = get_inorder(in_delay, in_range)
    inode = get_inode(in_delay, in);
    %inpre = inode(is_in(inode, in_range));
    %szin = numel(inpre);
    
    
    switch (numel(inode))
    case 0
        scones{in} = {in};
    case 1
        switch (double(is_in(inode, in_range)))
        case 0, scones{in} =  {in};
        case 1, scones{in} = [{in}, cellfun(@(x)horzcat(x, in), scones{inode   }, 'UniformOutput', false)];
        end
    case 2
        switch (2 * double(is_in(inode(2), in_range)) + double(is_in(inode(1), in_range)))
        case 0, abc =  {in};
        case 1, abc = [{in}, cellfun(@(x)horzcat(x, in), scones{inode(1)}, 'UniformOutput', false)];                
        case 2, abc = [{in}, cellfun(@(x)horzcat(x, in), scones{inode(2)}, 'UniformOutput', false)];
        case 3
            ac = [{[]}, scones{inode(1)}];
            bc = [{[]}, scones{inode(2)}];
            [ai, bi] = ndgrid(1:(ncones(inode(1)) + 1), 1:(ncones(inode(2)) + 1));
            abc = cellfun(@(x, y)unique_integers(horzcat(x, y, in)), ac(ai(:)), bc(bi(:)), 'UniformOutput', false);
            abc = uniqueRowsCAvs(abc.').';
        end
        %scones{in} = abc(cell_collapse(cellfun(@test_K, abc, 'UniformOutput', false)));
        scones{in} = abc;
    otherwise
        error('Only 2-bounded networks are supported.');
    end
    
    ncones(in) = numel(scones{in});
    
    
    %{
    szall = 1;
    for n = 1:szin, szall = szall + nchoosek(szin, n); end
    cones = cell(1, szall);
    index = 0;
    
    add_cone([]);
    for n = fliplr(1:szin)
        parall = nchoosek(inpre, n);
        for m = 1:size(parall, 1), add_cone(parall(m, :)); end
    end
    
    scones{in} = cell_collapse(cones(1:index));
    ncones(in) = numel(scones{in});
    %}
    
    
    
    
    
    rawcones = scones{in};
    totalcones = ncones(in);
    fcone = cell(5, totalcones);

    for n = 1:totalcones
        cone = rawcones{n};
        head = integer_ismember(di, cone);
        rout = di == cone(end);
        tail = integer_ismember(dj, cone);
        
        fcone{1, n} = cone;
        fcone{2, n} = edges(:,  head &          tail);
        fcone{3, n} = edges(:, ~head &          tail);
        fcone{4, n} = edges(:,          rout);
        fcone{5, n} = edges(:,  head & ~rout & ~tail);
    end

    out_cones{in} = fcone;
end

    function [out_ok] = test_K(in_c)
    iee = sum(in_delay(:, in_c), 2);
    iee(in_c) = 0;
    out_ok = numel(find(iee)) <= in_K;%nnz(iee) <= in_K;
    end
%{
    function push_cone(in_c)
    iee = sum(in_delay(:, in_c), 2);
    iee(in_c) = 0;
    if (nnz(iee) > in_K), return; end
    subindex = subindex + 1;
    allcones{subindex} = in_c;
    end





    function add_cone(in_nr)
    subindex = 0;
    %if (ncones(in) >= maxcones), return; end
    
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
            for l = v2(keep2), push_cone(unique_integers([in, nrc1{k}, nrc2{l}])); end
        end
        
        allcones = uniqueRowsCAvs(allcones(1:subindex).').';
        subindex = numel(allcones);
    otherwise
        error('Only 2-bounded networks are supported.');
    end
    
    index = index + 1;
    cones{index} = allcones(1:subindex);
    end
%}
end
