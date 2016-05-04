
% References
% 10.1109/TCAD.2006.882119
%**************************************************************************

function [out_s, out_cv] = hara(in_delay, in_range, in_mode, in_K, in_maxi, in_alpha, in_minrand, in_maxrand)




allcones = generate_cones(in_delay, in_range, in_K);
tsort = get_inorder(in_delay, in_range);
rtsort = fliplr(tsort);

ndepth = fill_depth(in_delay, in_range);
nheight = fill_height(in_delay, in_range);
[naf, nnoedge] = fill_af(in_delay, in_range);
[in_iedge, in_oedge] = fill_edges(in_delay, in_range);



sasz = nnz(in_delay);

edepth  = spalloc(in_range.sz, in_range.sz, sasz);
eaf     = spalloc(in_range.sz, in_range.sz, sasz);
eheight = spalloc(in_range.sz, in_range.sz, sasz);



switch (in_mode)
    case 1,    best_cone = @best_cone_depth;
    case 2,    best_cone = @best_cone_area;
    otherwise, error('Unknown mode.');
end



%allcones = allcones(in_range.in);
%cv = cell(1, in_range.szin);

%ofs = in_range.pihi;

cv = cell(1, in_range.sz);
Odepth = [];
Odepthfound = false;

bestsolution = [];

for i = 1:in_maxi
    traverse_fwd();
    traverse_bwd();
    
    if ((in_mode == 1) && (i == 1))
        set_odepth();
        disp(['Odepth: ' num2str(Odepth)]);
    end
    
    solution = s(is_in(s, in_range));
    luts = numel(solution);    
    if (isempty(bestsolution) || (luts < bestluts))
        bestsolution = solution;
        bestluts = luts;
        bestcones = cv;
    end    
    disp([num2str(i) ' -> LUTs: ' num2str(luts) ' - Best: ' num2str(bestluts)]);


    observedoedges = ones(1, in_range.sz);
    for node = solution
        cone = cv{node};
        coneoedge = cone{in_range.CONE_OEDGE};
        coneonode = coneoedge(2, :);
        coneonode = unique(coneonode(is_in(coneonode, in_range)));
        coneonode = coneonode(:).';
        numberoedges = sum(is_po(coneonode, in_range));
        solsubset = solution(solution > node);
        solsubset = solsubset(:).';
        
        for onode = coneonode
            for container = solsubset
                cont = cv{container};
                members = cont{in_range.CONE_NODE};
                numberoedges = numberoedges + sum(members == onode);
            end
        end
        observedoedges(node) = numberoedges;
    end
end



%cv{v - ofs} = bc;
        %disp(bcdepth)

out_s = bestsolution;
out_cv = bestcones;

    function [out_depth] = cone_depth(in_cone)
    out_depth = 0;
    for e = in_cone{in_range.CONE_IEDGE}
        e1 = e(1);
        %dalt = in_depth(e(2));
        %d = ndepth(e1) + edepth(e1, e(2));
        d = full(edepth(e1, e(2)));
        %if (~isequalfp(dalt, d)), error([num2str(dalt) ' / ' num2str(d)]); end
        
        if (d > out_depth), out_depth = d; end
    end
    end

    function [out_af] = cone_af(in_cone)
    out_af = 1;
    for e = in_cone{in_range.CONE_IEDGE}, out_af = out_af + eaf(e(1), e(2)); end
    out_af = out_af + in_minrand + (rand() * (in_maxrand - in_minrand));
    end

    function traverse_fwd()
    for v = in_range.pi
        ndepth(v) = 0;
        naf(v) = 0;
        for e = in_oedge{v}
            e1 = e(1);
            e2 = e(2);
            edepth(e1, e2) = in_delay(e1, e2);
            eaf(e1, e2) = 0;
        end
    end
    for v = tsort
        [bc, bcdepth, bcaf] = best_cone(v);        
        cv{v}     = bc;
        ndepth(v) = bcdepth;
        naf(v)    = bcaf;
        
        
        
        
        if (i == 1)
        noest = nnoedge(v);
        caf = naf(v) / noest;
        else
        noest = (nnoedge(v) + (in_alpha * observedoedges(v))) / (1 + in_alpha);
        if (noest <= 0), warning(['<= 0 -> ' num2str(noest)]); noest = 1; end
        caf = naf(v) / noest;
        end
        nnoedge(v) = noest;
        
        
        oedge = in_oedge{v};
        
        
        
        
        %nnoedge(v) = ((no + (in_alpha * numel(oedge))) / (1 + in_alpha));%floor((no + (alpha * numel(oedge))) / (1 + alpha));
        %if (nnoedge(v) < 1), nnoedge(v) = 1; end
        for e = oedge
            e1 = e(1);
            e2 = e(2);
            edepth(e1, e2) = in_delay(e1, e2) + bcdepth;
            eaf(e1, e2) = caf;
        end
    end
    end

    function traverse_bwd()
    s = [];
    for v = in_range.po
        iedge = in_iedge{v};
        for e = iedge
            e1 = e(1);
            e2 = e(2);
            eheight(e1, e2) = in_delay(e1, e2);
        end
        s = union(s, iedge(1, :));
    end
    for v = rtsort
        if (any(v == s))
            h = 0;
            for e = in_oedge{v}
                nh = eheight(e(1), e(2));
                if (nh > h), h = nh; end
            end
            %bc = cv{v - ofs};
            bc = cv{v};
            for u = bc{in_range.CONE_NODE}, nheight(u) = max([nheight(u), h]); end
            iedge = bc{in_range.CONE_IEDGE};
            for e = iedge
                e1 = e(1);
                e2 = e(2);
                eheight(e1, e2) = max([eheight(e1, e2), in_delay(e1, e2) + h]);
            end
            s = union(s, iedge(1, :));
        end
    end
    end

    function set_odepth()
    pod = edepth(:, in_range.po);
    Odepth = full(max(pod(:)));
    Odepthfound = true;
    end
    
    function [out_bc, out_bcdepth, out_bcaf] = best_cone_area(in_v)
    %cones = allcones{in_v - ofs};
    cones = allcones{in_v};
    out_bc = [];
    for c = cones
        d = cone_depth(c);
        a = cone_af(c);
        if ((isempty(out_bc) || (a < out_bcaf)) || (isequalfp(a, out_bcaf) && (d < out_bcdepth)))
            out_bc = c;
            out_bcdepth = d;
            out_bcaf = a;
        end
    end
    end
    
    function [out_bc, out_bcdepth, out_bcaf] = best_cone_depth(in_v)
    %adjv = in_v - ofs;
    adjv = in_v;
    cones = allcones{adjv};
    out_bc = [];
    for c = cones
        d = cone_depth(c);
        a = cone_af(c);           
        if  ((Odepthfound && ((d <= (Odepth - nheight(in_v))) && (isempty(out_bc) || (a < out_bcaf)))) || (~Odepthfound && (isempty(out_bc) || (d < out_bcdepth) || (isequalfp(d, out_bcdepth) && (a < out_bcaf)))))
            out_bc = c;
            out_bcdepth = d;
            out_bcaf = a;
        end            
    end
    if (isempty(out_bc))
        out_bc = cv{adjv};
        out_bcdepth = cone_depth(out_bc);
        out_bcaf = cone_af(out_bc);
    end
    end
    

end
