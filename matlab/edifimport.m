
function [out_delay, out_labels, out_range] = edifimport(in_filename, in_flatten)
edifenv = edu.byu.ece.edif.util.parse.EdifParser.translate(in_filename);
topcell = edifenv.getTopCell();
if (in_flatten), topcell = edu.byu.ece.edif.tools.flatten.FlattenedEdifCell(topcell); end
edifgraph = edu.byu.ece.edif.util.graph.EdifCellInstanceGraph(topcell);








edges = edifgraph.getEdges();
signal2uid = containers.Map();
instancecopy = containers.Map();
instancecell = containers.Map();
instancetype = containers.Map();
uid = 0;

topname =  char(topcell.getName());

alllist = topcell.getPortList();
pilist = topcell.getInputPorts();
inlist = topcell.getCellInstanceList();
polist = topcell.getOutputPorts();




estimatededges = pilist.size() + 2 * polist.size() - alllist.size();




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
    beginuid = uid;
    prefix = [instancename ','];
    celloutiterator = celltype.getOutputPorts().iterator();
    while (celloutiterator.hasNext()), push_port(prefix, celloutiterator.next(), ''); end
    instancecopy(instancename) = (beginuid + 1):uid;
    celliniterator = celltype.getInputPorts().iterator();
    inputedges = 0;
    while (celliniterator.hasNext()), inputedges = inputedges + celliniterator.next().getWidth(); end
    estimatededges = estimatededges + ((uid - beginuid) * inputedges);
    
    
    
    
    instancecell(instancename) = instance;
    instancetype(instancename) = char(celltype.getName());
end
szin = uid - szpi;

poiterator = polist.iterator();
while (poiterator.hasNext())
    port = poiterator.next();
    if (~port.isOutputOnly()), suffix = '@I'; else suffix = ''; end
    push_port('', port, suffix);
end
szpo = uid - szin - szpi;

out_labels = cell(1, uid);
keys = signal2uid.keys();
out_labels(cell2mat(signal2uid.values(keys))) = keys;
out_range = prepare_range(szpi, szin, szpo);

graphedges = cell(3, estimatededges);
edgesindex = 0;
edgesiterator = edges.iterator();
edgesmap = containers.Map();

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
    
    
    
    
    
%estimatededges




    
    
    
    
        
        
        
    
        
        

    
    
    
    
    for tailuid = tailuids
        if (tailuid == headuid), disp('!!!'); end
        edgesindex = edgesindex + 1;
        key = [num2str(headuid) '->' num2str(tailuid)];
        if (edgesmap.isKey(key)), disp(['Duplicate edge ' out_labels{headuid} '->' out_labels{tailuid} ' | ' edgesmap(key) ' ^ ' sinkportfullname]); end
        edgesmap(key) = sinkportfullname;
        
        graphedges(:, edgesindex) = [{headuid}; {tailuid}; {sinkportfullname}];
    end
end



out_delay = sparse(cell2mat(graphedges(1, :)), cell2mat(graphedges(2, :)), 1, uid, uid);

out_edges = graphedges(:, 1:edgesindex);

%edgesindex
%estimatededges
%out_nets = cell(1, uid);%
%out_equations = cell(1, pilist.size() + inlist.size() + polist.size());
%out_equations{uid} = '';
%out_nets = [];
%{
pilo = 1;
pihi = pilist.size();
inlo = pihi + 1;
inhi = pihi + uid - (pilist.size() + polist.size());
polo = inhi + 1;
pohi = inhi + polist.size();
%}
%ids = zeros(1, cellout.size());
    %idindex = 0;
    %celltype = ;    
out_types = instancetype;
out_test = signal2uid;
%if (~port.isOutputOnly()), suffix = '@O'; else suffix = ''; end 

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
%{
%}
    %portname = char(port.getName());
       %push_signal(signalname);
%disp(bitport.getPortName());
        %disp(bitport)
    %disp(port)
    %portname = char(port.getName());
        %push_signal(signalname);
        %disp(bitport.getPortName());
            %disp(bitport)
            %portname = char(port.getName());
        %drivername = [instancename ',' portname];
        %
        %push_signal(signalname);
%disp(poiterator.next().getName());
%push_signal(char(instance.getName()));
        %disp();
%{    %}
%edifgraph = edu.byu.ece.edif.util.graph.EdifCellInstanceGraph(topcell);
%{
topname = ['top(' strremovespaces(char(topcell.toString())) ')'];
edges = edifgraph.getEdges();
edgesiter = edges.iterator();
topcellinstance = edifenv.getTopCellInstance();
primitivelist = topcellinstance.getHierarchicalPrimitiveList();
primitiveiter = primitivelist.iterator();
%epw = edu.byu.ece.edif.core.EdifPrintWriter('C:/Users/jcds/Documents/GitHub/X38-02FO16/primitive.edif');
%epw.printQuote('a');

while (primitiveiter.hasNext())
    list = primitiveiter.next();
    listiter = list.iterator();
    while (listiter.hasNext())
        obj = listiter.next();
        ec = char(obj.getType());
        if (strcmp(ec(1:3), 'LUT'))
            prop = obj.getProperty('INIT');
            disp(prop);
        end

        
        %obj.toEdif(epw);
        %disp(obj);
    end
end







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
    edgeobj = edgesiter.next();
    edge = char(edgeobj.toString());
    signals = strsplitntrim(edge, '->');
    
    %sourceepr = edgeobj.getSourceEPR();
    %sinkepr = edgeobj.getSinkEPR();
    %sourceepr = sourceepr.getCellInstance();
    %sinkepr = sinkepr.getCellInstance();
    %disp(sourceepr);
    %disp(sinkepr);

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



%for k = in_range.pi
%end







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
%}
end

