
function [out_delay, out_labels, out_range, out_equations] = merge_net(in_delayd, in_labelsd, in_ranged, in_equationsd, in_delayt, in_labelst, in_ranget, in_equationst, in_join)

signal2uidd = containers.Map(in_labelsd, num2cell(in_ranged.all));
signal2uidt = containers.Map(in_labelst, num2cell(in_ranget.all));
offset = in_ranged.sz;
edges = [];
rem = [];
replacemap = containers.Map();


for j = in_join
    pod = signal2uidd(j{1});
    pit = signal2uidt(j{2});
    
    onode = find(in_delayt(pit, :));
    if (isempty(onode)), continue; end
    inode = find(in_delayd(:, pod));
    if (isempty(inode)), inode = pod; end
    
    replacemap(j{2}) = in_labelsd{inode};
    
    
    edges = [edges, [repmat(inode, 1, numel(onode)); onode + offset]];
    rem = [rem, [pit + offset]];
    if (is_po(pod, in_ranged)), rem = [rem, pod]; end
end

[id, jd, sd] = find(in_delayd);
[it, jt, st] = find(in_delayt);

ii = [id.', it.' + offset, edges(1, :)];
jj = [jd.', jt.' + offset, edges(2, :)];

sz = in_ranged.sz + in_ranget.sz;

remap = containers.Map( ...
    num2cell([in_ranged.pi, in_ranget.pi + offset, in_ranged.in, in_ranget.in + offset, in_ranged.po, in_ranget.po + offset]), ...
    num2cell(1:sz) ...
);

ii = cell2mat(remap.values(num2cell(ii)));
jj = cell2mat(remap.values(num2cell(jj)));

out_delay = sparse(ii, jj, 1, sz, sz);

out_labels = cell(1, sz);
out_labels(cell2mat(remap.values(num2cell(1:sz)))) = [in_labelsd, in_labelst];

reqt = in_equationst;
replacemap.values()
replacemap.keys()

for k = in_ranget.in
    equation = reqt{k};
    signals = unique(regexp(equation, '\[\w+\]', 'match'));
    signals = regexprep(signals, '[\[\]]', '');

    for j = numel(signals)
        if (replacemap.isKey(signals{j}))
            equation = regexprep(equation, signals{j}, replacemap(signals{j}));
        end
    end
    reqt{k} = equation;
end


out_equations = cell(1, sz);
out_equations(cell2mat(remap.values(num2cell(1:sz)))) = [in_equationsd, reqt];

out_range = prepare_range(in_ranged.szpi + in_ranget.szpi, in_ranged.szin + in_ranget.szin, in_ranged.szpo + in_ranget.szpo);

rem = cell2mat(remap.values(num2cell(rem)));


out_delay(rem, :) = [];
out_delay(:, rem) = [];
out_labels(rem) = [];
out_equations(rem) = [];
npi = out_range.szpi - sum(is_pi(rem, out_range));
npo = out_range.szpo - sum(is_po(rem, out_range));


out_range = prepare_range(npi, out_range.szin, npo);
%}



end
