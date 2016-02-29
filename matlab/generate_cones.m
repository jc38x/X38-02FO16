%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_insort, out_cones] = generate_cones(in_order, in_iedge, in_oedge, in_range, in_K)
out_cones = cell(1, in_range.szin);
out_insort = in_order(is_in(in_order, in_range));

for in = out_insort
    iedge = in_iedge{in};
    inode = iedge(1, :);
    inpre = inode(is_in(inode, in_range));
    szin = numel(inpre);
    
    szall = 1;
    for n = 1:szin, szall = szall + nchoosek(szin, n); end
    cones = cell(5, szall);
    index = 0;
    
    try_add_cone(in);
    for n = 1:szin
        parall = nchoosek(inpre, n);
        for m = 1:size(parall, 1), try_add_cone(sort([in, parall(m, :)])); end
    end
    
    cones = cones(:, 1:index);
    out_cones{in - in_range.szpi} = cones;
end

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
end
