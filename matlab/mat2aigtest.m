
K = 4;
DF = false;
mode = 1;
alpha = 1.5; %1.5-2.5
maxi = 20; %20
epsrand = [0.001, 0.005]; %small

filename = 'C:/Users/jcds/Documents/GitHub/X38-02FO16/matlab/LUTD7FFF040.aig';
optname = 'C:/Users/jcds/Documents/GitHub/X38-02FO16/matlab/LUTD7FFF040_SIM.aig';

path = 'C:/Users/jcds/Documents/GitHub/X38-02FO16/tools/abc/abc.exe';
wd = 'C:/Users/jcds/Documents/GitHub/X38-02FO16/tools/abc/';

[do, lo, ro, eo] = tt2mat('D7AD');
count = 2048;
dl = cell(1, count);
ll = cell(1, count);
rl = cell(1, count);
el = cell(1, count);
for k = 1:count
    [loi,  eoi] = make_instance(['LUT4_' num2str(k)], lo, ro, eo);
    dl{k} = do;
    ll{k} = loi;
    rl{k} = ro;
    el{k} = eoi;
    %dl = [dl, {do}];
    %ll = [ll, {loi}];
    %rl = [rl, {ro}];
    %el = [el, {eoi}];
end

t = tic();
disp('GROUP');
[do, lo, ro, eo] = group_nets(dl, ll, rl, el);
toc(t)


%bo = build_graph(do, lo, ro, eo);
%view(bo);
t = tic();
disp('RANGE');
ro = prepare_range_ex(do, ro);
toc(t)
%{
mat2aiger(filename, lo, ro, eo);

script = [
    {['read_aiger ' filename ';']};
    {'refactor'};
    {['write_aiger -s ' optname]};
    {'quit'};
    ];

cmdfifo = C_cmdfifo(script);
spawn_process(path, '', wd, false, script, @(obj, event)stdout_callback_abc(obj, event, cmdfifo));

[df, lf, rf, ef] = aiger2mat(optname);

%bf = build_graph(df, lf, rf, ef);
%view(bf);



[iedgef, oedgef] = prepare_edges(df, rf);
orderf = graphtopoorder(df);
redrof = fliplr(orderf);
depthf = fill_depth(orderf, iedgef, df, rf);
heightf = fill_height(redrof, oedgef, df, rf);
[aff, noedgef] = fill_af(orderf, iedgef, oedgef, rf);

[sf, cvf] = hara(orderf, iedgef, oedgef, noedgef, df, depthf, heightf, aff, rf, K, DF, mode, 1, alpha, epsrand(1), epsrand(2));
[resultdf, resultlf, resultrf, resultef] = rebuild_graph_from_cones(sf, cvf, df, rf, lf, ef);

[lutsf, inputsf] = cones2luts(resultrf, resultef, []);
%}

%edgelist = ;
%edgelist = uidremap.remap(edgelist);
%out_delay = sparse(edgelist(1, :), edgelist(2, :), 1, n, n);
%if (in_u32 < 0), warning('< 0'); end
%warning(['INVERTER OF INVERTER ' in_label ' | ' in_a ]);
%signal2literal(in_a) + 1;
%{
[do, lo, ro, eo] = tt2mat('D7FF');
[lo, eo] = make_instance('LUT4_01', lo, ro, eo);

[d2, l2, r2, e2] = tt2mat('F040');
[l2, e2] = make_instance('LUT4_02', l2, r2, e2);

join = [{'LUT4_01,o'; 'LUT4_02,i0'}, ...
        {'LUT4_01,i1'; 'LUT4_02,i1'}, ...
        {'LUT4_01,i2'; 'LUT4_02,i2'}, ...
        {'LUT4_01,i3'; 'LUT4_02,i3'}  ...
        ];

[do, lo, ro, eo] = attach_net(do, lo, ro, eo, d2, l2, r2, e2, join);
[do, lo, ro, eo] = remove_node(do, lo, ro, eo, find(strcmpi(lo, 'LUT4_01,o')));

mat2aig(filename, do, lo, ro, eo);

bo = build_graph(do, lo, ro, eo);
view(bo);

script = [
    {['read_aiger ' filename ';']};
    {'ps'};
    {'refactor'};
    {'ps'}
    {['write_aiger -s ' optname]};
    {'quit'};
    ];

cmdfifo = C_cmdfifo(script);
spawn_process(path, '', wd, false, script, @(obj, event)stdout_callback_abc(obj, event, cmdfifo));

[df, lf, rf, ef] = aig2mat(optname);

bf = build_graph(df, lf, rf, ef);
view(bf);
%}

%{
[iedgeo, oedgeo] = prepare_edges(do, ro);
ordero = graphtopoorder(do);
redroo = fliplr(ordero);
deptho = fill_depth(ordero, iedgeo, do, ro);
heighto = fill_height(redroo, oedgeo, do, ro);
[afo, noedgeo] = fill_af(ordero, iedgeo, oedgeo, ro);

[so, cvo] = hara(ordero, iedgeo, oedgeo, noedgeo, do, deptho, heighto, afo, ro, K, DF, mode, maxi, alpha, epsrand(1), epsrand(2));
[resultdo, resultlo, resultro, resulteo] = rebuild_graph_from_cones(so, cvo, do, ro, lo, eo);

[lutso, inputso] = cones2luts(resultro, resulteo, {'[LUT4_01,i0]', '[LUT4_01,i1]', '[LUT4_01,i2]', '[LUT4_01,i3]'});

[iedgef, oedgef] = prepare_edges(df, rf);
orderf = graphtopoorder(df);
redrof = fliplr(orderf);
depthf = fill_depth(orderf, iedgef, df, rf);
heightf = fill_height(redrof, oedgef, df, rf);
[aff, noedgef] = fill_af(orderf, iedgef, oedgef, rf);

[sf, cvf] = hara(orderf, iedgef, oedgef, noedgef, df, depthf, heightf, aff, rf, K, DF, mode, maxi, alpha, epsrand(1), epsrand(2));
[resultdf, resultlf, resultrf, resultef] = rebuild_graph_from_cones(sf, cvf, df, rf, lf, ef);

[lutsf, inputsf] = cones2luts(resultrf, resultef, {'[LUT4_01,i0]', '[LUT4_01,i1]', '[LUT4_01,i2]', '[LUT4_01,i3]'});
%}


%{
{'b'};
    {'b'};
    {'rw -l'};
    {'rw -lz'};
    {'b'};
    {'rw -lz'};
    {'b'};
%}

%process = spawn_process(path, '', wd, true);
%process.StandardOutput.ReadToEnd();
%in_iedge{k};
%out_equation{k} = ['[' out_labels{ie(1)} ']' ' & '  '[' out_labels{ie(2)} ']'];
%out_equation{k} = ['~[' out_labels{ie(1)} ']'];
%pilo = 1;
%pihi = size(pilist, 2);
%inlo = pihi + 1;
%inhi = pihi + size(inlist, 2);
%polo = inhi + 1;
%pohi = inhi + size(polist, 2);
%out_range = prepare_range(pilo, pihi, inlo, inhi, polo, pohi);
            %wp = wp + 1;
        %out_bytes(wp) = uint8(bitor(bitand(x, 127), 128));
    %wp = wp + 1;
    %out_bytes(wp) = uint8(bitand(x, 127));
%latches = 0;
%for k = , write_line(num2str(signal2literal(in_labels{k}))); end
%for k = in_range.po
%    equation = in_equations{k};
%    if (~strcmpi(equation, 'latch')), continue; end
%    write_line(num2str(signal2literal(in_labels{k})));
%end

%for k = in_range.po
%end
    %gate = ;
    %len = numel(equation);
            %if (ns ~= 1 && ns ~= 3)
            %split = split(end);  
%{
            depth = 1;
            signalscope = false;
            split = [];
            index = start;

            while ((index <= len) && isempty(split))
                index = index + 1;
                ch = equation(index);
                switch (ch)
                case '(', if (~signalscope), depth = depth + 1; end
                case '[', signalscope = true;
                case ')', if (~signalscope), depth = depth - 1; end
                case ']', signalscope = false;
                case ',', if (~signalscope && (depth == 1)), split = index; end
                end
            end
            if (isempty(split)), error('Incomplete and definition.'); end
            %}
%for k = in_range.pi
%    equation = in_equations{k};
%    if (~strcmpi(equation, 'latch')), continue; end
    %latches = latches + 1;
%    push_literal();
%end
%literal = literal + 2;
%signal2literal(label) = literal;
%literal = literal + 2;
    %signal2literal(label) = literal;
    %signal2literal(['not(' signal ')']) = literal + 1;
    %literal = literal + 2;
    %signal2literal(in_label) = literal; 
%bdd = make_bdd(equation);
    %signals = [];
    %if (equation == '0' || equation == '1')
    %elseif (strcmpi(equation(
    %end
    %{
    function [out_bdd] = make_bdd(in_equation)
        inputstart = find(in_equation == '(', 1);
        gate = in_equation(1:inputstart);
        if (any(strcmpi(gate, {'and', 'or', 'xor'})))
        elseif (strcmpi(gate, 'not'))
        else
        end
        depth = 1;
        ignore = false;
        index = inputstart + 1;
        len = numel(in_equation);
        while (index <= len)
            ch = in_equation(index);
            switch (ch)
                case '('
                    depth = depth + 1;
                case ')',
                    depth = depth - 1;
                    if (depth == 0)
                    end
                case '[', ignore = true;
                case ']', ignore = false;
                case ',',
            end
        end
    end
%}