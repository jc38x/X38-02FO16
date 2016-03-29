%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_delay, out_labels, out_range, out_equations] = attach_net(in_dd, in_ld, in_rd, in_ed, in_ds, in_ls, in_rs, in_es, in_join)
signal2uidd = containers.Map(in_ld, num2cell(in_rd.all));
signal2uids = containers.Map(in_ls, num2cell(in_rs.all));
offset = in_rd.sz;
replacemap = containers.Map();
edgesmap = containers.Map('KeyType', 'double', 'ValueType', 'any');
removemap = containers.Map('KeyType', 'double', 'ValueType', 'any');
index = 0;

for j = in_join
    sink = j{2};
    pit = signal2uids(sink);
    if (~is_pi(pit, in_rs)), error('Sink node must be PI.'); end
    onode = find(in_ds(pit, :));
    if (isempty(onode)), continue; end
    
    pod = signal2uidd(j{1});
    if (is_pi(pod, in_rd)), inode = pod; elseif (is_po(pod, in_rd)), inode = find(in_dd(:, pod)); else error('Source node must be PI or PO.'); end
    
    replacemap(sink) = in_ld{inode};
    index = index + 1;
    edgesmap(index) = [repmat(inode, 1, numel(onode)); onode + offset];
    removemap(index) = pit + offset;
end

[id, jd] = find(in_dd);
[it, jt] = find(in_ds);    
edges = edgesmap.values();
edges = [edges{:}];
replacelist = edges(2, :);
sz = in_rd.sz + in_rs.sz;
uidall = 1:sz;
uidremap = C_remap([in_rd.pi, in_rs.pi + offset, in_rd.in, in_rs.in + offset, in_rd.po, in_rs.po + offset], uidall);
allremap = uidremap.remap(uidall);

out_delay = sparse(uidremap.remap([id.', it.' + offset, edges(1, :)]), uidremap.remap([jd.', jt.' + offset, replacelist]), 1, sz, sz);

out_labels = cell(1, sz);
out_labels(allremap) = [in_ld, in_ls];

nes = in_es;
for k = unique(replacelist - offset)
    equation = nes{k};
    signals = regexprep(unique(regexp(equation, '\[\w*,?\w+\]', 'match')), '[\[\]]', '');
    for j = numel(signals)
        signal = signals{j};
        if (replacemap.isKey(signal)), equation = regexprep(equation, signal, replacemap(signal)); end
    end
    nes{k} = equation;
end

out_equations = cell(1, sz);
out_equations(allremap) = [in_ed, nes];

out_range = prepare_range(in_rd.szpi + in_rs.szpi, in_rd.szin + in_rs.szin, in_rd.szpo + in_rs.szpo);

remove = removemap.values();
remove = [remove{:}];
[out_delay, out_labels, out_range, out_equations] = remove_node(out_delay, out_labels, out_range, out_equations, uidremap.remap(remove));
end
