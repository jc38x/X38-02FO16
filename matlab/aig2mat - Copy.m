
function [out_delay, out_labels, out_range] = aig2mat(in_filename)
fid = fopen(in_filename, 'r');
if (fid == -1), error(['Failed to open file ' in_filename '.']); end
header = strsplitntrim(fgetl(fid), ' ');
name = header{1};
if (~strcmp(name(1:3), 'aig')), error('File is not binary AIGER'); end

m = str2double(header{2});
i = str2double(header{3});
l = str2double(header{4});
o = str2double(header{5});
a = str2double(header{6});

if (m < 0), error('M < 0'); end
if (i < 0), error('I < 0'); end
if (l < 0), error('L < 0'); end
if (o < 0), error('O < 0'); end
if (a < 0), error('A < 0'); end



input = 2*(1:i);
latch = 2*((i + 1):(i + l));
and = 2*((i + l + 1):(i + l + a));


input = strtrim(cellstr(num2str(input.')).');
latch = strtrim(cellstr(num2str(latch.')).');
andliteral = strtrim(cellstr(num2str(and.')).');

%buffer = [];
%bufferpos = 0;



%out_delay = [];
%out_labels = [];
%out_range = [];

%fclose(fid);


    function [out_seq] = next_sequence()
        data = fread(fid, 1, 'uint8');
        out_seq = bitand(data, 127);
        p = 1;
        while (bitand(data, 128))
            data = fread(fid, 1, 'uint8');
            out_seq = out_seq + (bitand(data, 127) * (2 ^ (7 * p)));
            p = p + 1;
        end
        %out_seq = num2str(out_seq);
    end






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

for k = 1:i
    push_input_port(input{k}, ['i' num2str(k) '_']);
end

for k = 1:l
    sk = num2str(k);
    push_input_port(latch{k}, ['latch' sk 'i_']);
    
    
    
    
    push_output_port(num2str(next_sequence()), ['latch' sk 'o_']);
end

for k = 1:o
    literal = num2str(next_sequence());
    %disp(['O ' literal]);
    push_output_port(literal, ['o' num2str(k) '_']);
end

for k = 1:a
    literal = andliteral{k};
    lhs = and(k);
    push_node(literal, 'and2_');
    
    
    delta0 = next_sequence();
    delta1 = next_sequence();
    
    rh0 = lhs - delta0;
    rh1 = rh0 - delta1;
    
    if (lhs <= rh0), disp('???'); end
    if (rh0 < rh1), disp('???'); end
    
    if (any(rh0 == [658, 702, 3162, 4278, 4724, 5192, 7124])), disp('???'); end
    if (any(rh1 == [658, 702, 3162, 4278, 4724, 5192, 7124])), disp('???'); end
    
    if (rh0 < 2), disp('rh0'); end
    if (rh1 < 2), disp('rh1'); end
    
    make_and_input(num2str(rh0), literal);      
    make_and_input(num2str(rh1), literal);
end

%num2str(fread(fid, 1))
%num2str(fread(fid, 1))
%num2str(fread(fid, 1))


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
    if (instancemap.isKey(in_inst)), error(['Duplicate instance ' in_inst]); end
    instancemap(in_inst) = in_signal;
    end

    function push_edge(in_head, in_tail)
    edgesindex = edgesindex + 1;
    edges(:, edgesindex) = {in_head; in_tail};
    end

    function try_push_inverter(in_inst)
    val = str2double(in_inst);
    if (iseven(val) || instancemap.isKey(in_inst)), return; end
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

end

