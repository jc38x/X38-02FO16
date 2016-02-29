
% References
% 10.1109/TCAD.2006.882119
%**************************************************************************

function [out_s, out_cv] = hara(in_order, in_iedge, in_oedge, in_noedge, in_delay, in_depth, in_height, in_af, in_range, in_K, in_DF, in_mode, in_maxi) % DF/NDF
[tsort, allcones] = generate_cones_all(in_order, in_iedge, in_oedge, in_range, in_K, in_DF);
rtsort = fliplr(tsort);
cv = cell(1, in_range.szin);
ofs = in_range.pihi;
gsz = double(in_range.sz);
sasz = ((gsz - 1) * gsz) / 2;

ndepth = in_depth;
naf = in_af;
nheight = in_height;

edepth = spalloc(gsz, gsz, sasz);
eaf = spalloc(gsz, gsz, sasz);
eheight = spalloc(gsz, gsz, sasz);

for i = 1:in_maxi
    traverse_fwd();
    traverse_bwd();
end

out_s = s(is_in(s, in_range));
out_cv = cv;

function traverse_fwd()
for v = in_range.pi
    ndepth(v) = 0;
    naf(v) = 0;
    for e = in_oedge{v}
        edepth(e(1), e(2)) = in_delay(e(1), e(2));
        eaf(e(1), e(2)) = 0;
    end
end
for v = tsort
    [bc, bcdepth, bcaf] = best_cone(v);
    cv{v - ofs} = bc;
    ndepth(v) = bcdepth;
    naf(v) = bcaf;
    for e = in_oedge{v}
        edepth(e(1), e(2)) = in_delay(e(1), e(2)) + ndepth(v);
        eaf(e(1), e(2)) = naf(v) / in_noedge(v);
    end
end
end

function traverse_bwd()
s = [];
for v = in_range.po
    iedge = in_iedge{v};
    for e = iedge
        eheight(e(1), e(2)) = in_delay(e(1), e(2));
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

        bc = cv{v - ofs};
        for u = bc{1}
            nheight(u) = max([nheight(u), h]);
        end
        iedge = bc{3};
        for e = iedge
            eheight(e(1), e(2)) = max([eheight(e(1), e(2)), in_delay(e(1), e(2)) + h]);
        end
        s = union(s, iedge(1, :));
    end
end
end


    function [out_depth] = cone_depth(in_cone)
        out_depth = 0;
        for e = in_cone{3}
            d = in_depth(e(1)) + in_delay(e(1), e(2));
            if (d > out_depth), out_depth = d; end
        end
    end

    function [out_af] = cone_af(in_cone)
        out_af = 1;
        for e = in_cone{3}
            out_af = out_af + (in_af(e(1)) / in_noedge(e(1)));
        end      
    end

    function [out_bc, out_bcdepth, out_bcaf] = best_cone(in_v)
        if (in_mode == 1)
            [out_bc, out_bcdepth, out_bcaf] = best_cone_depth(in_v);
        elseif (in_mode == 2)
            [out_bc, out_bcdepth, out_bcaf] = best_cone_area(in_v);
        end
    end

    function [out_bc, out_bcdepth, out_bcaf] = best_cone_depth(in_v)
        cones = allcones{in_v - ofs};          
        out_bcdepth = [];
        out_bcaf = [];
        for c = cones
            d = cone_depth(c);
            a = cone_af(c);            
            if (isempty(out_bcdepth) || (d < out_bcdepth))
                out_bc = c;
                out_bcdepth = d;
                out_bcaf = a;
            elseif (isequalfp(d, out_bcdepth))
                if (a < out_bcaf)
                    out_bc = c;
                    out_bcdepth = d;
                    out_bcaf = a;
                end
            end
        end
    end

    function [out_bc, out_bcdepth, out_bcaf] = best_cone_area(in_v)
        cones = allcones{in_v - ofs};
        out_bcdepth = [];
        out_bcaf = [];
        for c = cones
            d = cone_depth(c);
            a = cone_af(c);
            if (isempty(out_bcaf) || (a < out_bcaf))
                out_bc = c;
                out_bcdepth = d;
                out_bcaf = a;
            elseif (isequalfp(a, out_bcaf))
                if (d < out_bcdepth)
                    out_bc = c;
                    out_bcdepth = d;
                    out_bcaf = a;
                end
            end
        end
    end
end
