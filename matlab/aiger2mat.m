
function [out_delay, out_labels, out_range] = aiger2mat(in_filename)
fid = fopen(in_filename, 'rt');
if (fid == -1), error(['Failed to open file ' in_filename '.']); end

nline = fgetl(fid);
header = strsplitntrim(nline, ' ');
if (~strcmp(header{1}, 'aag')), error('File is not ASCII AIGER'); end

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



instancemap = containers.Map('KeyType', 'char', 'ValueType', 'char');
signal2uid = containers.Map();
uid = 0;

edges = [];

pilist = [];
polist = [];
inlist = [];


for k = 1:i
    nline = strtrim(fgetl(fid));
    
    literal = nline;
    signal = ['i_' num2str(k)];
    push_instance(literal, signal);
    push_signal(signal);
    
    pilist = [pilist, signal2uid(signal)];
end

for k = 1:l
    nline = strsplitntrim(fgetl(fid), ' ');
    
    literal = nline{1};
    signal = ['latch_i_' num2str(k)];
    push_instance(literal, signal);
    push_signal(signal);
    
    pilist = [pilist, signal2uid(signal)];

    literal = nline{2};
    signal = ['latch_o_' num2str(k)];
    push_signal(signal);
    try_push_inverter(literal);    
    push_edge(literal, signal);
    
    polist = [polist, signal2uid(signal)];
end

for k = 1:o
    nline = strtrim(fgetl(fid));
    
    literal = nline;
    signal = ['o_' num2str(k)];
    push_signal(signal);
    try_push_inverter(literal);    
    push_edge(literal, signal);
    
    polist = [polist, signal2uid(signal)];
end

for k = 1:a
    nline = strsplitntrim(fgetl(fid), ' ');
    
    literal = nline{1};
    signal = ['and_2_' num2str(k)];
    push_instance(literal, signal);
    push_signal(signal);
    
    inlist = [inlist, signal2uid(signal)];
    
    input1 = nline{2};
    try_push_inverter(input1);    
    push_edge(input1, literal);    

    input2 = nline{3};
    try_push_inverter(input2);    
    push_edge(input2, literal);
end


fclose(fid);


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



for i = 1:size(edges, 2)
    literal = edges{1, i};
    if (instancemap.isKey(literal)), edges{1, i} = instancemap(literal); end
    literal = edges{2, i};
    if (instancemap.isKey(literal)), edges{2, i} = instancemap(literal); end
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
        if (instancemap.isKey(in_inst)), error('DUP'); end
        instancemap(in_inst) = in_signal;
    end

    function try_push_inverter(in_inst)
        val = str2double(in_inst);
        if (iseven(val)), return; end
        
        if (instancemap.isKey(in_inst)), return; end
        ss = ['inv_1_' in_inst];
        push_instance(in_inst, ss);
        push_signal(ss);
        
        
        newval = val - 1;
        
        push_edge(num2str(newval), in_inst);
        inlist = [inlist, signal2uid(ss)];
    end

    function push_edge(in_head, in_tail)
        edges = [edges, {in_head; in_tail}];
    end

end
