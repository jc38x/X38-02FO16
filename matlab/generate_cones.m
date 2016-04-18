%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_cones] = generate_cones(in_inorder, in_iedge, in_oedge, in_range, in_K)
out_cones = cell(1, in_range.szin);
ncones = zeros(1, in_range.szin);


for in = in_inorder
    
    
    
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
    
    cones = cones(1:index);
    out_cones{adjin} = cell_collapse(cones);
end
    
    
    


    function add_cone(nr)
    if (isempty(nr))
        index = index + 1;
        allcones = cell(1, 1);
        allcones{1} = in;
        cones{index} = allcones;
        ncones(adjin) = ncones(adjin) + 1;
    else
        nr = nr - in_range.szpi;
        total = prod(ncones(nr));
        allcones = cell(1, total);
        subindex = 0;
        
        vec = cell(1, numel(nr));
        for k = 1:numel(nr), vec{k} = 1:ncones(nr(k)); end
        offset = zeros(numel(nr), 1);
        for k = 1:(numel(nr) - 1), offset(k + 1) = offset(k) + ncones(nr(k)); end
        
        nrcones = cell_collapse(out_cones(nr));
        for c = combvec(vec{:})
            s = c + offset;
            %s
            %numel(nrcones)
            subindex = subindex + 1;
            allcones{subindex} = [in, [nrcones{s}]];
        end
        
        
        
        
        allcones = allcones(1:subindex);
        index = index + 1;
        cones{index} = allcones;
        
        ncones(adjin) = ncones(adjin) + subindex;
    end
    
    
    
    
        
    
    end



     %for k = 1:index
   %     c = cones(k);
        
    %end
 %{
    total = index * prod(ncones(inpre));
    
    
    
    
    allcones = cell(1, total);
    allindex = 0;
    
    vec = cell(1, szin);
    for n = 1:szin, vec{n} = 1:ncones(inpre); end    
    nrcones = cell_collapse(out_cones(inpre));
    
    for c = combvec(vec{:})
    end
    %}
    
    
    %nrcones = ;
    %[nrcones{:}];
    

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
