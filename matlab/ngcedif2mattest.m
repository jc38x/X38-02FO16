
%http://www1.pldworld.com/@xilinx/html/technote/tool/manual/15i_doc/alliance/lib/lib7_21.htm
%http://www1.pldworld.com/@xilinx/html/technote/tool/manual/15i_doc/alliance/lib/lib7_19.htm
%http://www1.pldworld.com/@xilinx/html/technote/tool/manual/15i_doc/alliance/lib/lib7_20.htm
%https://docs.oracle.com/javase/7/docs/api/java/io/FileOutputStream.html
%http://reliability.ee.byu.edu/edif/doc/

t = tic();

K = 4;
DF = false;
mode = 2;
alpha = 2.5; %1.5-2.5
maxi = 20; %20
epsrand = [0.000, 0.000]; %small

srcfname = 'C:\Users\jcds\Documents\GitHub\X38-02FO16\benchmarks\VHDL_Generado_desde_C++\inputs-4bits_outputs5bits\14-MESA-IA\asap-alap-random\mesaia_random.edif';
dstfname = 'C:\Users\jcds\Documents\GitHub\X38-02FO16\benchmarks\VHDL_Generado_desde_C++\inputs-4bits_outputs5bits\14-MESA-IA\asap-alap-random\mesaia_random_IMAP.edif';
%srcfname = 'C:\Users\jcds\Documents\GitHub\X38-02FO16\workspace\practica3.ndf';
%dstfname = 'C:\Users\jcds\Documents\GitHub\X38-02FO16\workspace\practica3_IMAP_MODE7.edif';
tmpfname = 'C:/Users/jcds/Documents/GitHub/X38-02FO16/workspace/tmp_abc_logic_opt.aig';

[d, l, r, e, edif] = ngcedif2mat(srcfname);
mat2aiger(tmpfname, d, l, r, e);


script = [
    {['read_aiger ' tmpfname ';']};
    {'b'};
    repmat([{'b'};{'rw'};{'rw -z'};{'b'};{'rw -z'};], 100, 1);
    {'b'};
    {['write_aiger -s ' tmpfname]};
    {'cec'}
    {'quit'};
    ];

script2 = [
    {['read_aiger ' tmpfname]};
    {'strash'};
    {'ps'};
    {'b'};
    {'b'};
    
    {'rr'};
    {'resyn2'};
    repmat([{'rw '};{'b'};{'rw -z'};{'b'};{'rw -z'};], 1000, 1);
    
    {'b'};
    {'b'};
    {'ps'};
    {['write_aiger -s ' tmpfname]};
    %{['read_blif ' original]};
    %{'comb'};
    %{['cec ' tmpfname]};
    {'quit'};
    ];

script3 = [
    {['read_aiger ' tmpfname ';']};
    {'refactor'};
    {'refactor'};
    {'refactor'};
    {['write_aiger -s ' tmpfname]};
    {'quit'};
    ];

script4 = [
    {['read_aiger ' tmpfname ';']};
    {'resyn2'};
    {'resyn2rs'};
    {'resyn2rs'};
    {'resyn2rs'};
    {'resyn2rs'};
    {'resyn2rs'};
    {'resyn2rs'};
    {['write_aiger -s ' tmpfname]};
    {'quit'};
    ];


response = invoke_abc(script3);
%for k = 1:numel(response), fprintf('%s\n', response{k}); end

[df, lf, rf, ef] = aiger2mat(tmpfname);




[df, lf, ef] = sort_graph(df, lf, rf, ef);
[sf, cvf] = hara(df, rf, mode, K, maxi, alpha, 0, 0);
[resultdf, resultlf, resultrf, resultef] = rebuild_graph_from_cones(sf, cvf, df, rf, lf, ef);
[lutsf] = cones2luts(resultdf, resultlf, resultrf, resultef);
netlist = mat2ngcedif(dstfname, resultdf, resultlf, resultrf, lutsf, [], [], edif);

toc(t)




%t = tic();
%[d, l, r, e, edif] = ngcedif2mat('C:/Users/jcds/Documents/GitHub/X38-02FO16/matlab/sample_ISE_mapped.edif');
%[d, l, r, e, edif] = ngcedif2mat('C:/Users/jcds/Documents/GitHub/X38-02FO16/workspace/hal_entity.edif');
%toc(t)
%check_network(d, l, r, e);
%bg = build_graph(d, l, r, e);
%view(bg);
%tmpfname = 'C:/Users/jcds/Documents/GitHub/X38-02FO16/workspace/sample_ISE_mapped_SIM_HAL.aig';







%check_network(df, lf, rf, ef);

%check_network(resultdf, resultlf, resultrf, resultef);



%view(build_graph(resultdf, resultlf, resultrf, lutsf));








%view(build_graph(resultdf, resultlf, resultrf, resultef));
%view(build_graph(resultdf, resultlf, resultrf, lutsf));
%[lutsf, inputsf, namesf] = cones2luts(resultlf, resultrf, resultef, []);
    %hara(orderf, iedgef, oedgef, noedgef, df, depthf, heightf, aff, rf, K, DF, mode, maxi, alpha, epsrand(1), epsrand(2));
%[iedgef, oedgef] = prepare_edges(df, rf);
%orderf = graphtopoorder(df);
%redrof = fliplr(orderf);
%depthf = fill_depth(orderf, iedgef, df, rf);
%heightf = fill_height(redrof, oedgef, df, rf);
%[aff, noedgef] = fill_af(orderf, iedgef, oedgef, rf);
%{
    function [out_name] = make_port_name(in_portepr, in_source)
    port = in_portepr.getPort();
    name = char(port.getName());
    if (port.isBus()), bit = ['(' num2str(in_portepr.getSingleBitPort().bitPosition()) ')']; else bit = ''; end
    if (~in_portepr.isTopLevelPortRef())
        prefix = [char(in_portepr.getCellInstance().getName()) ','];
        suffix = '';
	else
        prefix = '';
        if (in_source)
            if (~port.isInputOnly()),  suffix = '@O'; else suffix = ''; end
        else
            if (~port.isOutputOnly()), suffix = '@I'; else suffix = ''; end
        end
    end
    out_name = [prefix name bit suffix];
    end
%}


     %case 'XORCY',   inputs = 2; rename = {'LI', 'CI',                               'O'}; isd = false; tt = '6';
    %case 'XORCY_L', inputs = 2; rename = {'LI', 'CI',                         'LO'};      isd = false; tt = '6'; 
    %case 'XORCY_D', inputs = 2; rename = {'LI', 'CI',                         'LO', 'O'}; isd = true;  tt = '6'; 
    %{
    if (~strncmpi(type, 'LUT', 3)), continue; end

%lutcount = 0;

    instancename = char(instance.getName());
    inputs = str2double(type(4));
    [d, l, r, e] = tt2mat(char(instance.getProperty('INIT').getValue().getStringValue()), inputs);
    
    if (numel(type) < 6)
        rename = cell(1, inputs + 1);
        rename(end) = {'O'};
    elseif (strcmpi(type(6), 'L'))
        rename = cell(1, inputs + 1);
        rename(end) = {'LO'};
    elseif (strcmpi(type(6), 'D'))
        rename = cell(1, inputs + 2);
        rename(end) = {'O'};
        rename(end - 1) = {'LO'};
        [d, l, r, e] = group_nets({d, sparse([], [], [], 1, 1, 1)}, {l, {'lo'}}, {r, prepare_range(0, 0, 1)}, {e, {''}});
        d(get_inode(d, find(strcmpi('o', l))), strcmpi('lo', l)) = 1;
    else
        error('Unknown LUT type.');
    end
    
    for k = 1:inputs, rename{k} = ['I' num2str(k - 1)]; end
    [l, e] = rename_node(d, l, e, [r.pi, r.po], rename);
    [l, e] = make_instance(instancename, d, l, r, e);
    push_net(d, l, r, e);
    lut2uid(instancename) = uid;
    %}
    
    %lutcount = lutcount + 1;
    
%{
c = cell(1, 3);
c{1} = {[1], [1,2], [1,2,3]};
c{2} = {[2], [2,3], [2,3,4]};
c{3} = {[3], [3,4]};

c([1,3])
%}
%{
conea = {[1,2,3]; [1]; [2]; [3]; [4]};
coneb = {[4,5]; [1]; [2]; [3]; [4]};
conec = {[7]; [1]; [2]; [3]; [4]};

cone1 = [conea(:), coneb(:), conec(:)];
cone2 = [conea(:), conec(:)];
cone3 = [conea(:)];
cone4 = [coneb(:), conec(:)];

cones = [{cone1}, {cone2}, {cone3}, {cone4}];

selection = cones([1, 2, 3]);
nodes = selection{2}{1,2};%selection{1}{1,2};
%}
% raiz, fijo(nodos), cono

%{
cone1 = {{[1,2,3]}; {[1]}; {[2]}; {[3]}; {[4]}, ...
    {[2,3,4]}; {[1]}; {[2]}; {[3]}; {[4]}, ...
    {[5,6,7]}; {[1]}; {[2]}; {[3]}; {[4]}};

cones = {
    {
    {[1,2,3]}; {[1]}; {[2]}; {[3]}; {[4]}, ...
    {[2,3,4]}; {[1]}; {[2]}; {[3]}; {[4]}, ...
    {[5,6,7]}; {[1]}; {[2]}; {[3]}; {[4]}
    } , ...
    {
    {[8,9,10]}; {[1]}; {[2]}; {[3]}; {[4]}, ...
    {[11,12,13]}; {[1]}; {[2]}; {[3]}; {[4]}
    } , ...
    {
    {[14,15]}; {[1]}; {[2]}; {[3]}; {[4]}
    }
    };
%}
    %index = k - in_range.pihi;
    %out_luts{index} = strremovespaces(num2str(sum(outputs, 1), '%X'));
    
    
%cell(1, in_range.szin);
%, signals)out_names,out_inputs
%out_inputs = cell(1, in_range.szin);
%out_inputs{index} = regexprep(signals, '[\[\]]', '');
    %regexp_signals(equation);

%translatemap = containers.Map();
%out_labels = cell(1, in_range.sz);
%out_equations = in_equations;
%label = ;
    %newlabel = ;
    %translatemap(['[' label ']']) = ['[' newlabel ']'];
%{
for k = in_range.in
    equation = in_equations{k};
    signals = regexp_signals(equation);
    for s = 1:numel(signals)
        signal = signals{s};
        equation = strrep(equation, signal, translatemap(signal));
    end
    out_equations{k} = equation;
end
%}


%out_names = cell(1, in_range.szin);
    %signals = unique(regexp(equation, '\[\w*,?\w+\]', 'match'));
    %signals = regexp_signals(equation, true, false);
    %inputs = num2cell(repmat([1, 0], ns, 1), 2);
    %inputs = combvec(inputs{:});
    %inputs = tt_inputs(ns, []);
    %out_names{index} = in_labels{k};
%mfilename('fullpath')
%path = 'C:/Users/jcds/Documents/GitHub/X38-02FO16/tools/abc/abc.exe';
%wd = 'C:/Users/jcds/Documents/GitHub/X38-02FO16/tools/abc/';
%{
cmdfifo = C_cmdfifo(script);
spawn_process(path, '', wd, false, script, @(obj, event)stdout_callback_abc(obj, event, cmdfifo));
%}

%path = 'C:/Users/jcds/Documents/GitHub/X38-02FO16/tools/abc/abc.exe';
%wd = 'C:/Users/jcds/Documents/GitHub/X38-02FO16/tools/abc/';
%cmdfifo = ;




%script = [
 %   {['read_aiger ' filename ';']};
%    {'refactor'};
%    {['write_aiger -s ' optname]};
%    {'cec'}
%    {'quit'};
%    ];

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%n = max(edgelist(:));
% n, n);
%, order);
%, in_sorted, in_trim)
%if (in_sorted), order = 'sorted'; else order ='stable'; end
%if (in_trim), out_signals = regexprep(out_signals, '[\[\]]', ''); end
        %in_a
%k
        %signals = regexp_signals(equation, false, true);
        %ina = signals{:};
        %if (~strcmpi(['not([' ina '])'], equation)), error('Unsupported network.'); end
%signals = regexp_signals(equation, false, true);
        %ina = signals{1};
        %if (numel(signals) > 1)
        %inb = signals{2};
        %else
        %    inb = ina;
        %end
        
        %if (~strcmpi(['and([' ina '],[' inb '])'], equation)), error('Unsupported network.'); end
    %dl = [dl, {do}];
    %ll = [ll, {loi}];
    %rl = [rl, {ro}];
    %el = [el, {eoi}];
%signals = unique(regexp(equation, '\[\w+(\(\d+\))?(@[IO])?\]', 'match'));
%{
edges = zeros(2, out_range.szin * 2 + 1);
edgesindex = 0;

for k = out_range.notpi
    for e = nodeiedges(out_labels{k})
        edgesindex = edgesindex + 1;
        edges(:, edgesindex) = [e; k];
    end
end

edges = edges(:, 1:edgesindex);
%}

%in_inputs = 0;%in_inputs;



%in_npi = 0;%in_npi;
%if (in_d), push_node('lo', '', node2uid(nodename)); end
%for k = miniterms(3:end), nodename = push_and(nodename, push_not(k{:})); end
%rows = numel(in_tthex) * 4;
%npi = log2(rows);
%disp('npi')
%disp(npi)
%disp('hex')
%disp(in_tthex); 
%{
if (npi == 1)
    switch (upper(in_tthex))
    case '0', filter = [0, 0];
    case '1', filter = [0, 1];
    case '2', filter = [1, 0];
    case '3', filter = [1, 1];
    end
else
    filter = hexToBinaryVector(in_tthex, rows); %BUG when tthex 0-3 and rows < 4 for 1 input
end
%}

%ttinputs = ttinputs(:, logical(filter));
%ttinputs = tt_inputs(npi, logical(filter));
%, in_filter)
%if (~isempty(in_filter)), out_inputs = out_inputs(:, in_filter); end

%translatemap = containers.Map(in_labels, out_labels);
%
%translatemap = containers.Map();
    %translatemap(label) = newlabel;
    %out_equations = cell(1, in_range.sz);
%out_equations(in_range.top) = {''};

    
    %signals = regexprep(unique(regexp(equation, '\[\w+\]', 'match')), '[\[\]]', '');
    
        
        
    
    
%'mat2ngcedif_LUT_' 

%nets


%{


keys = nets.keys();
remaininginputs = in_inputs;
for k = 1:numel(keys)
    driver = keys{k};
    sinks = nets(driver);
    for i = 1:numel(in_inputs)
        inputlist = in_inputs{i};
        match = find(strcmpi(driver, inputlist));
        if (isempty(match)), continue; end
        for m = match
            sinks = [sinks, {[in_names{i}, '}]
        end
        
    end
    
    
end
%}
%{
for k = in_range.in
    lutname = in_labels{k};
    
    for i = 1:ni
        push_net(inputs{i}, [lutname ',' index2lutinput{i}]);
    end
end
%}
%
%in_range.in
%{
for k = in_range.in
    lutname = in_labels{k};
    adjk = k - in_range.pihi;
    inputs = in_inputs{adjk};
    ni = numel(inputs);
    
    epw.printlnIndent(['(instance ' lutname]);
    epw.incrIndent();
    epw.printlnIndent(['(viewRef black_box (cellRef LUT' index2lutsize{ni} ' (libraryRef UNISIMS)))']);
    epw.printlnIndent('(property XSTLIB (boolean (true)))');
    epw.printlnIndent(['(property INIT (string "' in_luts{adjk} '"))']);
    epw.decrIndent();
    epw.printlnIndent(')');
    
    %lutmap(lutname) = lutname;
    for i = 1:ni, push_net(inputs{i}, [lutname ',' index2lutinput{i}]); end
end
%}



%{
for k = 1:numel(in_luts)
    lutname = in_names{k};
    inputs = in_inputs{k};
    ni = numel(inputs);
    
    
    
    
    
    
end
%}



%fprintf(fid, '%s\n', ['(instance ' char(instance.getName())]);
%fprintf(fid, '%s\n', '

%epw.close();



%epw = edu.byu.ece.edif.core.EdifPrintWriter('mat2ngcedif_UNISIMS.txt');



%epw = edu.byu.ece.edif.core.EdifPrintWriter('mat2ngcedif_topdesign.txt');
%td = ;
%;
%epw.close();

%fid = fopen('mat2ngccedif_topcell.txt', 'w');
%if (fid == -1), error(['Failed to open file ' 'mat2ngccedif_topcell.txt' '.']); end
%dtor = onCleanup(@()fclose(fid));

%
%


%fprintf(fid, '%s\n', );
%fprintf(fid, '%s\n', );
%fprintf(fid, '%s\n', );
%fprintf(fid, '%s\n', );
%fprintf(fid, '%s\n', );
%fprintf(fid, '%s\n', );
%fprintf(fid, '%s\n', );



%epw = edu.byu.ece.edif.core.EdifPrintWriter('mat2ngcedif_topcell_interface.txt');
%tci = ;
%tci;
%epw.close();

%fprintf(fid, '%s\n', );









%lmi = lm.iterator();



%while (lmi.hasNext())
%    l = lmi.next();
%    disp(char(l.getName()));
%end


%lm.toEdif(epw);



%topcell = in_edif.getTopCell();
%edu.byu.ece.edif.core.EdifPrintWriter.printEdifEnvironment(in_filename,  topcell);

%fid = fopen(in_filename, 'w');
%if (fid == -1), error(['Failed to open file ' in_filename '.']); end
%dtor = onCleanup(@()fclose(fid));
%fid = fopen(, 'w');
%{
headerbegin = [
    {0, '(edif top'};
    {1, '(edifVersion 2 0 0)'};
    {1, '(edifLevel 0)'};
    {1, '(keywordMap (keywordLevel 0))'};
    {1, '(status'};
    {2, '(written'};
    {3, ['(timeStamp ' year ' ' month ' ' day ' ' hour ' ' minute ' ' second ')']};
    {3, '(author "matlab")'};
    {3, '(program "mat2ngcedif")'};
    {2, ')'};
    {1, ')'}
    {1, '(external UNISIMS'};
    {2, '(edifLevel 0)'};
    {2, '(technology (numberDefinition))'};
    ];
    
lut4cell = [
    {2, '(cell LUT4'};
    {3, '(cellType GENERIC)'};
    {4, '(view view_1'};
    {5, '(viewType NETLIST)'};
    {5, '(interface '};
    {6, '(port I0'};
    {7, '(direction INPUT)'};
    {6, ')'};
    {6, '(port I1'};
    {7, '(direction INPUT)'};
    {6, ')'};
    {6, '(port I2'};
    {7, '(direction INPUT)'};
    {6, ')'};
    {6, '(port I3'};
    {7, '(direction INPUT)'};
    {6, ')'};
    {6, '(port O'};
    {7, '(direction OUTPUT)'};
    {6, ')'};
    {5, ')'};
    {4, ')'};
    {2, ')'};    
    ];

lut3cell = [
    {2, '(cell LUT3'};
    {3, '(cellType GENERIC)'};
    {4, '(view view_1'};
    {5, '(viewType NETLIST)'};
    {5, '(interface '};
    {6, '(port I0'};
    {7, '(direction INPUT)'};
    {6, ')'};
    {6, '(port I1'};
    {7, '(direction INPUT)'};
    {6, ')'};
    {6, '(port I2'};
    {7, '(direction INPUT)'};
    {6, ')'};
    {6, '(port O'};
    {7, '(direction OUTPUT)'};
    {6, ')'};
    {5, ')'};
    {4, ')'};
    {2, ')'};    
    ];

lut2cell = [
    {2, '(cell LUT2'};
    {3, '(cellType GENERIC)'};
    {4, '(view view_1'};
    {5, '(viewType NETLIST)'};
    {5, '(interface '};
    {6, '(port I0'};
    {7, '(direction INPUT)'};
    {6, ')'};
    {6, '(port I1'};
    {7, '(direction INPUT)'};
    {6, ')'};
    {6, '(port O'};
    {7, '(direction OUTPUT)'};
    {6, ')'};
    {5, ')'};
    {4, ')'};
    {2, ')'};    
    ];

ibufcell = [
    {2, '(cell IBUF'};
    {3, '(cellType GENERIC)'};
    {4, '(view view_1'};
    {5, '(viewType NETLIST)'};
    {5, '(interface'};
    {6, '(port I'};
    {7, '(direction INPUT)'};
    {6, ')'};
    {6, '(port O'};
    {7, '(direction OUTPUT)'};
    {6, ')'};
    {5, ')'};
    {4, ')'};
    {2, ')'};
    ];

obufcell = [
    {2, '(cell OBUF'};
    {3, '(cellType GENERIC)'};
    {4, '(view view_1'};
    {5, '(viewType NETLIST)'};
    {5, '(interface'};
    {6, '(port I'};
    {7, '(direction INPUT)'};
    {6, ')'};
    {6, '(port O'};
    {7, '(direction OUTPUT)'};
    {6, ')'};
    {5, ')'};
    {4, ')'};
    {2, ')'};
    ];

headerstop = {1, ')'};

librarybegin = [
    {1, '(library top_lib'};
    {2, '(edifLevel 0)'};
    {2, '(technology (numberDefinition))'};
    {2, '(cell top'};
    {3, '(cellType GENERIC)'};
    {4, '(view view_1'};
    {5, '(viewType NETLIST)'};
    {5, '(interface'};
    ];

designator = [
    {6, '(designator "xc3s700a-4-fg484")'};
    {6, '(property TYPE (string "top") (owner "Xilinx"))'};
    {6, '(property NLW_UNIQUE_ID (integer 0) (owner "Xilinx"))'};
    {6, '(property NLW_MACRO_TAG (integer 0) (owner "Xilinx"))'};
    {6, '(property NLW_MACRO_ALIAS (string "top_top") (owner "Xilinx"))'};
    {5, ')'};
    {5, '(contents'};
    ];

librarystop = [
    {5, ')'};
    {4, ')'};
    {2, ')'};
    {1, ')'};
    ];

design = [
    {1, '(design top'};
    {2, '(cellRef top'};
    {3, '(libraryRef top_lib)'};
    {2, ')'};
    {2, '(property PART (string "xc3s700a-4-fg484") (owner "Xilinx"))'};
    {1, ')'};
    {0, ')'};
    ];

rs = containers.Map('KeyType', 'char', 'ValueType', 'char');

for k = in_range.pi, rs(in_labels{k}) = [in_labels{k} '_IBUF']; end
for k = in_range.in, rs(in_labels{k}) = [in_labels{k} '_LUT']; end
for k = in_range.po, rs(in_labels{k}) = [in_labels{k} '_OBUF']; end

write_block(headerbegin);
write_block(lut4cell);
write_block(lut3cell);
write_block(lut2cell);
write_block(ibufcell);
write_block(obufcell);
write_block(headerstop);
write_block(librarybegin);

%top i/o
for k = in_range.pi
    fprintf(fid, [indent(6) '(port ' in_labels{k} '\n']);
    fprintf(fid, [indent(7) '(direction INPUT)\n']);
    fprintf(fid, [indent(6) ')\n']);
end

for k = in_range.po
    fprintf(fid, [indent(6) '(port ' in_labels{k} '\n']);
    fprintf(fid, [indent(7) '(direction OUTPUT)\n']);
    fprintf(fid, [indent(6) ')\n']);
end

write_block(designator);

%instances
for k = in_range.in
    fprintf(fid, [indent(6) '(instance ' in_labels{k} '_LUT\n']);
    fprintf(fid, [indent(7) '(viewRef view_1 (cellRef LUT' num2str(numel(in_inputs{k - in_range.pihi})) ' (libraryRef UNISIMS)))\n']);
    fprintf(fid, [indent(7) '(property XSTLIB (boolean (true)) (owner "Xilinx"))\n']);
    fprintf(fid, [indent(7) '(property INIT (string "' in_luts{k - in_range.pihi} '") (owner "Xilinx"))\n']);
    fprintf(fid, [indent(6) ')\n']);
end

for k = in_range.pi
    fprintf(fid, [indent(6) '(instance ' in_labels{k} '_IBUF\n']);
    fprintf(fid, [indent(7) '(viewRef view_1 (cellRef IBUF (libraryRef UNISIMS)))\n']);
    fprintf(fid, [indent(7) '(property XSTLIB (boolean (true)) (owner "Xilinx"))\n']);
    fprintf(fid, [indent(6) ')\n']);
end

for k = in_range.po
    fprintf(fid, [indent(6) '(instance ' in_labels{k} '_OBUF\n']);
    fprintf(fid, [indent(7) '(viewRef view_1 (cellRef OBUF (libraryRef UNISIMS)))\n']);
    fprintf(fid, [indent(7) '(property XSTLIB (boolean (true)) (owner "Xilinx"))\n']);
    fprintf(fid, [indent(6) ')\n']);
end

% and nets
for k = in_range.pi
    fprintf(fid, [indent(6) '(net N_' in_labels{k} '\n']);
    fprintf(fid, [indent(7) '(joined\n']);
    fprintf(fid, [indent(8) '(portRef ' in_labels{k} ')\n']);
    fprintf(fid, [indent(8) '(portRef I (instanceRef ' in_labels{k} '_IBUF))\n']);
    fprintf(fid, [indent(7) ')\n']);
    fprintf(fid, [indent(6) ')\n']);
end

for k = in_range.po
    fprintf(fid, [indent(6) '(net N_' in_labels{k} '\n']);
    fprintf(fid, [indent(7) '(joined\n']);
    fprintf(fid, [indent(8) '(portRef ' in_labels{k} ')\n']);
    fprintf(fid, [indent(8) '(portRef O (instanceRef ' in_labels{k} '_OBUF))\n']);
    fprintf(fid, [indent(7) ')\n']);
    fprintf(fid, [indent(6) ')\n']);
end

for k = in_range.pi    
    fprintf(fid, [indent(6) '(net N_' rs(in_labels{k}) '\n']);
    fprintf(fid, [indent(7) '(joined\n']);
    fprintf(fid, [indent(8) '(portRef O (instanceRef ' rs(in_labels{k}) '))\n']);
    for drives = find(in_delay(k, :))
        if (is_in(drives, in_range))
            fprintf(fid, [indent(8) '(portRef I' num2str(find(strcmp(in_inputs{drives - in_range.pihi}, in_labels{k})) - 1) ' (instanceRef ' rs(in_labels{drives}) '))\n']);
        elseif (is_po(drives, in_range))
            fprintf(fid, [indent(8) '(portRef I (instanceRef ' rs(in_labels{drives}) '))\n']);
        else
            error('!!!!!!');
        end
    end
    fprintf(fid, [indent(7) ')\n']);
    fprintf(fid, [indent(6) ')\n']);
end

for k = in_range.in
    fprintf(fid, [indent(6) '(net N_' rs(in_labels{k}) '\n']);
    fprintf(fid, [indent(7) '(joined\n']);
    fprintf(fid, [indent(8) '(portRef O (instanceRef ' rs(in_labels{k}) '))\n']);
    for drives = find(in_delay(k, :))
        if (is_in(drives, in_range))
            fprintf(fid, [indent(8) '(portRef I' num2str(find(strcmp(in_inputs{drives - in_range.pihi}, in_labels{k})) - 1) ' (instanceRef ' rs(in_labels{drives}) '))\n']);
        elseif (is_po(drives, in_range))
            fprintf(fid, [indent(8) '(portRef I (instanceRef ' rs(in_labels{drives}) '))\n']);
        else
            error('!!!!!!');
        end
    end    
    fprintf(fid, [indent(7) ')\n']);
    fprintf(fid, [indent(6) ')\n']);
end

write_block(librarystop);
write_block(design);

fclose(fid);

%{
fprintf(fid, '(edif top\n');
indent(1);
fprintf(fid, '(edifVersion 2 0 0)\n');
indent(1);
fprintf(fid, '(edifLevel 0)\n');
indent(1);
fprintf(fid, '(keywordMap (keywordLevel 0))\n');
indent(1);
fprintf(fid, '(status\n');
indent(2);
fprintf(fid, '(written\n');
indent(3);
fprintf(fid, '(timeStamp '
%}
    %if (in_level <= 0), return; end
    %fprintf(fid, repmat('    ', 1, in_level));
    
    function write_block(in_block)
    for c = in_block.', fprintf(fid, [indent(c{1}) c{2} '\n']); end
    end

    function [out_ws] = indent(in_level)
    out_ws = repmat('  ', 1, in_level);
    end

    function [out_str] = removelz(in_str)
    if (in_str(1) == '0'), out_str = in_str(2); else out_str = in_str; end
    end
%}
   %{
[lf, ef] = rename_node(df, lf, ef, find(strcmpi('i1_IBUF_renamed_0,O', lf)), {'v61,I2'});
[lf, ef] = rename_node(df, lf, ef, find(strcmpi('i2_IBUF_renamed_1,O', lf)), {'v61,I3'});
[lf, ef] = rename_node(df, lf, ef, find(strcmpi('i3_IBUF_renamed_2,O', lf)), {'v61,I1'});
[lf, ef] = rename_node(df, lf, ef, find(strcmpi('i4_IBUF_renamed_3,O', lf)), {'v61,I0'});
%}
%{
[lf, ef] = rename_node(df, lf, ef, find(strcmpi('i3_IBUF_renamed_2,O', lf)), {'v41,I1'});
[lf, ef] = rename_node(df, lf, ef, find(strcmpi('i4_IBUF_renamed_3,O', lf)), {'v41,I2'});
[lf, ef] = rename_node(df, lf, ef, find(strcmpi('i5_IBUF_renamed_4,O', lf)), {'v41,I0'});
[lf, ef] = rename_node(df, lf, ef, find(strcmpi('i6_IBUF_renamed_5,O', lf)), {'v41,I3'});
%}
%bf = build_graph(df, lf, rf, ef);
%view(bf); 
    
       %signal = ['[' label ']'];
    %newsignal = ['[' out_labels{inode} ']'];
    %for n = onode, out_equations{n} = strrep(out_equations{n}, signal, newsignal); end
    
    
    
    
    
    
    
    %v = [];
    %for n = onode,
    %    if (test_lut(out_labels{n})), v = [v, get_onode(out_delay, n)]; else v = [v, n]; end
    %end
    
    
    
    %for n = v, out_equations{n} = strrep(out_equations{n}, ['[' label ']'], ['[' newlabel ']']); end
    



%size(onode)
%size(inode)
%any(strcmpi('VGA_B_mux0000_0_1136_renamed_275,O', out_labels(cell_collapse(mapremove.values()))))
%out_labels(cell_collapse(mapremove.values())) 
    %while (~isempty(inode) &&  && ~is_in(inode, out_range)),  end
    
    
    
    
    
    
    %{
    for n = onode
        if (is_in(n, out_range))
            out_equations{n} = strrep(out_equations{n}, signal, newsignal);
        else
            
        end
    end
    %}
    
    
    
    
    
    
    
    
    %
    %

%%bg = build_graph(d, l, r, e);
    %%view(bg);
    %%pause
%inode = find(out_delay(:, k));
    %onode = find(out_delay(k, :));
    %onode = find(out_delay(k, :));
    %if (isempty(inode)), error(['Unconnected LUT output ' label '.']); end
    %inode = find(out_delay(:, k));
    %if (strcmpi(label, 'VGA_B_mux0000_0_1136_renamed_275,O'))
    %    disp('IN PI');
    %end
    %{
    %}
    %if (strcmpi(label, 'VGA_B_mux0000_0_1136_renamed_275,O'))
    %    disp('IN PO');
    %end
    %if (strcmpi(label, 'VGA_B_mux0000_0_1136_renamed_275,O'))
    %    disp('IS LUT OUTPUT');
    %end
    %if (strcmpi(label, 'VGA_B_mux0000_0_1136_renamed_275,O'))
    %    disp('INODE');
    %    disp(inode);
    %    disp(out_labels{inode});
    %end
    %if (strcmpi(label, 'VGA_B_mux0000_0_1136_renamed_275,O'))
    %    disp('ONODE');
    %    disp(onode);
    %    for n = onode, disp(out_labels{n}); end
    %end



%if (numel(type) >= 6)
    %    switch (type(6))
    %        case 'L'
    %        case 'D'
    %    end
    %end
    
    

    %, ld = type(6); else ld = []; end
    
    
    
    
    
    
    
    
    
    
    
        
    
    %isd = strcmpi(ld, 'D');
    
    %if (isd), rename = cell(1, inputs + 2); else rename = cell(1, inputs + 1); end
    
    
    
    
    
    
    %rename = cell(1, inputs + 1);
    
    
    
    
    %if (strcmpi(ld, 'L')), renameo = 'LO'; else renameo = 'O'; end
    %inputs = 
    
    
    
    
    
    
    
    
    
    
    %{
    if     (any(strcmpi(type, {'LUT1',   'LUT2',   'LUT3',   'LUT4',   'LUT5',   'LUT6'  })))
    elseif (any(strcmpi(type, {'LUT1_L', 'LUT2_L', 'LUT3_L', 'LUT4_L', 'LUT5_L', 'LUT6_L'})))
    elseif (any(strcmpi(type, {'LUT1_D', 'LUT2_D', 'LUT3_D', 'LUT4_D', 'LUT5_D', 'LUT6_D'})))
    else
    end
%}

%{
    if (~any(strcmpi(type, {'LUT1', 'LUT2', 'LUT3', 'LUT4', 'LUT5', 'LUT6'}))), continue; end
    instancename = char(instance.getName());
    [d, l, r, e] = tt2mat(char(instance.getProperty('INIT').getValue().getStringValue()));
    [l, e] = rename_node(d, l, e, [1, 2, 3, 4, numel(l)], {'I0', 'I1', 'I2', 'I3', 'O'});
    [l, e] = make_instance(instancename, l, r, e);
    push_net(d, l, r, e);
    lut2uid(instancename) = uid;
        %}
%find(out_delay(:, k));
     %{
        
        oldlabeli = out_labels{ii};
        spliti = find(oldlabeli == '_');
        out_labels{ii} = [label oldlabeli(spliti(end - 1):end)];
        %}
        %{
        
        oldlabelo = out_labels{io};
        splito = find(oldlabelo == '_');
        [label oldlabelo(splito(end - 1):end)];
%}   
        %base = [out_range.inlo - l, out_range.polo];
    %otherwise, break;
    %base = ;
    %base = ;
    %out_labels{base + index} = 'a';
       %in_range.inode{k}}))); end 
    %if (numel() ~= numel(equation)), error('Unsupported network.');
        %end
        %if (numel(['not([' ina '])']) ~= numel(equation)), error('Unsupported network.'); end    
        %req = ;
        
%push_not(label, equation(6:(end - 2)));
    %split = strfind(equation, '],[') + 1;
        %push_and(label, equation(6:(split - 2)), equation((split + 2):(end - 2)));
    %{
    equation = in_equations{k};
    start = find(equation == '(', 1);
    label = in_labels{k};

    switch (lower(equation(1:(start - 1))))
    case 'and'
        split = find(equation == ',');
        ns = numel(split);
        if (ns == 3), split = split(2); elseif (ns ~= 1), error('Graph is not AIG.'); end
        push_and(label, equation((start + 2):(split - 2)), equation((split + 2):(end - 2)));
    case 'not'
        push_not(label, equation((start + 2):(end - 2)));
    otherwise
        if (~any(strcmpi(equation, {'0', '1'}))), error('Graph is not AIG.'); end
        push_constant(label, equation);
    end
    %}
%order = graphtopoorder(in_delay);
%inorder = order(is_in(order, in_range));
%inorder%in_range.inorder
%e = nodeiedges(out_labels{k});
    %ne = numel(e);
    %newindex = edgesindex + ne;
    %edges(:, (edgesindex + 1):newindex) = [e; repmat(k, 1, ne)];
        %edges(1, edgesindex) = e;
        %edges(2, edgesindex) = k;
%if (nt == 1)
    %    nodename = miniterms{1};
    %else
%ttinputs = num2cell(repmat([1, 0], npi, 1), 2);
%ttinputs = combvec(ttinputs{:});
%find(in_delay(:, in));
    %[di, dj] = find(in_dl{k});
%find(in_delay(node, :))
%order = graphtopoorder(in_delay);
%order(is_in(order, in_range))
%get_inorder(in_delay, in_range)



   
%get_inode(in_delay, k)




 
    
            
        %if (equation == '1' || equation == '0')
            
        %else
%delta0 = 0;
    %delta1 = 0;
%if (delta0 < 1)
    %    disp(label);
    %end
%disp('delta 0 ----');
    %disp('delta 1 ----');
%fclose(fid);



    %function error_handler(in_msg)
    %fclose(fid);
    %error(in_msg);
    %end
%{
[lo2,  eo2 ] = make_instance('LUT4_02', lo, ro, eo);
[lo3,  eo3 ] = make_instance('LUT4_03', lo, ro, eo);
[lo4,  eo4 ] = make_instance('LUT4_04', lo, ro, eo);
[lo5,  eo5 ] = make_instance('LUT4_05', lo, ro, eo);
[lo6,  eo6 ] = make_instance('LUT4_06', lo, ro, eo);
[lo7,  eo7 ] = make_instance('LUT4_07', lo, ro, eo);
[lo8,  eo8 ] = make_instance('LUT4_08', lo, ro, eo);
[lo9,  eo9 ] = make_instance('LUT4_09', lo, ro, eo);
[lo10, eo10] = make_instance('LUT4_10', lo, ro, eo);
[lo11, eo11] = make_instance('LUT4_11', lo, ro, eo);
[lo12, eo12] = make_instance('LUT4_12', lo, ro, eo);
[lo13, eo13] = make_instance('LUT4_13', lo, ro, eo);
[lo14, eo14] = make_instance('LUT4_14', lo, ro, eo);
[lo15, eo15] = make_instance('LUT4_15', lo, ro, eo);
[lo16, eo16] = make_instance('LUT4_16', lo, ro, eo);

dl = {do,  do,  do,  do,  do,  do,  do,  do,  do,  do,   do,   do,   do,   do,   do,   do};
ll = {lo1, lo2, lo3, lo4, lo5, lo6, lo7, lo8, lo9, lo10, lo11, lo12, lo13, lo14, lo15, lo16};
rl = {ro,  ro,  ro,  ro,  ro,  ro,  ro,  ro,  ro,  ro,   ro,   ro,   ro,   ro,   ro,   ro};
el = {eo1, eo2, eo3, eo4, eo5, eo6, eo7, eo8, eo9, eo10, eo11, eo12, eo13, eo14, eo15, eo16};
%}
%disp(num2str(in_u32));
    %disp(num2str(out_bytes));
        %{
    
    while (bitand(x, 4294967168) ~= 0)
        putc(uint8(bitor(bitand(x, 127), 128)));
        x = bitshift(x, -7);
    end
    putc(uint8(bitand(x, 127)));
    out_bytes = out_bytes(1:wp);
    
        function putc(in_ch)
        wp = wp + 1;
        out_bytes(wp) = in_ch;
        end
        %}
%if (any(strcmpi(in_input, {'0', '1'}))), warning('Constant found'); end
%{
    if (val == 0 || val == 1)
        %warning('Constant');
        if (instancemap.isKey(in_inst)), return; end
        switch (val)
            case 0, push_node('0', 'gnd_');
            case 1, push_node('1', 'vcc_');
        end
        return;
    end
    
    if (is_even(val) || instancemap.isKey(in_inst)), return; end
    push_node(in_inst, 'not_');
    push_edge(num2str(val - 1), in_inst);
    %}

%k = out_range.pi;
%k = out_range.po;
%out_equations(k) = {''};
%out_range.pi
%out_range.in
%out_range.po
%out_range = prepare_range(size(pilist, 2), size(inlist, 2), size(polist, 2));


%{
remap = [
    containers.Map(num2cell(pilist), num2cell(out_range.pi));
    containers.Map(num2cell(inlist), num2cell(out_range.in));
    containers.Map(num2cell(polist), num2cell(out_range.po));
    ];
%}
%{
s2uk = signal2uid.keys();
out_labels(cell2mat(remap.values(signal2uid.values(s2uk)))) = s2uk;
%}
%edgelist = remap.values(num2cell(edgelist));
%out_delay = sparse([edgelist{1, :}], [edgelist{2, :}], 1, n, n);


%remap = 0;

%[do, lo, ro, eo] = tt2mat('D7FF');
%[lo, eo] = make_instance('LUT4_01', lo, ro, eo);

%[d2, l2, r2, e2] = tt2mat('F040');
%[l2, e2] = make_instance('LUT4_02', l2, r2, e2);

%join = [{'LUT4_01,o'; 'LUT4_02,i0'}, ...
%        {'LUT4_01,i1'; 'LUT4_02,i1'}, ...
%        {'LUT4_01,i2'; 'LUT4_02,i2'}, ...
%        {'LUT4_01,i3'; 'LUT4_02,i3'}  ...
%        ];

%[do, lo, ro, eo] = attach_net(do, lo, ro, eo, d2, l2, r2, e2, join);
%[do, lo, ro, eo] = remove_node(do, lo, ro, eo, find(strcmpi(lo, 'LUT4_01,o')));



%bo = build_graph(do, lo, ro, eo);
%view(bo);











%merge_edges(get_graph_edges(out_delay), cell_collapse(mapproxy.values()), out_range.sz)
%{
newedges = zeros(2, edgecount);

for k = 1:edgecount, newedges(:, k) = [signal2index(lutedges{1, k}); signal2index(lutedges{2, k})]; end

out_delay = merge_edges(get_graph_edges(out_delay), newedges, out_range.sz);

for k = out_range.pi
    label = out_labels{k};
    if (~test_lut(label)), continue; end
    mapremove(k) = k;

    inode = find(out_delay(:, k));
    if (isempty(inode)), error(['Unconnected LUT input ' label '.']); end
    newlabel = out_labels{inode};

	onode = find(out_delay(k, :));
    if (isempty(onode)), continue; end
    for n = onode, out_equations{n} = strrep(out_equations{n}, label, newlabel); end
    mapproxy(k) = [repmat(inode, 1, numel(onode)); onode];
end

for k = out_range.po
    label = out_labels{k};
    if (~test_lut(label)), continue; end
    mapremove(k) = k;
    onode = find(out_delay(k, :));
    if (isempty(onode)), continue; end
    mapproxy(k) = [find(out_delay(:, k)); onode];
end

[out_delay, out_labels, out_range, out_equations] = remove_node(merge_edges(get_graph_edges(out_delay), cell_collapse(mapproxy.values()), out_range.sz), out_labels, out_range, out_equations, cell_collapse(mapremove.values()));
%}


%{
    function [out_index] = flatten_index(in_i, in_j)
    end

    function out_edges = get_graph_edges(in_graph)
    [di, dj] = find(in_graph);
    out_edges = [di.'; dj.'];
    end

    function [out_graph] = merge_edges(in_oldedges, in_newedges, in_sz)
    out_graph = sparse([in_oldedges(1, :), in_newedges(1, :)], [in_oldedges(2, :), in_newedges(2, :)], 1, in_sz, in_sz);
    end
%}
%[di, dj] = find(out_delay);
%[di, dj] = find(out_delay);
%out_delay = sparse([di.', newedges(1, :)], [dj.', newedges(2, :)], 1, out_range.sz, out_range.sz);





%[di, dj] = find(out_delay);
%proxyedges = cell_collapse(mapproxy.values());
%out_delay = sparse([dk.', proxyedges(1, :)], [dj.', proxyedges(2, :)], 1, out_range.sz, out_range.sz);
%{
piremove = false(1, out_range.szpi);
    piremove(k) = 1;
%}

%{
    function [out_portindex] = connect_lut_port(in_fullportname, in_source, in_node)
    pd = sparse([], [], [], 1, 1, 1);
    pl = {in_fullportname};
    pe = {''};
    
    if (in_source)
        [out_delay, out_labels, out_range, out_equations] = join_net(pd, pl, prepare_range(1, 0, 0), pe, out_delay, out_labels, out_range, out_equations, {in_fullportname; in_node});
    else
        [out_delay, out_labels, out_range, out_equations] = join_net(out_delay, out_labels, out_range, out_equations, pd, pl, prepare_range(0, 0, 1), pe, {in_node; in_fullportname});
    end
    
    out_portindex = find(strcmpi(in_fullportname, out_labels));
    end
%}

%labels = mapl.values();
%labels = [labels{:}];
%{
    sourceindex = find(strcmpi(sourcefullportname, out_labels));
    if (isempty(sourceindex))
    end
    sinkindex = find(strcmpi(sinkfullportname, out_labels));
    if (isempty(sinkindex))
    end
    %}
    
    
    
    %{
    connect = false;
    sourceindex = find(strcmpi(sourcefullportname, out_labels));
    if (isempty(sourceindex)), sourceindex = connect_lut_port(sourcefullportname, true, sinkfullportname); connect = true; end    
    sinkindex = find(strcmpi(sinkfullportname, out_labels));
    if (isempty(sinkindex)), sinkindex = connect_lut_port(sinkfullportname, false, sourcefullportname); connect = true; end
    
    %
    if (~connect)
    out_delay(sourceindex, sinkindex) = 1;
    end
    %}
%{
    uid = uid + 1;
    uid2d(uid) = d;
    uid2l(uid) = l;
    uid2r(uid) = r;
    uid2e(uid) = e;
    %}

%uid2d = containers.Map('KeyType', 'double', 'ValueType', 'any');
%uid2l = containers.Map('KeyType', 'double', 'ValueType', 'any');
%uid2r = containers.Map('KeyType', 'double', 'ValueType', 'any');
%uid2e = containers.Map('KeyType', 'double', 'ValueType', 'any');

%out_delay = [];
%out_labels = [];
%out_range = [];
%out_equations = [];
%{
    if (uid == 1)
        out_delay = d;
        out_labels = l;
        out_range = r;
        out_equations = e;
    else
        [out_delay, out_labels, out_range, out_equations] = join_net(out_delay, out_labels, out_range, out_equations, d, l, r, e, []);
    end
    %}

%jl = [in_ll{:}];
%je = [in_el{:}];
%jr = [in_rl{:}];
%{
offset = in_rd.sz;
jl = [in_ld, in_ls];



[id, jd] = find(in_dd);
[is, js] = find(in_ds);



sz = in_rd.sz + in_rs.sz;
uidall = 1:sz;
uidremap = C_remap([in_rd.pi, in_rs.pi + offset, in_rd.in, in_rs.in + offset, in_rd.po, in_rs.po + offset], uidall);
allremap = uidremap.remap(uidall);

%out_delay = sparse(uidremap.remap([id.', is.' + offset, edgesi]), uidremap.remap([jd.', js.' + offset, edgesj]), 1, sz, sz);
out_delay = sparse(uidremap.remap([id.', is.' + offset]), uidremap.remap([jd.', js.' + offset]), 1, sz, sz);

out_labels = cell(1, sz);
out_labels(allremap) = jl;

out_equations = cell(1, sz);
out_equations(allremap) = [in_ed, in_es];

out_range = prepare_range(in_rd.szpi + in_rs.szpi, in_rd.szin + in_rs.szin, in_rd.szpo + in_rs.szpo);
%}

%signal2uid = containers.Map(jl, num2cell([in_rd.all, in_rs.all]));
%nj = size(in_join, 2);
%edges = zeros(2, nj);

%for edgesindex = 1:nj, edges(:, edgesindex) = [signal2uid(in_join{1, edgesindex}), signal2uid(in_join{2, edgesindex})]; end
%if (isempty(edges))
%    edgesi = [];
%    edgesj = [];
%else
%    edgesi = edges(1, :);
%    edgesj = edges(2, :);
%end


%alllist = topcell.getPortList();
%pilist = topcell.getInputPorts();
%polist = topcell.getOutputPorts();
%uid2lut = containers.Map();
%lut2net = containers.Map();
%piindex = 0;
%poindex = 0;
%edges = edgesmap.values();
%edges = [edges{:}];
%replacelist = [];
%replacelist = edges(2, :);
%{
nes = in_es;
if (~isempty(replacelist))
for k = unique(replacelist - offset)
    equation = nes{k};
    signals = regexprep(unique(regexp(equation, '\[\w*,?\w+\]', 'match')), '[\[\]]', '');
    for j = 1:numel(signals)
        signal = signals{j};
        if (replacemap.isKey(signal)), equation = regexprep(equation, signal, replacemap(signal)); end
    end
    nes{k} = equation;
end
end
%}





%remove = removemap.values();
%remove = [remove{:}];
%[out_delay, out_labels, out_range, out_equations] = remove_node(out_delay, out_labels, out_range, out_equations, uidremap.remap(remove));
%edgesindex = 0;

%edgesmap = containers.Map('KeyType', 'double', 'ValueType', 'any');



    %edgesindex = edgesindex + 1;


%signal2uidd = containers.Map(in_ld, num2cell(in_rd.all));
%signal2uids = containers.Map(in_ls, num2cell(in_rs.all));

%replacemap = containers.Map();
%removemap = containers.Map('KeyType', 'double', 'ValueType', 'any');
%sink = j{2};
    
    %pit = signal2uids(sink);
    
    
    %onode = pit;
    
    
    %pod = signal2uidd(j{1});
    %inode = pod;
    
    %if (isempty(onode)), continue; end
    %find(in_ds(pit, :));
    %sink
    %if (~is_pi(pit, in_rs)), error('Sink node must be PI.'); end
    %if (is_pi(pod, in_rd)), inode = pod; elseif (is_po(pod, in_rd)), inode = pod; else error('Source node must be PI or PO.'); end
        %find(in_dd(:, pod)); 
    
    %replacemap(sink) = in_ld{inode};
    
    %removemap(index) = pit + offset;
    %assert(numel(sinkindex) == 1);
    
    %assert(numel(sourceindex) == 1);

    %{
        d = sparse([],[],[],1,1,1);
        l = {sourcefullportname};
        r = prepare_range(1,0,0);
        e = {''};
        
        [out_delay, out_labels, out_range, out_equations] = join_net(d, l, r, e, out_delay, out_labels, out_range, out_equations, {sourcefullportname; sinkfullportname});
        %}
        %{
        d = sparse([],[],[],1,1,1);
        l = {sinkfullportname};
        r = prepare_range(0, 0, 1);
        e = {''};
        
        [out_delay, out_labels, out_range, out_equations] = join_net(out_delay, out_labels, out_range, out_equations, d, l, r, e, {sourcefullportname; sinkfullportname});
        %}
    %{
    if (issourcelut && ~issinklut)
        sourceindex = find(strcmpi(sourcefullportname, out_labels));
        assert(numel(sourceindex) == 1);
        sinkindex = find(strcmpi(sinkfullportname, out_labels));
        if (numel(sinkindex) == 1)
            out_delay(sourceindex, sinkindex) = 1;
        elseif (numel(sinkindex) == 0)
            d = sparse([],[],[],1,1,1);
            l = {sinkfullportname};
            r = prepare_range(0, 0, 1);
            e = {''};
            
            [out_delay, ...
                out_labels, ...
                out_range, ...
                out_equations] = join_net(out_delay, out_labels, out_range, out_equations, d, l, r, e, {sourcefullportname; sinkfullportname});
        else
            error('???');
        end
    elseif (~issourcelut && issinklut)
        sinkindex = find(strcmpi(sinkfullportname, out_labels));
        assert(numel(sinkindex) == 1);
        sourceindex = find(strcmpi(sourcefullportname, out_labels));
        if (numel(sourceindex) == 1)
            out_delay(sourceindex, sinkindex) = 1;
        elseif (numel(sourceindex) == 0)
            d = sparse([],[],[],1,1,1);
            l = {sourcefullportname};
            r = prepare_range(1,0,0);
            e = {''};
            
            %sinkfullportname
            %out_labels
            [out_delay, ...
                out_labels, ...
                out_range, ...
                out_equations] = join_net(d, l, r, e, out_delay, out_labels, out_range, out_equations, {sourcefullportname; sinkfullportname});
        else
            error('???');
        end
    elseif (issourcelut && issinklut)
        sinkindex = find(strcmpi(sinkfullportname, out_labels));
        assert(numel(sinkindex) == 1);
        sourceindex = find(strcmpi(sourcefullportname, out_labels));
        assert(numel(sourceindex) == 1);
        
        out_delay(sourceindex, sinkindex) = 1;
    else
    end
    %}



  
    
    %{
    pivot = find(sourcefullportname == ',');
    issourcelut = ~isempty(pivot) && lut2uid.isKey(sourcefullportname(1:(pivot - 1)));
    pivot = find(sinkfullportname == ',');
    issinklut = ~isempty(pivot) && lut2uid.isKey(sinkfullportname(1:pivot - 1));
    %}
    
    
    
    %{
    if (sourceepr.isTopLevelPortRef())
        sourcelut = false;
    else
        sourceinstance = sourceepr.getCellInstance();
        sourceinstancename = char(sourceinstance.getName());
        sourcelut = lut2uid.isKey(sourceinstancename);
    end
    
    if (sinkepr.isTopLevelPortRef())
        sinklut = false;
    else
        sinkinstance = sinkepr.getCellInstance();
        sinkinstancename = char(sinkinstance.getName());
        sinklut = lut2uid.isKey(sinkinstancename);
    end
    %}
    %uid2lut(uid) = in_instance;
    
    
    
    
    
    
    
    %sourceportname = [sourceinstance.getName() ',' char(sourceepr.getPort().getName())];
    
    
    
    
%push_lut(instance);
    %assert(~lut2uid.isKey(instancename));
    %function push_lut(in_instance)
    
    %end


%{
for instance = uid2lut.values()
    lut = instance{:};
    lutname = char(lut.getName());
    
    
    ieprlist = lut.getInputEPRs();
    iepriterator = ieprlist.iterator();
    tail = lut2uid(lutname);
    
    while (iepriterator.hasNext())
        epr = iepriterator.next();
        ii = epr.getCellInstance();
        
        
        
    end
    
    
    
    oepr = lut.getOutputEPRs();
    
    
    
    
end
%}







    

%instancename = char(instance.getName());
%init = char(instance.getProperty('INIT').getValue().getStringValue());
    
    
    
    %
    %make_instance(instancename, labels, range, equations);


%{
    prefix = [instancename ','];
    beginuid = uid;
    instancecell(instancename) = instance;
    
    celloutiterator = celltype.getOutputPorts().iterator();
    while (celloutiterator.hasNext()), push_port(prefix, celloutiterator.next(), ''); end
    instancecopy(instancename) = (beginuid + 1):uid;
    
    celliniterator = celltype.getInputPorts().iterator();
    inputedges = 0;
    while (celliniterator.hasNext()), inputedges = inputedges + celliniterator.next().getWidth(); end
    estimatededges = estimatededges + ((uid - beginuid) * inputedges);
    %}
%topcell = edu.byu.ece.edif.tools.flatten.FlattenedEdifCell(nftopcell);

%{
uid2instance = containers.Map('KeyType', 'double', 'ValueType', 'any'); 
uid = 0;

    function push_lut(in_instance)
    instancename = char(in_instance.getName());        
    if (lut2uid.isKey(instancename)), return; end
    uid = uid + 1;
    lut2uid(instancename) = uid;
    uid2instance(uid) = in_instance;
    end

    function [out_uid] = test_lut(in_epr)
    out_uid = [];
    if (in_epr.isTopLevelPortRef()), return; end
    instance = in_epr.getCellInstance();
    if (~any(strcmpi(char(instance.getCellType().getName()), {'LUT2', 'LUT3', 'LUT4', 'LUT5', 'LUT6'}))), return; end
    
    disp(['Found: ' char(instance.getCellType().getName())]);
    
    push_lut(instance);
    out_uid = lut2uid(char(instance.getName()));
    end



edgesiterator = edges.iterator();
edges = zeros(2, 200);
edgesindex = 0;
edgesmap = containers.Map();


while (edgesiterator.hasNext())
    edge = edgesiterator.next();
    sourceepr = edge.getSourceEPR();
    sinkepr = edge.getSinkEPR();
    
    head = test_lut(sourceepr);
    tail = test_lut(sinkepr);
    
    if (isempty(head) || isempty(tail)), continue; end
    
    edgesindex = edgesindex + 1;
    edges(1, edgesindex) = head;
    edges(2, edgesindex) = tail;
    key = [num2str(head) '->' num2str(tail)];
    
    if (edgesmap.isKey(key))
        edgesmap(key) = [edgesmap(key), {sinkepr.getPort().getName()}];
    else
        edgesmap(key) = {sinkepr.getPort().getName()};
    end
end

edges = edges(:, 1:edgesindex);

out_delay = sparse(edges(1, :), edges(2, :), 1, uid, uid);

keys = lut2uid.keys();
values = cell2mat(lut2uid.values(keys));

out_labels = cell(1, uid);
out_labels(values) = keys;

out_equations = cell(1, uid);

for k = 1:uid
    inst = uid2instance(k);
    init = char(inst.getProperty('INIT').getValue().getStringValue());
    total = numel(init) * 4;
    ns = log2(total);
    inputs = num2cell(repmat([1, 0], ns, 1), 2);
    inputs = combvec(inputs{:});
    mint = zeros(1, total);
    minti = 1;
    
    for c = lower(init)
        switch (c)
        case 'f', keep = [1, 1, 1, 1];
        case 'e', keep = [1, 1, 1, 0];
        case 'd', keep = [1, 1, 0, 1];
        case 'c', keep = [1, 1, 0, 0];
        case 'b', keep = [1, 0, 1, 1];
        case 'a', keep = [1, 0, 1, 0];
        case '9', keep = [1, 0, 0, 1];
        case '8', keep = [1, 0, 0, 0];
        case '7', keep = [0, 1, 1, 1];
        case '6', keep = [0, 1, 1, 0];
        case '5', keep = [0, 1, 0, 1];
        case '4', keep = [0, 1, 0, 0];
        case '3', keep = [0, 0, 1, 1];
        case '2', keep = [0, 0, 1, 0];
        case '1', keep = [0, 0, 0, 1];
        case '0', keep = [0, 0, 0, 0];
        end
        mint(minti:(minti + 3)) = keep;
        minti = minti + 4;
    end
    
    inputs = inputs(:, logical(mint));
    ni = size(inputs, 2);
    mintcell = cell(1, ni);
    
    for n = 1:ni
        input = inputs(:, n);
        mini = ['and(' operand(input(1), 'I0') ',' operand(input(2), 'I1') ')'];
        for i = 3:numel(input)
            mini = strcat('and(', mini, ',', operand(input(i), ['I' num2str(i - 1)]), ')');
        end
        mintcell{n} = mini;
    end
   
    if (ni < 2)
        
    else
        
    end
    
    
    
    %16 -> 6
    %8 -> 5
    %4 -> 4
    %2 -> 3
    %1 -> 2
    
    
    
    
    out_equations{k} = mintcell;
end


    function [out_name] = operand(in_input, in_name)
        if (in_input == 0)
            out_name = ['not(' in_name ')'];
        else
            out_name = in_name;
        end
    end



out_range = [];






%}






















%{
edifenvironment = edu.byu.ece.edif.util.parse.EdifParser.translate(in_filename);
nftopcell = edifenvironment.getTopCell();
topcell = edu.byu.ece.edif.tools.flatten.FlattenedEdifCell(nftopcell);
edifgraph = edu.byu.ece.edif.util.graph.EdifCellInstanceGraph(topcell);
edges = edifgraph.getEdges();

alllist = topcell.getPortList();
pilist = topcell.getInputPorts();
inlist = topcell.getCellInstanceList();
polist = topcell.getOutputPorts();








estimatededges = pilist.size() + (2 * polist.size()) - alllist.size();
signal2uid = containers.Map();
uid = 0;
instancecopy = containers.Map();
instancecell = containers.Map();
edgesmap = containers.Map();


piiterator = pilist.iterator();
while (piiterator.hasNext())
    port = piiterator.next();
    if (~port.isInputOnly()), suffix = '@O'; else suffix = ''; end
    push_port('', port, suffix);
end
szpi = uid;

initerator = inlist.iterator();
while (initerator.hasNext())
    instance = initerator.next();
    instancename = char(instance.getName());
    celltype = instance.getCellType();
    prefix = [instancename ','];
    beginuid = uid;
    instancecell(instancename) = instance;
    
    celloutiterator = celltype.getOutputPorts().iterator();
    while (celloutiterator.hasNext()), push_port(prefix, celloutiterator.next(), ''); end
    instancecopy(instancename) = (beginuid + 1):uid;
    
    celliniterator = celltype.getInputPorts().iterator();
    inputedges = 0;
    while (celliniterator.hasNext()), inputedges = inputedges + celliniterator.next().getWidth(); end
    estimatededges = estimatededges + ((uid - beginuid) * inputedges);
end
szin = uid - szpi;

poiterator = polist.iterator();
while (poiterator.hasNext())
    port = poiterator.next();
    if (~port.isOutputOnly()), suffix = '@I'; else suffix = ''; end
    push_port('', port, suffix);
end
szpo = uid - szin - szpi;   

out_range = prepare_range(szpi, szin, szpo);

out_labels = cell(1, out_range.sz);
keys = signal2uid.keys();
out_labels(cell2mat(signal2uid.values(keys))) = keys;

instancelist = cell(1, out_range.sz);
for k = out_range.in
    label = out_labels{k};
    instancelist{k} = instancecell(label(1:(find(label == ',') - 1)));
end



graphedges = zeros(2, estimatededges);
edgesindex = 0;
edgesiterator = edges.iterator();


while (edgesiterator.hasNext())
    edge = edgesiterator.next();
    sourceepr = edge.getSourceEPR();
    sinkepr = edge.getSinkEPR();
    sourceport = sourceepr.getPort();
    sinkport = sinkepr.getPort();

    sourcename = char(sourceport.getName());
    if (sourceport.isBus()), sourceindex = ['(' num2str(sourceepr.getSingleBitPort().bitPosition()) ')']; else sourceindex = ''; end
    if (~sourceepr.isTopLevelPortRef())
        sourceprefix = [char(sourceepr.getCellInstance().getName()) ','];
        sourcesuffix = '';
    else
        sourceprefix = '';
        if (~sourceport.isInputOnly()), sourcesuffix = '@O'; else sourcesuffix = ''; end
    end
    headuid = signal2uid([sourceprefix sourcename sourceindex sourcesuffix]);

    if (sinkport.isBus()), sinkindex = ['(' num2str(sinkepr.getSingleBitPort().bitPosition()) ')']; else sinkindex = ''; end
    sinkportid = [char(sinkport.getName()) sinkindex];
    if (~sinkepr.isTopLevelPortRef())
        instancename = char(sinkepr.getCellInstance().getName());
        tailuids = instancecopy(instancename);
        sinkportfullname = [instancename ',' sinkportid];
    else
        if (~sinkport.isOutputOnly()), sinksuffix = '@I'; else sinksuffix = ''; end
        sinkportfullname = [sinkportid sinksuffix];
        tailuids = signal2uid(sinkportfullname);
    end

    for tailuid = tailuids
        key = [num2str(headuid) '->' num2str(tailuid)];
        edgesindex = edgesindex + 1;
        if (edgesmap.isKey(key)), app = edgesmap(key); else app = []; end
        edgesmap(key) = [app {sinkportfullname}];
        graphedges(:, edgesindex) = [headuid; tailuid];
    end
end

out_delay = sparse(graphedges(1, :), graphedges(2, :), 1, uid, uid);

order = graphtopoorder(out_delay);

out_descriptor.environment = edifenvironment;
out_descriptor.instances = instancecell;
out_descriptor.edges = edgesmap;
%}
    











%{

%}





%{

%}




%{
not(not(A OR B))
not(notA and notB)
not(and(notA, notB))
A
  OR
B
A INV
      AND INV
B INV
%}


%{






initerator = inlist.iterator();
while (initerator.hasNext())
    instance = initerator.next();
    instancename = char(instance.getName());
    celltype = instance.getCellType();
    prefix = [instancename ','];
    beginuid = uid;
    instancecell(instancename) = instance;
    
    celloutiterator = celltype.getOutputPorts().iterator();
    while (celloutiterator.hasNext()), push_port(prefix, celloutiterator.next(), ''); end
    instancecopy(instancename) = (beginuid + 1):uid;
    
    celliniterator = celltype.getInputPorts().iterator();
    inputedges = 0;
    while (celliniterator.hasNext()), inputedges = inputedges + celliniterator.next().getWidth(); end
    estimatededges = estimatededges + ((uid - beginuid) * inputedges);
end
szin = uid - szpi;



%out_instances = ;
%out_edges = edgesmap;





%}

%instancetype = containers.Map();
%topname =  char(topcell.getName());
%instancetype(instancename) = char(celltype.getName());
%{
out_equations = cell(1, out_range.sz);
out_equations([out_range.pi, out_range.po]) = {''};

for k = out_range.in
    label = out_labels{k};
    top = find(label == ',');
    instance = label(1:(top - 1));
    
    
    switch (lower(instancetype(instance)))
        case 'and2'
            out_equations{k} = instancetype(instance);
        case 'lut4'
        case 'lut3'
        case 'lut2'
        otherwise
            out_equations{k} = ['#' instancetype(instance)];
    end
end
%}
%{
    function push_port(in_prefix, in_port, in_suffix)
    name = char(in_port.getName());
    if (in_port.isBus())
        bpli = in_port.getSingleBitPortList().iterator();
        while (bpli.hasNext()), push_signal([in_prefix name '(' num2str(bpli.next().bitPosition()) ')' in_suffix]); end
    else
        push_signal([in_prefix name in_suffix]);
    end
    end

    function push_signal(in_signal)
    assert(~signal2uid.isKey(in_signal));
    uid = uid + 1;
    signal2uid(in_signal) = uid;
    end
%}
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
%{
K = 4;
DF = false;
mode = 1;
alpha = 1.5; %1.5-2.5
maxi = 20; %20
epsrand = [0.001, 0.005]; %small

[delay, labels, range] = aig2mat('C:/Users/jcds/Documents/GitHub/X38-02FO16/benchmark/LGSynth93/blif-aig/sis_alu4.aig');
%}
%bg = build_graph(delay, labels, range);
%view(bg);

%{
s = sum(delay > 0, 2);
f = find(s < 1);

aigolab = labels(f).';

s = sum(delay > 0, 1);
f = find(s < 1);

aigilab = labels(f).';
%}
%{
t = tic();
[iedge, oedge] = prepare_edges(delay);
order = graphtopoorder(delay);
redro = fliplr(order);

depth = fill_depth(order, iedge, delay, range);
height = fill_height(redro, oedge, delay, range);
[af, noedge] = fill_af(order, iedge, oedge, range);
toc(t)
%}
%{
t = tic();
[s, cv] = hara(order, iedge, oedge, noedge, delay, depth, height, af, range, K, DF, mode, maxi, alpha, epsrand(1), epsrand(2));
toc(t)

t = tic();
[resultdelay, resulttag, resultrange] = rebuild_graph_from_cones(s, cv, delay, range);
toc(t)

[resultiedge, resultoedge] = prepare_edges(resultdelay);
resultorder = graphtopoorder(resultdelay);
resultredro = fliplr(resultorder);

resultdepth = fill_depth(resultorder, resultiedge, resultdelay, resultrange);
resultheight = fill_height(resultredro, resultoedge, resultdelay, resultrange);
[resultaf, resultnoedge] = fill_af(resultorder, resultiedge, resultoedge, resultrange);
%}

%[aagdelay, aaglabels, aagrange] = aag2mat('C:/Users/jcds/Documents/GitHub/X38-02FO16/i10.aag');
%{
s = sum(aigdelay > 0, 2);
f = find(s < 1);

aigolab = aiglabels(f).';

s = sum(aigdelay > 0, 1);
f = find(s < 1);

aigilab = aiglabels(f).';


s = sum(aagdelay > 0, 2);
f = find(s < 1);

aagolab = aaglabels(f).';

s = sum(aagdelay > 0, 1);
f = find(s < 1);

aagilab = aaglabels(f).';
%}


%literal = num2str(next_sequence());
    %disp(['O ' literal]);
    %rh1 = 1;
%if (lhs <= rh0), disp('???'); end
    %if (rh0 < rh1), disp('???'); end
    
    %if (any(rh0 == [658, 702, 3162, 4278, 4724, 5192, 7124])), disp('???'); end
    %if (any(rh1 == [658, 702, 3162, 4278, 4724, 5192, 7124])), disp('???'); end
    
    %if (rh0 < 2), disp('rh0'); end
    %if (rh1 < 2), disp('rh1'); end
%num2str(fread(fid, 1))
%num2str(fread(fid, 1))
%num2str(fread(fid, 1))
%buffer = [];
%bufferpos = 0;

%out_seq = num2str(out_seq);

%out_delay = [];
%out_labels = [];
%out_range = [];

%fclose(fid);

%{
for k = 1:i
    signal = ['i' num2str(k) '_' num2str(input(k))];
    push_signal(signal);
end

for k = 1:l
    sk = num2str(k);
    signal = ['latch' sk 'i_' num2str(latch(k))];
    push_signal(signal);
    
end

for k = 1:o
    seq = next_sequence();
    
end

for k = 1:a
    seq = next_sequence();
    
end

    function push_signal(in_signal)
    end
%}

%;
    %if (seq < 2), disp(['O constante ' num2str(seq)]); end
    %if (seq < 2), disp(['AND I constante ' num2str(seq)]); end
%{
    function [out_ok] = read_next_block()
    if (feof(fid))
        out_ok = false;
        return;
    end
    data = fread(fid, blocksize, 'uint8');
    if (isempty(data))
        out_ok = false;
        return;
    end
    buffer = [buffer, data];
    out_ok = true;
    end
%}
       %{
        %if (isempty(buffer) && ~read_next_block()), error('EOF'); end
        
        
        if (~isempty(buffer))
            for b = buffer(bufferpos:end)
            end
            
        end
        
        
        while (~feof(fid))
            
        end
        %}
    
%[delay, labels, range] = aiger2mat('C:/Users/jcds/desktop/aiglatch.txt');

%bg = build_graph(delay, labels, range);
%view(bg);






%push_signal(in_inst);
%if (invertermap.isKey(in_inst)), return; end
        %invertermap(in_inst) = 1;
%%edges = [edges; {[literal '->' signal]}];
%edges = [edges; {[input1 '->' literal]}];
    %edges = [edges; {[input2 '->' literal]}];
%edges = [edges; {[num2str(newval) '->' in_inst]}];
 
    %out_remap = num2cell(out_final);

%edgelist = edgemap.values();
%edgelist = [edgelist{:}];
%n = max(edgelist(:));
%out_delay = sparse(out_final(1, :), out_final(2, :), 1, n, n);
%out_labels = [];
    
    %push_signal(signal);
    
%out_delay = edges;

%push_instance(literal, signal);
    %push_instance(['s' literal], signal);
%invtest = str2double(literal);
    %
    %li
    
    %uid = uid + 1;
    %signal2uid(str2double(nline{1})) = uid;
    %types{uid} = 2;
    
    %uid = uid + 1;
    
    %{
    latchinput = str2double();
    if (~signal2uid.isKey(latchinput))
        push_signal(latchinput);
        if (isodd(latchinput))
            inv = latchinput - 1;
            if (~signal2uid.iskey(inv))
                push_signal(inv);
            end
            edges = [edges, [inv; latchinput]];
        end
    end
    %}
    %map() = uid;
    %types{uid} = 3;
%types{uid} = 1;


%types = cell(1000);
%invertermap = containers.Map();
%push_instance('0', 'c_low');
%push_signal('c_low');
%push_instance('1', 'c_high');
%push_signal('c_high');



%out_raw = edges;
    


%out_intermediate = edges;




%input1 = nline{2};
%{
    signal = ['inv1_' in_inst];    
    push_head_node(in_inst, signal);
    add_in_list(signal2uid(signal));
    %}
        %newval = ;
%push_instance(in_inst, signal);
    %push_signal(signal);
%{
    literal = nline;
    signal = ['i_' num2str(k)];
    push_instance(literal, signal);
    push_signal(signal);    
    add_pi_list(signal2uid(signal));
    %}
    %{
    literal = nline{1};
    signal = ['latch_i_' num2str(k)];
    push_instance(literal, signal);
    push_signal(signal);    
    add_pi_list(signal2uid(signal));
    %}
    %{
    literal = nline{2};
    signal = ['latch_o_' num2str(k)];
    push_signal(signal);
    try_push_inverter(literal);    
    push_edge(literal, signal);    
    add_po_list(signal2uid(signal));
    %}
    %{
    literal = nline;
    signal = ['o_' num2str(k)];
    push_signal(signal);
    try_push_inverter(literal);    
    push_edge(literal, signal);    
    add_po_list(signal2uid(signal));
    %}
%{
    literal = nline{1};
    signal = ['and_2_' num2str(k)];
    push_instance(literal, signal);
    push_signal(signal);    
    add_in_list(signal2uid(signal));
    %}

  %{
    input1 = nline{2};
    try_push_inverter(input1);    
    push_edge(input1, literal);
    %}
    %{
    input2 = nline{3};
    try_push_inverter(input2);    
    push_edge(input2, literal);
    %}


%inlist = [inlist, signal2uid(ss)];
        %edges = [edges, {in_head; in_tail}];
%pilist = [pilist, signal2uid(signal)];
    %pilist = [pilist, signal2uid(signal)];
    %polist = [polist, signal2uid(signal)];
    %inlist = [inlist, signal2uid(signal)];
    %polist = [polist, signal2uid(signal)];
    %edges = [];





   %literal = nline;
        %literal = nline{2}; 

    
    

    %function add_pi_list(in_uid)
    
    %end

    %function add_po_list(in_uid)
    
    %end

    %function add_in_list(in_uid)
    
    %end

%add_pi_list(signal2uid(signal));
%add_po_list(signal2uid(signal));
%add_in_list(signal2uid(signal));
    
%{
    %%%EST
(3 * a) + i + o + (2 * l)
edgesindex
i + l
piindex
o + l
poindex
(2 * a) + i
inindex
%}


    






    


    



%{
K = 3;
DF = false;
mode = 1;
alpha = 1.5; %1.5-2.5
maxi = 20; %20
epsrand = [0.001, 0.005]; %small

t = tic();

%[delay, labels, range] = sample_valavan();
%[delay, labels, range] = sample_aaghalfadder();
[delay, labels, range] = sample_aaglatch();

[iedge, oedge] = prepare_edges(delay);
order = graphtopoorder(delay);
redro = fliplr(order);
depth = fill_depth(order, iedge, delay, range);
height = fill_height(redro, oedge, delay, range);
[af, noedge] = fill_af(order, iedge, oedge, range);
equations = get_aig_equations(iedge, labels, range);

[s, cv] = hara(order, iedge, oedge, noedge, delay, depth, height, af, range, K, DF, mode, maxi, alpha, epsrand(1), epsrand(2));

[result_delay, newlabels, result_range, resultequations] = rebuild_graph_from_cones(s, cv, delay, range, labels, equations);

toc(t)

bg = build_graph(delay, labels, range, equations);
view(bg);

br = build_graph(result_delay, newlabels, result_range, resultequations);
view(br);

[LUTS, lutinputs] = cones2luts(result_range, resultequations);




%}
    %{
indices = find(resulttag);
[~, I] = sort(resulttag(indices));
newlabels = [labels(range.pi), labels(indices(I)+double(range.szpi)), labels(range.po)];
%}

    %{
    equation = in_equations{cvidx + ofs};
    if (subn < 2)
        out_equations{i2} = equation;
        continue;
    end
    %}
%out_equation{i2} = strrep(out_equation{i2}, in_labels{l}, ['(' in_equations{l} ')']);
%for j = in_range.po
    %    d = in_delay(i, j);
    %    if (d > 0), push_edge(i, j - poofs, in_delay(i, j)); end
    %end

%node2uid = containers.Map(in_labels, num2cell(1:in_range.sz));
%out_delay = spalloc(nsz, nsz, maxedges);
%delay = in_delay(e1, e(2));
        %out_delay(i1, i2) = delay;
        %delay = in_delay(e(1), e2);
        %out_delay(i2, i1) = delay;
%out_x = [];
%res
    
    %outi = 0;
    %signalmap = containers.Map(signals, num2cell(0:(ns - 1)));
    %outi = outi + 1;
    %x = inputs
    %zeros(4, numel(inputs) / 4); 
    
    
    
    
    %signals
    %inputs
%    %{
%{
global CONFIG

CONFIG.EQN_NFGETS = 4096;
CONFIG.EQN_BUFFERSIZE = 16384;
CONFIG.EQN_NEDGES = 8192;

K = 4;
DF = false;
mode = 1;
alpha = 1.5; %1.5-2.5
maxi = 20; %20
epsrand = [0.001, 0.005]; %small

t = tic();
feqn = fopen('alu4_i.eqn', 'rt');
[delay, range, labels, equations] = eqn2mat(feqn);
fclose(feqn);
toc(t)
%}
%$}
%{
t = tic();
[iedge, oedge] = prepare_edges(delay);
order = graphtopoorder(delay);
redro = fliplr(order);

depth = fill_depth(order, iedge, delay, range);
height = fill_height(redro, oedge, delay, range);
[af, noedge] = fill_af(order, iedge, oedge, range);
toc(t)

t = tic();
[s, cv] = hara(order, iedge, oedge, noedge, delay, depth, height, af, range, K, DF, mode, maxi, alpha, epsrand(1), epsrand(2));
toc(t)

t = tic();
[resultdelay, resulttag, resultrange] = rebuild_graph_from_cones(s, cv, delay, range);
toc(t)

[resultiedge, resultoedge] = prepare_edges(resultdelay);
resultorder = graphtopoorder(resultdelay);
resultredro = fliplr(resultorder);

resultdepth = fill_depth(resultorder, resultiedge, resultdelay, resultrange);
resultheight = fill_height(resultredro, resultoedge, resultdelay, resultrange);
[resultaf, resultnoedge] = fill_af(resultorder, resultiedge, resultoedge, resultrange);

%}











%feqn = fopen('dsip_PROC.eqn', 'rt');
%feqn = fopen('C6288_proc.eqn', 'rt');


%{
while (true)
    next = fgets(in_feqn, 4096);
    if (next == -1), break; end
    if (next(end) == nl), line = line + 1; end
    fl = [fl, next];    
    flindex = find(fl == ';');
    if (numel(flindex) < 1), continue; end
    flindex = flindex(1);
    parse_statement(fl(1:flindex));
	fl(1:flindex) = [];
end
%}
%rp = 1;
%nrp = rp + step;
    %flindex = find(fl(rp:(nrp - 1)) == ';');
    
    %fib = rp;
    %rp = nrp;
   
        
    
    
    %rp = 1;
    
    %flindex = flindex(1);
    %fl = [fl, next];    
    
    
	%fl(1:flindex) = [];

    %uid2signal(uid) = in_str;

    %function push_signal_list(in_list)
    %for signal = in_list, try_add_signal(signal{1}, true, false, false); end
    %end

%haspilist = false;
%haspolist = false;
%uid2signal = containers.Map('KeyType', 'double', 'ValueType', 'char');
%out_edges = [];
%t1 = 0;
%tt = 0;
%tn = 0;

%out_statements = [];
%flindex = 1;
    


%out_edges = edges;
%pi
%po
%numel(in)
%numel(allnodes)

%





%{
    for c = fl(flindex:end)
        if (c ~= ';'),
            if (c == nl), line = line + 1; end
            flindex = flindex + 1;
            continue;
        end
        parse_statement(fl(1:flindex));
        fl(1:flindex) = [];
        flindex = 1;
        break;
    end
    %}

%out_edges = [celledges{1:end}];
%out_signals = signal2uid;

%%if (signal2uid.isKey(in_str)), return; end, parse_error(['Duplicate signal ''' in_str '''']); end

    	%if (in_allownot && (in_str(1) == '!')), tss = in_str(2:end); else tss = in_str; end
    %if (in_allownot && (in_str(1) == '!')), tss = in_str(2:end); else tss = in_str; end

    
        %{
pivot = 0;
        for ch = in_s
            pivot = pivot + 1;
            if (ch ~= '='), continue; end
            lstr = strtrim(in_s(1:(pivot - 1)));
            rstr = strtrim(in_s((pivot + 1):(end-1)));
            break;
        end
        %}
%{
t1 = tic();
                
                
                
                t1 = toc(t1);
                tt = tt + t1;
                tn = tn + 1;
%}
%out_mat = [out_mat; {in_s}];
%if (haspilist), parse_error('INORDER redefinition'); end
                %push_signal_list(strtrim(strsplit(rstr)));
                %haspilist = true;
                %if (haspolist), parse_error('OUTORDER redefinition'); end
                %push_signal_list(strtrim(strsplit(rstr)));
                %haspolist = true;
%if (ss(1) == '!')
                        %    tss = ss(2:end);
                        %else
                        %    tss = ss;
                        %end
                        %try_add_signal(tss)
                        
                        
                        %if (~test_name(tss) && ~test_id(tss)), parse_error('Unexpected expression'); end
%str = ;
        %if (~test_name(str))
        %if (signal2uid.isKey(str)), parse_error(['Duplicate signal ''' str '''']); end

%if (~testname(lstr) && test_id(str)), parse_error(['Unexpected token ''' str '''']); end
                %if (signal2uid.isKey(str)), parse_error(['Duplicate signal ''' str '''']); end
        %push_node_list()
                
                %{
                for pi = listpi
                    str = pi{1};
                    alphanum = isstrprop(str, 'alphanum');
                    us = str == '_';
                    an1 = isstrprop(str, 'alpha');                    
                    if (~all(alphanum | us) || ~(an1 || us(1))), parse_error(['Unexpected token ''' str '''']); end
                    if (signal2uid.isKey(str)), parse_error(['Duplicate signal ''' str '''']); end
                end
                %}
                
        %expr = strsplit(in_s);
        
        
        
        
        %and * or + not ! xor ^

