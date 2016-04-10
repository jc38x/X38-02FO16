
K = 4;
DF = false;
mode = 1;
alpha = 1.5; %1.5-2.5
maxi = 20; %20
epsrand = [0.001, 0.005]; %small

t = tic();
[delay, labels, range, equations] = tt2mat('D7FF');

[labels, equations] = rename_node(delay, labels, equations, [1,2,3,4], {'I0', 'I1', 'I2', 'I3'});


[labels, equations] = make_instance('LUT4_B', labels, range, equations);
toc(t)

%bg = build_graph(delay, labels, range, equations);
%view(bg);



[iedge, oedge] = prepare_edges(delay, range);
order = graphtopoorder(delay);
redro = fliplr(order);
depth = fill_depth(order, iedge, delay, range);
height = fill_height(redro, oedge, delay, range);
[af, noedge] = fill_af(order, iedge, oedge, range);

t = tic();
[s, cv] = hara(order, iedge, oedge, noedge, delay, depth, height, af, range, K, DF, mode, maxi, alpha, epsrand(1), epsrand(2));
toc(t)

t = tic();
[resultdelay, resultlabels, resultrange, resultequations] = rebuild_graph_from_cones(s, cv, delay, range, labels, equations); %in_S, in_Cv, in_delay, in_range, in_labels, in_equations
toc(t)

bg = build_graph(delay, labels, range, equations);
view(bg);

br = build_graph(resultdelay, resultlabels, resultrange, resultequations);
view(br);

[luts, inputs] = cones2luts(resultrange, resultequations, {'[LUT4_B,I0]', '[LUT4_B,I1]', '[LUT4_B,I2]', '[LUT4_B,I3]'});



%for k = 0:(npi - 1), push_node(['i' num2str(k)], '', []); end
%['i' num2str(i - 1)]
%{
if (nt < 1)
    miniterms = cell(1, npi);
    for k = 1:npi
        port = ['i' num2str(k - 1)];
        miniterms{k} = push_xor(port, port);
    end
else
%}
%end
%elseif (nt < 2)
%else
%end
%if (any(strcmpi(in_tthex, {'FFFF', '0000'})))
%    error('Constant LUTs are unsupported.');
%end
%edges = zeros(2, 100);
%edgesindex = 0;
%nodename = push_not(push_and(push_not(miniterms{1}), push_not(miniterms{2})));
%for n = miniterms(3:end), nodename = push_not(push_and(push_not(nodename), push_not(n{1}))); end
%out_equations = [];
%out_delay = [];
%expr = ['and(' operand(input(1), 'i0') ',' operand(input(2), 'i1') ')'];
    %for i = 3:numel(input), expr = strcat('and(', expr, ',', operand(input(i), ['i' num2str(i - 1)]), ')'); end
    %miniterms{n} = expr;
%out_equations = 0;%miniterms;
    %out_delay = [];
    %out_labels = [];
    %{
    function [out_name] = push_xor(in_a, in_b)
    and1 = push_and(in_a, in_b);
    not1 = push_not(and1);
    andu = push_and(in_a, not1);
    andl = push_and(in_b, not1);
    notu = push_not(andu);
    notl = push_not(andl);
    and2 = push_and(notu, notl);
    not2 = push_not(and2);
    out_name = not2;
    end
    %}
    %out_name = ['not(' in_name ')'];
        %out_name = in_name;
%push_edge(node2uid(in_a), nin);
        %push_edge(node2uid(in_b), nin);
    %function push_edge(in_head, in_tail)
    %edgesindex = edgesindex + 1;
    %edges(1, edgesindex) = in_head;
    %edges(2, edgesindex) = in_tail;
    %end
