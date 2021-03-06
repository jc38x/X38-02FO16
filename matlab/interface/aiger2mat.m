%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************
% References
% http://fmv.jku.at/aiger/
%**************************************************************************

function [out_delay, out_labels, out_range, out_equations] = aiger2mat(in_filename)
fid = fopen(in_filename, 'r');
if (fid == -1), error(['Failed to open file ' in_filename '.']); end
dtor = onCleanup(@()fclose(fid));

header = strsplitntrim(fgetl(fid), ' ');
fmt = header{1};

if (~strcmp(fmt, 'aig')), error(['Unexpected format identifier ''' fmt '''. Expected ''aig''.']); end
if (numel(header) > 6), error('Header BCJF not supported.'); end

vm = str2double(header{2});
vi = str2double(header{3});
vl = str2double(header{4});
vo = str2double(header{5});
va = str2double(header{6});

if (vm < 0), error('M < 0.'); end
if (vi < 0), error('I < 0.'); end
if (vl < 0), error('L < 0.'); end
if (vo < 0), error('O < 0.'); end
if (va < 0), error('A < 0.'); end

ii = 2 * (1:vi);
li = 2 * ((vi + 1):(vi + vl));
ai = 2 * ((vi + vl + 1):(vi + vl + va));

input = strtrim(cellstr(num2str(ii.')).');
latch = strtrim(cellstr(num2str(li.')).');
and   = strtrim(cellstr(num2str(ai.')).');

instancemap = containers.Map();
signal2uid  = containers.Map();

edges  = cell(2, (3 * va) + vi + vo + (2 * vl) + 2);
pilist = zeros(1, vi + vl);
inlist = zeros(1, (2 * va) + vi + 2);
polist = zeros(1, vo + vl);

uid        = 0;
edgesindex = 0;
piindex    = 0;
poindex    = 0;
inindex    = 0;

for k = 1:vi, push_input_port(input{k}, ['i_' num2str(k) '_']); end

for k = 1:vl
    sk = num2str(k);
    push_input_port(latch{k}, ['latch_' sk '_i_']);
    push_output_port(strtrim(fgetl(fid)), ['latch_' sk '_o_']);
end

for k = 1:vo, push_output_port(strtrim(fgetl(fid)), ['o_' num2str(k) '_']); end

for k = 1:va
    literal = and{k};
    push_node(literal, 'and_');
    rh0 = ai(k) - next_sequence();
    make_and_input(num2str(rh0), literal);
    make_and_input(num2str(rh0 - next_sequence()), literal);
end

pilist = pilist(1:piindex);
inlist = inlist(1:inindex);
polist = polist(1:poindex);

out_range = prepare_range(piindex, inindex, poindex);

uidremap = C_remap([pilist, inlist, polist], out_range.all);

s2uk = signal2uid.keys();
out_labels = cell(1, out_range.sz);
out_labels(uidremap.remap(cell2mat(signal2uid.values(s2uk)))) = s2uk;

out_equations = cell(1, out_range.sz);

for k = out_range.top
    if (strncmp(out_labels{k}, 'l', 1)), out_equations{k} = '#AIGERLATCH'; else out_equations{k} = ''; end
end

while (~feof(fid))
    symbol = fgetl(fid);    
    if (~any(strncmpi(symbol, {'i', 'o', 'l'}, 1))), break; end

    split = find(symbol == ' ', 1);
    index = str2double(symbol(2:(split - 1)));
    label = symbol((split + 1):end);

    switch (symbol(1))
    case 'i', out_labels{out_range.pilo     + index} = label;
    case 'o', out_labels{out_range.polo + vl + index} = label;
    case 'l'
        ii = out_range.inlo - vl + index;
        io = out_range.polo     + index;
        out_labels{ii} = rename_latch(ii, label);
        out_labels{io} = rename_latch(io, label);
    end
end

edges = edges(:, 1:edgesindex);

for n = 1:size(edges, 2)
    literal = edges{1, n};
    if (instancemap.isKey(literal)), edges{1, n} = instancemap(literal); end
    literal = edges{2, n};
    if (instancemap.isKey(literal)), edges{2, n} = instancemap(literal); end
end

edgelist = cell2mat(signal2uid.values(edges));
out_delay = sparse(uidremap.remap(edgelist(1, :)), uidremap.remap(edgelist(2, :)), 1, out_range.sz, out_range.sz);

for k = out_range.in
    label = out_labels{k};
    ie = get_inode(out_delay, k);
    switch (label(1:3))
    case 'and', out_equations{k} = ['and([' out_labels{ie(1)} '],[' out_labels{ie(end)} '])'];
    case 'not', out_equations{k} = ['not([' out_labels{ie} '])'];
    case 'vcc', out_equations{k} = '1';
    case 'gnd', out_equations{k} = '0';
    end
end

    function [out_label] = rename_latch(in_index, in_label)
    oldlabel = out_labels{in_index};
    tag = find(oldlabel == '_');
    out_label = [in_label oldlabel(tag(end - 1):end)];
    end

    function push_signal(in_signal)
    if (signal2uid.isKey(in_signal)), return; end
    uid = uid + 1;
    signal2uid(in_signal) = uid;
    end

    function push_edge(in_head, in_tail)
    edgesindex = edgesindex + 1;
    edges(:, edgesindex) = {in_head; in_tail};
    end

    function try_push_inverter(in_inst)
    if (instancemap.isKey(in_inst)), return; end
    val = str2double(in_inst);
    switch (val)
    case 0, push_node('0', 'gnd_');
    case 1, push_node('1', 'vcc_');
    otherwise
        if (is_even(val)), return; end
        push_node(in_inst, 'not_');
        push_edge(num2str(val - 1), in_inst);
    end
    end
    
    function make_and_input(in_input, in_literal)  
    try_push_inverter(in_input);
    push_edge(in_input, in_literal);
    end
    
    function push_instance(in_inst, in_signal)
    if (instancemap.isKey(in_inst)), error(['Duplicate instance ' in_inst '.']); end
    instancemap(in_inst) = in_signal;
    end
    
    function push_head_node(in_literal, in_signal)
    push_instance(in_literal, in_signal);
    push_signal(in_signal);
    end
    
    function push_input_port(in_literal, in_prefix)
    signal = [in_prefix in_literal];
    push_head_node(in_literal, signal);
    piindex = piindex + 1;
    pilist(piindex) = signal2uid(signal);
    end
    
    function push_output_port(in_literal, in_prefix)
    signal = [in_prefix in_literal];
    push_signal(signal);
    try_push_inverter(in_literal);
    push_edge(in_literal, signal);
    poindex = poindex + 1;
    polist(poindex) = signal2uid(signal);
    end
    
    function push_node(in_literal, in_prefix)
    signal = [in_prefix in_literal];
    push_head_node(in_literal, signal);
    inindex = inindex + 1;
    inlist(inindex) = signal2uid(signal);
    end
    
    function [out_byte] = next_byte()
    if (feof(fid)), error('Unexpected EOF.'); end
    out_byte = fread(fid, 1, 'uint8');
    if (isempty(out_byte)), error('File read failed.'); end
    end
    
    function [out_seq] = next_sequence()
    data = next_byte();
    out_seq = bitand(data, 127);
    p = 1;
    while (bitand(data, 128))
        data = next_byte();
        out_seq = out_seq + (bitand(data, 127) * (2 ^ (7 * p)));
        p = p + 1;
    end
    end
end
