
function [out_delay, out_labels, out_range, out_equations] = tt2mat(in_tthex)
rows = numel(in_tthex) * 4;
npi = log2(rows);
ttinputs = num2cell(repmat([1, 0], npi, 1), 2);
ttinputs = combvec(ttinputs{:});
states = zeros(1, rows);
row = 1;

if (any(strcmpi(in_tthex, {'FFFF', '0000'})))
    error('Constant LUTs are unsupported.');
end

for c = lower(in_tthex)
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
    states(row:(row + 3)) = keep;
    row = row + 4;
end

ttinputs = ttinputs(:, logical(states));
nt = size(ttinputs, 2);
node2uid = containers.Map();
uid = 0;
nodeequations = containers.Map();
nodeiedges = containers.Map();





%edges = zeros(2, 100);
%edgesindex = 0;

for n = 0:(npi - 1), push_node(['i' num2str(n)], '', []); end

miniterms = cell(1, nt);
for n = 1:nt
    input = ttinputs(:, n);
    nodename = push_and(operand(input(1), 'i0'), operand(input(2), 'i1'));
    for i = 3:numel(input), nodename = push_and(nodename, operand(input(i), ['i' num2str(i - 1)])); end
    miniterms{n} = nodename;
end

%nodename = push_not(push_and(push_not(miniterms{1}), push_not(miniterms{2})));
%for n = miniterms(3:end), nodename = push_not(push_and(push_not(nodename), push_not(n{1}))); end

if (numel(miniterms) < 2)
    nodename = miniterms{1};
else
    nodename = push_and(push_not(miniterms{1}), push_not(miniterms{2}));
    for n = miniterms(3:end), nodename = push_and(nodename, push_not(n{1})); end
    nodename = push_not(nodename);
end

push_node('o', '', node2uid(nodename));




out_range = prepare_range(npi, uid - npi - 1, 1);

out_labels = cell(1, out_range.sz);
keys = node2uid.keys();
out_labels(cell2mat(node2uid.values(keys))) = keys;


out_equations = cell(1, out_range.sz);
for k = out_range.all, out_equations{k} = nodeequations(out_labels{k}); end


edges = zeros(2, out_range.szin * 2 + 1);
edgesindex = 0;

for k = [out_range.in, out_range.po]
    for e = nodeiedges(out_labels{k})
        edgesindex = edgesindex + 1;
        edges(1, edgesindex) = e;
        edges(2, edgesindex) = k;
    end
end

edges = edges(:, 1:edgesindex);
out_delay = sparse(edges(1, :), edges(2, :), 1, out_range.sz, out_range.sz);


%out_equations = [];
%out_delay = [];


%expr = ['and(' operand(input(1), 'i0') ',' operand(input(2), 'i1') ')'];
    %for i = 3:numel(input), expr = strcat('and(', expr, ',', operand(input(i), ['i' num2str(i - 1)]), ')'); end
    %miniterms{n} = expr;
    
    %out_equations = 0;%miniterms;
    
    
    %out_delay = [];
    %out_labels = [];
    
    
    function [out_name] = push_and(in_a, in_b)
    nodeaid = node2uid(in_a);
    nodebid = node2uid(in_b);
    nodeid = sort([nodeaid, nodebid]);
    out_name = ['and_' num2str(nodeid(1)) '_' num2str(nodeid(2))];
    push_node(out_name, ['and([' in_a '],[' in_b '])'], nodeid);
    end

    function [out_name] = push_not(in_i)
    nodeid = node2uid(in_i);
    out_name = ['not_' num2str(nodeid)];
    push_node(out_name, ['not([' in_i '])'], nodeid);
    end

    function push_node(in_name, in_equation, in_iedges)
    if (node2uid.isKey(in_name)), return; end
    uid = uid + 1;
    node2uid(in_name) = uid;
    nodeequations(in_name) = in_equation;
    nodeiedges(in_name) = in_iedges;
    end

    function [out_name] = operand(in_input, in_i)
    if (in_input == 0), out_name = push_not(in_i); else out_name = in_i; end
    end




%out_name = ['not(' in_name ')'];
        %out_name = in_name;
%push_edge(node2uid(in_a), nin);
        %push_edge(node2uid(in_b), nin);
    %function push_edge(in_head, in_tail)
    %edgesindex = edgesindex + 1;
    %edges(1, edgesindex) = in_head;
    %edges(2, edgesindex) = in_tail;
    %end


    
    
    
end



