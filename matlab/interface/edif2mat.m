%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_delay, out_labels, out_range, out_edges] = edif2mat(in_filename, in_flatten)
edifenv = edu.byu.ece.edif.util.parse.EdifParser.translate(in_filename);
topcell = edifenv.getTopCell();
if (in_flatten), topcell = edu.byu.ece.edif.tools.flatten.FlattenedEdifCell(topcell); end
topname = ['top(' strremovespaces(char(topcell.toString())) ')'];
edifgraph = edu.byu.ece.edif.util.graph.EdifCellInstanceGraph(topcell);
edges = edifgraph.getEdges();
edgesiter = edges.iterator();

signal2uid = containers.Map();
uid = 0;
pimap = containers.Map();
pomap = containers.Map();
instancemap = containers.Map();
edgemap = containers.Map();
edgescell = cell(3, 2 * edges.size());
edgesindex = 0;
preprocess = cell(8, edges.size());
ppindex = 0;

while (edgesiter.hasNext())
    edge = char(edgesiter.next().toString());
    signals = strsplitntrim(edge, '->');

    [hinst, hio, histop] = translate_port(signals{1});
    [tinst, tio, tistop] = translate_port(signals{2});

    head = make_signal(hinst, hio);
    try_push_signal(head);
    headuid = signal2uid(head);
    if (histop)
        if (~pimap.isKey(head)), pimap(head) = headuid; end
    elseif (~instancemap.isKey(hinst))
        instancemap(hinst) = headuid;
    elseif (~any(headuid == instancemap(hinst)))
        instancemap(hinst) = [instancemap(hinst), headuid];
    end

    if (tistop)
        tail = make_signal(tinst, tio);
        try_push_signal(tail);
        if (~pimap.isKey(tail)), pomap(tail) = signal2uid(tail); end
    else
        tail = tinst;
    end

    ppindex = ppindex + 1;
    preprocess(:, ppindex) = {hinst; hio; histop; head; tinst; tio; tistop; tail};
end

for c = preprocess
    head = c{4};
    headuid = signal2uid(head);
    tail = c{8};
    
    if (c{7})
        tailuids = signal2uid(tail);
    else
        tailuids = instancemap(tail);
        tail = make_signal(c{5}, c{6});
    end
    
    edge = [head '->' tail];
    if (edgemap.isKey(edge))
        warning(['Ignoring duplicate edge ' edge '.']);
        continue;
    end
    
    newedges = [repmat(headuid, 1, size(tailuids, 2)); tailuids];
    edgemap(edge) = newedges;
    for e = newedges
        edgesindex = edgesindex + 1;
        edgescell(:, edgesindex) = {headuid; e(2); tail};
    end
end

pilist = pimap.values();
polist = pomap.values();
inlist = setdiff(1:uid, [[pilist{:}], [polist{:}]]);

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

edgelist = edgemap.values();
edgelist = [edgelist{:}];
n = max(edgelist(:));
edgelist = remap.values(num2cell(edgelist));

out_delay = sparse([edgelist{1, :}], [edgelist{2, :}], 1, n, n);

s2uk = signal2uid.keys();
out_labels(cell2mat(remap.values(signal2uid.values(s2uk)))) = s2uk;

edgescell = edgescell(:, 1:edgesindex);
edgescell = [remap.values(edgescell(1:2, :)); edgescell(3, :)];
out_edges = edgescell;

    function [out_instance, out_io, out_istop] = translate_port(in_port)
    port = strsplitntrim(in_port(2:end-1), ',');
    out_instance = strremovespaces(port{1});
    out_io = strremovespaces(port{2});
    out_istop = strcmp(out_instance, topname);
    end

    function try_push_signal(in_signal)
    if (signal2uid.isKey(in_signal)), return; end
    uid = uid + 1;
    signal2uid(in_signal) = uid;
    end

    function [out_signal] = make_signal(in_inst, in_io)
    out_signal = ['[' in_inst ', ' in_io ']'];
    end
end
