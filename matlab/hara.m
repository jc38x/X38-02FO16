
% References
% 10.1109/TCAD.2006.882119
%**************************************************************************

function [out_s, out_cv] = hara(in_order, in_iedge, in_oedge, in_noedge, in_delay, in_depth, in_height, in_af, in_range, in_K, in_DF, in_maxi) % DF/NDF


[tsort, allcones] = generate_cones(in_order, in_iedge, in_oedge, in_range, in_K, in_DF);
rtsort = fliplr(tsort);
cv = cell(1, in_range.szin);
ofs = in_range.pihi;

gsz = double(in_range.sz);
sasz = ((gsz - 1) * gsz) / 2;

ndepth = in_depth;%zeros(1, gsz);
naf = in_af;%zeros(1, gsz);
nheight = in_height;%zeros(1, gsz);

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
%out_s = s;
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
        %disp('node')
        %in_v
        cones = allcones{tsort == in_v};
        %disp('cones')        
        out_bcdepth = [];
        for c = cones
            d = cone_depth(c);
            a = cone_af(c);
            
            %disp('cone');
            %c{1}
            %d
            %a
         
            
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
            %disp('----------break-------------');
            
        end
        %disp('pick');
        %out_bc{1}
        %    out_bcdepth
        %    out_bcaf
        %out_bcaf = cone_af(out_bc);
        %disp('****************** end cone ***********');
    end


%{
gsz = in_range.sz;
sasz = ((gsz - 1) * gsz) / 2;

depth_n = zeros(1, gsz);
depth_e = spalloc(gsz, gsz, sasz);
af_n = zeros(1, gsz);
af_e = spalloc(gsz, gsz, sasz);
height_n = zeros(1, gsz);
height_e = spalloc(gsz, gsz, sasz);


rtsort = fliplr(tsort);
cv = cell(size(cones, 2));
idx = 0;


for v = in_range.pi
    depth_n(v) = 0;
    af_n(v) = 0;
    for e = in_oedge{v}
        depth_e(v, e) = in_delay(v, e);
        af_e(v, e) = 0;
    end
end
for v = tsort
    cv = best_cone(v);
    depth_n(v) = depth_cone(cv);
    af_n(v) = af_cone(cv);
    for e = in_oedge{v}
        depth_e(v, e) = in_delay(v, e) + depth_n(v);
        af_e(v, e) = af_n(v) / numel(in_oedge{v});
    end
end

s = [];
for v = in_range.po
    for e = in_iedge{v}
        height_e(e, v) = in_delay(e, v);
    end
    s = union(s, in_iedge{v});
end
for v = rtsort
    if (any(v == s))
        h = max(in_delay(v, [in_oedge{v}]));
        %for u =
        %end
    end
end
%}
%{
    function [out_af] = af_cone(in_cone)
        out_af = 1;
        for v = in_cone{2}
            out_af = out_af + (in_af(v) / numel(in_oedge{v}));
        end
    end
%}
%{
    function [out_depth] = cone_depth(in_cone)
        conenodes = in_cone{1};
        coneinodes = in_cone{2};
        
        out_depth = 0;
        for iv = coneinodes
            delay = in_delay(iv, conenodes);
            delay = delay(delay > 0);            
            depth = in_depth(iv) + 
        end
        
        if (numel(conenodes > 1))
            out_depth = max(in_depth(conenodes(2:end)));
        else
            out_depth = in_depth(conenodes);
        end
    end

    function [out_af] = cone_af(in_cone)
        coneinode = cone{2};
        out_af = 1 + in_af(coneinode) ./ in_nonode(coneinode);
    end



    function [out_cone, out_depth, out_af] = best_cone(in_v) %ODepth, DB
        cones = allcones{tsort == in_v};
        best = 0;
        dmax = 0;
        afmax = 0;
        
        for n = 1:size(cones, 2)
            cone = cones(:, n);
            depth = max(in_depth());
            
            
            
            
            o = 
            a = 1 + in_af(c{2}) ./ 
            
            if (d > dmax)
                dmax = d;
            end
        end
        
        
        
        idx = 0;
        for c = cones
            idx = idx + 1;
            
            if (d > dmax)
            
            
            
            
            if (
            
            
        end
        
        
        vcones = cones(in_v.m_uid);
        vdepth = hamlut.depth_p(vcones);
        vcones = vcones(vdepth == min(vdepth));
        if (numel(vcones > 1))
            vaf = hamlut.af_p(vcones);
            vcones = vcones(vaf == min(vaf));
        end
        out_cone = vcones(1);
    end
    
    %}

%{

lo = in_range(1);
hi = in_range(2);

tsort = topology;
rtsort = topology(end:-1:1);

[m, n] = size(in_G);
depth = sparse(1, m);
af = sparse(1, m);
height = sparse(1, m);


for i = 1:in_maxi
    traverse_fwd();
    traverse_bwd();
end

out_s = s;




    function traverse_fwd()
        for v = 1:(lo-1)
            depth(v) = 0;
            af(v) = 0;
            
            e = 
            
        end
        
        
        for v = in_PI
            v.m_depth = 0;
            v.m_af = 0;
            for e = v.m_oedge
                e.m_depth = e.m_delay;
                e.m_af = 0;
            end
        end
        for v = tsort
            v.m_cv = best_cone(v);
            v.m_depth = depth(v.m_cv);
            v.m_af = af(v.m_cv);
            for e = v.m_oedge
                e.m_depth = e.m_delay + v.m_depth;
                e.m_af = v.m_af / numel(v.m_oedge); %NDF |oedge|est
            end
        end
    end




    function [out_cone] = best_cone(in_v) %ODepth, DB
        vcones = cones(in_v.m_uid);
        vdepth = hamlut.depth_p(vcones);
        vcones = vcones(vdepth == min(vdepth));
        if (numel(vcones > 1))
            vaf = hamlut.af_p(vcones);
            vcones = vcones(vaf == min(vaf));
        end
        out_cone = vcones(1);
    end

    



    function traverse_bwd()
        s = [];
        for v = in_PO
            for e = v.m_iedge
                e.m_height = e.m_delay;
            end
            s = union(s, v.m_inode);
        end
        for v = rtsort
            if (any(s == v))
                h = max([v.m_oedge.m_height]);
                for u = v.m_cv.m_nodes
                    u.m_height = max([height(u), h]);
                end
                for e = v.m_cv.m_iedge
                    e.m_height = max([height(e), e.m_delay + h]);
                end
                s = union(s, v.m_cv.m_inode);
            end
        end
    end

    function [out_height] = height(in_x)
        if (isempty(in_x.m_height))
            disp('miss h');
            in_x.m_height = hamlut.height(in_x);
        end
        out_height = in_x.m_height;
    end

    function [out_depth] = depth(in_x)
        if (isempty(in_x.m_depth))
            disp('miss d');
            in_x.m_depth = hamlut.depth(in_x);
        end
        out_depth = in_x.m_depth;
    end

    function [out_af] = af(in_x)
        if (isempty(in_x.m_af))
            disp('miss a');
            in_x.m_af = hamlut.af(in_x);
        end
        out_af = in_x.m_af;
    end
%}
end
