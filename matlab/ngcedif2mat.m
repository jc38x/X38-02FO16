
function [out_delay, out_labels, out_range, out_descriptor] = ngcedif2mat(in_filename)

edifenvironment = edu.byu.ece.edif.util.parse.EdifParser.translate(in_filename);
nftopcell = edifenvironment.getTopCell();
topcell = edu.byu.ece.edif.tools.flatten.FlattenedEdifCell(nftopcell);
edifgraph = edu.byu.ece.edif.util.graph.EdifCellInstanceGraph(topcell);
edges = edifgraph.getEdges();

alllist = topcell.getPortList();
pilist = topcell.getInputPorts();
inlist = topcell.getCellInstanceList();
polist = topcell.getOutputPorts();




estimatededges = pilist.size() + (2 * polist.size()) - alllist.size();
signal2uid = containers.Map();
uid = 0;
instancecopy = containers.Map();
instancecell = containers.Map();
edgesmap = containers.Map();



piiterator = pilist.iterator();
while (piiterator.hasNext())
    port = piiterator.next();
    if (~port.isInputOnly()), suffix = '@O'; else suffix = ''; end
    push_port('', port, suffix);
end
szpi = uid;

initerator = inlist.iterator();
while (initerator.hasNext())
    instance = initerator.next();
    instancename = char(instance.getName());
    celltype = instance.getCellType();
    prefix = [instancename ','];
    beginuid = uid;
    instancecell(instancename) = instance;
    
    celloutiterator = celltype.getOutputPorts().iterator();
    while (celloutiterator.hasNext()), push_port(prefix, celloutiterator.next(), ''); end
    instancecopy(instancename) = (beginuid + 1):uid;
    
    celliniterator = celltype.getInputPorts().iterator();
    inputedges = 0;
    while (celliniterator.hasNext()), inputedges = inputedges + celliniterator.next().getWidth(); end
    estimatededges = estimatededges + ((uid - beginuid) * inputedges);
end
szin = uid - szpi;

poiterator = polist.iterator();
while (poiterator.hasNext())
    port = poiterator.next();
    if (~port.isOutputOnly()), suffix = '@I'; else suffix = ''; end
    push_port('', port, suffix);
end
szpo = uid - szin - szpi;   

out_range = prepare_range(szpi, szin, szpo);

out_labels = cell(1, out_range.sz);
keys = signal2uid.keys();
out_labels(cell2mat(signal2uid.values(keys))) = keys;

instancelist = cell(1, out_range.sz);
for k = out_range.in
    label = out_labels{k};
    instancelist{k} = instancecell(label(1:(find(label == ',') - 1)));
end













graphedges = zeros(2, estimatededges);
edgesindex = 0;

edgesiterator = edges.iterator();
while (edgesiterator.hasNext())
    edge = edgesiterator.next();
    sourceepr = edge.getSourceEPR();
    sinkepr = edge.getSinkEPR();
    sourceport = sourceepr.getPort();
    sinkport = sinkepr.getPort();

    sourcename = char(sourceport.getName());
    if (sourceport.isBus()), sourceindex = ['(' num2str(sourceepr.getSingleBitPort().bitPosition()) ')']; else sourceindex = ''; end
    if (~sourceepr.isTopLevelPortRef())
        sourceprefix = [char(sourceepr.getCellInstance().getName()) ','];
        sourcesuffix = '';
    else
        sourceprefix = '';
        if (~sourceport.isInputOnly()), sourcesuffix = '@O'; else sourcesuffix = ''; end
    end
    headuid = signal2uid([sourceprefix sourcename sourceindex sourcesuffix]);

    if (sinkport.isBus()), sinkindex = ['(' num2str(sinkepr.getSingleBitPort().bitPosition()) ')']; else sinkindex = ''; end
    sinkportid = [char(sinkport.getName()) sinkindex];
    if (~sinkepr.isTopLevelPortRef())
        instancename = char(sinkepr.getCellInstance().getName());
        tailuids = instancecopy(instancename);
        sinkportfullname = [instancename ',' sinkportid];
    else
        if (~sinkport.isOutputOnly()), sinksuffix = '@I'; else sinksuffix = ''; end
        sinkportfullname = [sinkportid sinksuffix];
        tailuids = signal2uid(sinkportfullname);
    end

    for tailuid = tailuids
        key = [num2str(headuid) '->' num2str(tailuid)];
        edgesindex = edgesindex + 1;
        if (edgesmap.isKey(key)), app = edgesmap(key); else app = []; end
        edgesmap(key) = [app {sinkportfullname}];
        graphedges(:, edgesindex) = [headuid; tailuid];
    end
end

out_delay = sparse(graphedges(1, :), graphedges(2, :), 1, uid, uid);




order = graphtopoorder(out_delay);









out_descriptor.environment = edifenvironment;
out_descriptor.instances = instancecell;
out_descriptor.edges = edgesmap;

%out_instances = ;
%out_edges = edgesmap;







%instancetype = containers.Map();
%topname =  char(topcell.getName());
%instancetype(instancename) = char(celltype.getName());
%{
out_equations = cell(1, out_range.sz);
out_equations([out_range.pi, out_range.po]) = {''};

for k = out_range.in
    label = out_labels{k};
    top = find(label == ',');
    instance = label(1:(top - 1));
    
    
    switch (lower(instancetype(instance)))
        case 'and2'
            out_equations{k} = instancetype(instance);
        case 'lut4'
        case 'lut3'
        case 'lut2'
        otherwise
            out_equations{k} = ['#' instancetype(instance)];
    end
end
%}







    function push_port(in_prefix, in_port, in_suffix)
    name = char(in_port.getName());
    if (in_port.isBus())
        bpli = in_port.getSingleBitPortList().iterator();
        while (bpli.hasNext()), push_signal([in_prefix name '(' num2str(bpli.next().bitPosition()) ')' in_suffix]); end
    else
        push_signal([in_prefix name in_suffix]);
    end
    end

    function push_signal(in_signal)
    assert(~signal2uid.isKey(in_signal));
    uid = uid + 1;
    signal2uid(in_signal) = uid;
    end


end

