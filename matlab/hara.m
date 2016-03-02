
% References
% 10.1109/TCAD.2006.882119
%**************************************************************************

function [out_s, out_cv] = hara(in_order, in_iedge, in_oedge, in_noedge, in_delay, in_depth, in_height, in_af, in_range, in_K, in_DF, in_mode, in_maxi, in_alpha, in_minrand, in_maxrand) % DF/NDF
[tsort, allcones] = generate_cones_all(in_order, in_iedge, in_oedge, in_range, in_K, in_DF, in_delay);

rtsort = fliplr(tsort);


ndepth = in_depth;
naf = in_af;
nheight = in_height;
nnoedge = in_noedge;

if (~in_DF)
    alpha = in_alpha;
else
    alpha = 0;
end


gsz = in_range.sz;
sasz = sum(in_delay(:) > 0);

edepth = spalloc(gsz, gsz, sasz);
eaf = spalloc(gsz, gsz, sasz);
eheight = spalloc(gsz, gsz, sasz);

cv = cell(1, in_range.szin);
ofs = in_range.pihi;
Odepth = [];
Odepthfound = false;









for i = 1:in_maxi
    traverse_fwd();
    traverse_bwd();
    
    if (i == 1)
        set_odepth();
    end
    
    disp(['LUTs: ' num2str(numel(s(is_in(s, in_range))))]);
end

out_s = s(is_in(s, in_range));
out_cv = cv;



    function [out_depth] = cone_depth(in_cone)
    out_depth = 0;
    for e = in_cone{3}
        e1 = e(1);
        d = ndepth(e1) + edepth(e1, e(2));
        if (d > out_depth), out_depth = d; end
    end
    end

    function [out_af] = cone_af(in_cone)
    out_af = 1;
    for e = in_cone{3}, out_af = out_af + eaf(e(1), e(2)); end
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
        cv{v - ofs} = bc;
        ndepth(v) = bcdepth;
        naf(v) = bcaf;
        no = nnoedge(v);
        caf = naf(v) / no;
        oedge = in_oedge{v};
        nnoedge(v) = floor((no + (alpha * numel(oedge))) / (1 + alpha));
        if (nnoedge(v) < 1), nnoedge(v) = 1; disp('0'); end
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
            bc = cv{v - ofs};
            for u = bc{1}, nheight(u) = max([nheight(u), h]); end
            iedge = bc{3};
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








    function [out_bc, out_bcdepth, out_bcaf] = best_cone_depth(in_v)
    cones = allcones{in_v - ofs};
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
        out_bc = cv{in_v - ofs};
        out_bcdepth = cone_depth(out_bc);
        out_bcaf = cone_af(out_bc);
    end
    end

   
    function [out_bc, out_bcdepth, out_bcaf] = best_cone_area(in_v)
        cones = allcones{in_v - ofs};
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

function [out_bc, out_bcdepth, out_bcaf] = best_cone(in_v)
    if (in_mode == 1)
        [out_bc, out_bcdepth, out_bcaf] = best_cone_depth(in_v);
    elseif (in_mode == 2)
        [out_bc, out_bcdepth, out_bcaf] = best_cone_area(in_v);
    end
end

%{
    function [out_bc, out_bcdepth, out_bcaf] = best_cone_depth(in_v)
        cones = allcones{in_v - ofs};
        out_bcdepth = [];
        out_bcaf = [];
        if (isempty(Odepth))
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
        else
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
%}
%[depthcones] = fill_depth_cones(allcones, in_delay, in_depth);
%[afcones] = fill_af_cones(allcones, in_af, in_noedge);
%prevnnoedge = zeros(1, gsz);
%{
function set_odepth()
    [delay, ~, range] = rebuild_graph_from_cones(s(is_in(s, in_range)), cv, in_delay, in_range);
    [iedge, ~] = prepare_edges(delay);
    depth = fill_depth(graphtopoorder(delay), iedge, delay, range);
    Odepth = max(depth(range.po));
end
%}
%{
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
%}
end
