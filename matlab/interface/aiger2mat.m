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
header = strsplitntrim(fgetl(fid), ' ');
fmt = header{1};
if (~strcmp(header{1}, fmt)), error_handler(['Unexpected format identifier ''' fmt '''. Expected ''aig''']); end

m = str2double(header{2});
i = str2double(header{3});
l = str2double(header{4});
o = str2double(header{5});
a = str2double(header{6});

if (m < 0), error_handler('M < 0.'); end
if (i < 0), error_handler('I < 0.'); end
if (l < 0), error_handler('L < 0.'); end
if (o < 0), error_handler('O < 0.'); end
if (a < 0), error_handler('A < 0.'); end

ii = 2 * (1:i);
li = 2 * ((i + 1):(i + l));
ai = 2 * ((i + l + 1):(i + l + a));

input = strtrim(cellstr(num2str(ii.')).');
latch = strtrim(cellstr(num2str(li.')).');
and   = strtrim(cellstr(num2str(ai.')).');

instancemap = containers.Map();
signal2uid  = containers.Map();

edges  = cell(2, (3 * a) + i + o + (2 * l) + 2);
pilist = zeros(1, i + l);
inlist = zeros(1, (2 * a) + i + 2);
polist = zeros(1, o + l);

uid        = 0;
edgesindex = 0;
piindex    = 0;
poindex    = 0;
inindex    = 0;

for k = 1:i, push_input_port(input{k}, ['i_' num2str(k) '_']); end

for k = 1:l
    sk = num2str(k);
    push_input_port(latch{k}, ['latch_' sk '_i_']);
    push_output_port(strtrim(fgetl(fid)), ['latch_' sk '_o_']);
end

for k = 1:o, push_output_port(strtrim(fgetl(fid)), ['o_' num2str(k) '_']); end

for k = 1:a
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

uidremap = C_remap([pilist, inlist, polist], 1:out_range.sz);

s2uk = signal2uid.keys();
out_labels = cell(1, out_range.sz);
out_labels(uidremap.remap(cell_collapse(signal2uid.values(s2uk)))) = s2uk;

while (~feof(fid))
    symbol = fgetl(fid);
    type = symbol(1);
    
    switch (type)
    case 'i', base = out_range.pilo;
    case 'o', base = out_range.polo;
    case 'l', base = out_range.inlo - l;
    case 'c', break;
    end
    
    split = find(symbol == ' ', 1);
    out_labels{base + str2double(symbol(2:(split - 1)))} = symbol((split + 1):end);
end

fclose(fid);

edges = edges(:, 1:edgesindex);

for n = 1:size(edges, 2)
    literal = edges{1, n};
    if (instancemap.isKey(literal)), edges{1, n} = instancemap(literal); end
    literal = edges{2, n};
    if (instancemap.isKey(literal)), edges{2, n} = instancemap(literal); end
end

edgelist = signal2uid.values(edges);
edgelist = cell2mat(edgelist);
n = max(edgelist(:));

edgelist = uidremap.remap(edgelist);
out_delay = sparse(edgelist(1, :), edgelist(2, :), 1, n, n);

out_equations = cell(1, out_range.sz);
out_equations(out_range.top) = {''};

for k = out_range.in
    label = out_labels{k};
    ie = find(out_delay(:, k));
    switch (label(1:3))
    case 'and', out_equations{k} = ['and([' out_labels{ie(1)} '],[' out_labels{ie(2)} '])'];
    case 'not', out_equations{k} = ['not([' out_labels{ie(1)} '])'];
    case 'vcc', out_equations{k} = '1';
    case 'gnd', out_equations{k} = '0';
    end
end

    function error_handler(in_msg)
    fclose(fid);
    error(in_msg);
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
    if (instancemap.isKey(in_inst)), error_handler(['Duplicate instance ' in_inst '.']); end
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
    if (feof(fid)), error_handler('Unexpected EOF.'); end
    out_byte = fread(fid, 1, 'uint8');
    if (isempty(out_byte)), error_handler('File read failed.'); end
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
