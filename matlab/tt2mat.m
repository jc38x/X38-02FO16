%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_delay, out_labels, out_range, out_equations] = tt2mat(in_tthex)
rows = numel(in_tthex) * 4;
npi = log2(rows);
%ttinputs = num2cell(repmat([1, 0], npi, 1), 2);
%ttinputs = combvec(ttinputs{:});
ttinputs = tt_inputs(npi);
ttinputs = ttinputs(:, logical(hexToBinaryVector(in_tthex, rows)));
nt = size(ttinputs, 2);
pi = cell(1, npi);
node2uid = containers.Map();
uid = 0;
nodeequations = containers.Map();
nodeiedges = containers.Map();

for k = 1:npi
    pi{k} = ['i' num2str(k - 1)];
    push_node(pi{k}, '', []);
end

if (nt == 0)
    nodename = 'gnd';
    push_node(nodename, '0', []);
elseif (nt == rows)
    nodename = 'vcc';
    push_node(nodename, '1', []);
else
    miniterms = cell(1, nt);
    for k = 1:nt
        input = ttinputs(:, k);
        nodename = push_and(operand(input(1), 'i0'), operand(input(2), 'i1'));
        for i = 3:numel(input), nodename = push_and(nodename, operand(input(i), pi{i})); end
        miniterms{k} = nodename;
    end
    
    if (nt > 1)
    %if (nt == 1)
    %    nodename = miniterms{1};
    %else
        nodename = push_and(push_not(miniterms{1}), push_not(miniterms{2}));
        for k = miniterms(3:end), nodename = push_and(nodename, push_not(k{1})); end
        nodename = push_not(nodename);
    end
end

push_node('o', '', node2uid(nodename));

out_range = prepare_range(npi, uid - npi - 1, 1);

out_labels = cell(1, out_range.sz);
keys = node2uid.keys();
out_labels(cell2mat(node2uid.values(keys))) = keys;

out_equations = nodeequations.values(out_labels);

edges = zeros(2, out_range.szin * 2 + 1);
edgesindex = 0;

for k = out_range.notpi
    for e = nodeiedges(out_labels{k})
        edgesindex = edgesindex + 1;
        edges(1, edgesindex) = e;
        edges(2, edgesindex) = k;
    end
end

edges = edges(:, 1:edgesindex);
out_delay = sparse(edges(1, :), edges(2, :), 1, out_range.sz, out_range.sz);

    function [out_name] = push_and(in_a, in_b)
    nodeid = sort([node2uid(in_a), node2uid(in_b)]);
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
end
