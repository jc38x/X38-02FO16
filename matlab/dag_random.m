
K = 4;
DF = false;
mode = 2;
alpha = 1.5; %1.5-2.5
maxi = 20; %20
epsrand = [0.001, 0.005]; %small

%RNG = rng();
rng(RNG);

t = tic();
%delay = result_delay;
%range = result_range;

%[delay, range] = sample_valavan();
%[delay, range] = random_dag(100, 5000, 60, 1, 10); %ok

%[delay, range] = random_dag(1, 495, 1, 1, 10);
%[delay, range] = random_dag(385, 555, 60, 1, 10); %ok
%[delay, range] = random_dag(100, 200, 10, 1, 10); %ok
[delay, range] = random_dag(5, 450, 3, 1, 10); %ok <<<<<<<<<<
%[delay, range] = random_dag(1, 10, 1, 1, 10); %ok 360s
%[delay, range] = random_dag(6, 6, 2, 1, 10); %ok
toc(t)

t = tic();
[labels] = node_labels(range);

[iedge, oedge] = prepare_edges(delay);
order = graphtopoorder(delay);
redro = fliplr(order);


depth = fill_depth(order, iedge, delay, range);
height = fill_height(redro, oedge, delay, range);
[af, noedge] = fill_af(order, iedge, oedge, range);

toc(t)

%t = tic();
%[keys, cones] = generate_cones_all(order, iedge, oedge, range, K, DF, delay);
%toc(t)
%bg = build_graph(delay, labels, range);
%view(bg);
%[depthcones] = fill_depth_cones(cones, delay, depth);
%[afcones] = fill_af_cones(cones, af, noedge);

t = tic();
[s, cv] = hara(order, iedge, oedge, noedge, delay, depth, height, af, range, K, DF, mode, maxi, alpha, epsrand(1), epsrand(2));
toc(t)

t = tic();
[resultdelay, resulttag, resultrange] = rebuild_graph_from_cones(s, cv, delay, range);
toc(t)

%bg = build_graph(delay, labels, range);
%view(bg);

indices = find(resulttag);
[~, I] = sort(resulttag(indices));
newlabels = [labels(range.pi), labels(indices(I)+double(range.szpi)), labels(range.po)];

%br = build_graph(resultdelay, newlabels, resultrange);
%view(br);



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
%{
%}