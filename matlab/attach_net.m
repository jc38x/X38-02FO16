
function [out_delay, out_labels, out_range, out_equations] = attach_net(in_dd, in_ld, in_rd, in_ed, in_ds, in_ls, in_rs, in_es, in_join)
signal2uidd = containers.Map(in_ld, num2cell(in_rd.all));
signal2uids = containers.Map(in_ls, num2cell(in_rs.all));
offset = in_rd.sz;
replacemap = containers.Map();
edgesmap = containers.Map('KeyType', 'double', 'ValueType', 'any');
removemap = containers.Map('KeyType', 'double', 'ValueType', 'any');
index = 0;

for j = in_join
    pod = signal2uidd(j{1});
    pit = signal2uids(j{2});
    onode = find(in_ds(pit, :));
    if (isempty(onode)), continue; end
    if (is_pi(pod, in_rd)), inode = pod; else inode = find(in_dd(:, pod)); end    
    replacemap(j{2}) = in_ld{inode};
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
uidremap = containers.Map(num2cell([in_rd.pi, in_rs.pi + offset, in_rd.in, in_rs.in + offset, in_rd.po, in_rs.po + offset]), num2cell(uidall));

out_delay = sparse(cell2mat(uidremap.values(num2cell([id.', it.' + offset, edges(1, :)]))), cell2mat(uidremap.values(num2cell([jd.', jt.' + offset, replacelist]))), 1, sz, sz);

out_labels = cell(1, sz);
out_labels(cell2mat(uidremap.values(num2cell(uidall)))) = [in_ld, in_ls];

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
out_equations(cell2mat(uidremap.values(num2cell(uidall)))) = [in_ed, nes];

out_range = prepare_range(in_rd.szpi + in_rs.szpi, in_rd.szin + in_rs.szin, in_rd.szpo + in_rs.szpo);

remove = removemap.values();
remove = [remove{:}];
[out_delay, out_labels, out_range, out_equations] = remove_port(out_delay, out_labels, out_range, out_equations, cell2mat(uidremap.values(num2cell(remove))));
end