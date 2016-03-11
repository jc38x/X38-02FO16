%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************
% References
% http://fmv.jku.at/aiger/
%**************************************************************************

function [out_delay, out_labels, out_range] = aig2mat(in_filename)
fid = fopen(in_filename, 'r');
if (fid == -1), error(['Failed to open file ' in_filename '.']); end
header = strsplitntrim(fgetl(fid), ' ');
if (~strcmp(header{1}, 'aig')), error('File is not binary AIGER.'); end

m = str2double(header{2});
i = str2double(header{3});
l = str2double(header{4});
o = str2double(header{5});
a = str2double(header{6});

if (m < 0), error('M < 0.'); end
if (i < 0), error('I < 0.'); end
if (l < 0), error('L < 0.'); end
if (o < 0), error('O < 0.'); end
if (a < 0), error('A < 0.'); end

input = 2*(1:i);
latch = 2*((i + 1):(i + l));
and = 2*((i + l + 1):(i + l + a));

input = strtrim(cellstr(num2str(input.')).');
latch = strtrim(cellstr(num2str(latch.')).');
andliteral = strtrim(cellstr(num2str(and.')).');

instancemap = containers.Map('KeyType', 'char', 'ValueType', 'char');
signal2uid = containers.Map();
uid = 0;
edges = cell(2, (3 * a) + i + o + (2 * l));
edgesindex = 0;
pilist = zeros(1, i + l);
piindex = 0;
polist = zeros(1, o + l);
poindex = 0;
inlist = zeros(1, (2 * a) + i);
inindex = 0;

for k = 1:i, push_input_port(input{k}, ['i' num2str(k) '_']); end

for k = 1:l
    sk = num2str(k);
    push_input_port(latch{k}, ['latch' sk 'i_']);
    push_output_port(strtrim(fgetl(fid)), ['latch' sk 'o_']);
end

for k = 1:o, push_output_port(strtrim(fgetl(fid)), ['o' num2str(k) '_']); end

for k = 1:a
    literal = andliteral{k};
    push_node(literal, 'and2_');  
    rh0 = and(k) - next_sequence();
    make_and_input(num2str(rh0), literal);      
    make_and_input(num2str(rh0 - next_sequence()), literal);
end

fclose(fid);

pilist = pilist(1:piindex);
inlist = inlist(1:inindex);
polist = polist(1:poindex);

pilo = 1;
pihi = size(pilist, 2);
inlo = pihi + 1;
inhi = pihi + size(inlist, 2);
polo = inhi + 1;
pohi = inhi + size(polist, 2);

out_range = prepare_range(pilo, pihi, inlo, inhi, polo, pohi);

remap = [
    containers.Map(pilist, num2cell(out_range.pi));
    containers.Map(inlist, num2cell(out_range.in));
    containers.Map(polist, num2cell(out_range.po));
    ];

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
edgelist = remap.values(num2cell(edgelist));

out_delay = sparse([edgelist{1, :}], [edgelist{2, :}], 1, n, n);

s2uk = signal2uid.keys();
out_labels(cell2mat(remap.values(signal2uid.values(s2uk)))) = s2uk;

    function push_signal(in_signal)
    if (signal2uid.isKey(in_signal)), return; end
    uid = uid + 1;
    signal2uid(in_signal) = uid;
    end

    function push_instance(in_inst, in_signal)
    if (instancemap.isKey(in_inst)), error(['Duplicate instance ' in_inst '.']); end
    instancemap(in_inst) = in_signal;
    end

    function push_edge(in_head, in_tail)
    edgesindex = edgesindex + 1;
    edges(:, edgesindex) = {in_head; in_tail};
    end

    function try_push_inverter(in_inst)
    val = str2double(in_inst);
    if (is_even(val) || instancemap.isKey(in_inst)), return; end
    push_node(in_inst, 'inv1_');
    push_edge(num2str(val - 1), in_inst);
    end

    function make_and_input(in_input, in_literal)
    try_push_inverter(in_input);
    push_edge(in_input, in_literal);
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
