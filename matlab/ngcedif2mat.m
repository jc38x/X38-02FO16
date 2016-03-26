
function [out_delay, out_labels, out_range, out_equations] = ngcedif2mat(in_filename)

edifenvironment = edu.byu.ece.edif.util.parse.EdifParser.translate(in_filename);
nftopcell = edifenvironment.getTopCell();
topcell = edu.byu.ece.edif.tools.flatten.FlattenedEdifCell(nftopcell);
edifgraph = edu.byu.ece.edif.util.graph.EdifCellInstanceGraph(topcell);
edges = edifgraph.getEdges();


lut2uid = containers.Map();
uid2instance = containers.Map('KeyType', 'double', 'ValueType', 'any'); 
uid = 0;

    function push_lut(in_instance)
    instancename = char(in_instance.getName());        
    if (lut2uid.isKey(instancename)), return; end
    uid = uid + 1;
    lut2uid(instancename) = uid;
    uid2instance(uid) = in_instance;
    end

    function [out_uid] = test_lut(in_epr)
    out_uid = [];
    if (in_epr.isTopLevelPortRef()), return; end
    instance = in_epr.getCellInstance();
    if (~any(strcmpi(char(instance.getCellType().getName()), {'LUT2', 'LUT3', 'LUT4', 'LUT5', 'LUT6'}))), return; end
    
    disp(['Found: ' char(instance.getCellType().getName())]);
    
    push_lut(instance);
    out_uid = lut2uid(char(instance.getName()));
    end



edgesiterator = edges.iterator();
edges = zeros(2, 200);
edgesindex = 0;
edgesmap = containers.Map();


while (edgesiterator.hasNext())
    edge = edgesiterator.next();
    sourceepr = edge.getSourceEPR();
    sinkepr = edge.getSinkEPR();
    
    head = test_lut(sourceepr);
    tail = test_lut(sinkepr);
    
    if (isempty(head) || isempty(tail)), continue; end
    
    edgesindex = edgesindex + 1;
    edges(1, edgesindex) = head;
    edges(2, edgesindex) = tail;
    key = [num2str(head) '->' num2str(tail)];
    
    if (edgesmap.isKey(key))
        edgesmap(key) = [edgesmap(key), {sinkepr.getPort().getName()}];
    else
        edgesmap(key) = {sinkepr.getPort().getName()};
    end
end

edges = edges(:, 1:edgesindex);

out_delay = sparse(edges(1, :), edges(2, :), 1, uid, uid);

keys = lut2uid.keys();
values = cell2mat(lut2uid.values(keys));

out_labels = cell(1, uid);
out_labels(values) = keys;

out_equations = cell(1, uid);

for k = 1:uid
    inst = uid2instance(k);
    init = char(inst.getProperty('INIT').getValue().getStringValue());
    total = numel(init) * 4;
    ns = log2(total);
    inputs = num2cell(repmat([1, 0], ns, 1), 2);
    inputs = combvec(inputs{:});
    mint = zeros(1, total);
    minti = 1;
    
    for c = lower(init)
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
        mint(minti:(minti + 3)) = keep;
        minti = minti + 4;
    end
    
    inputs = inputs(:, logical(mint));
    ni = size(inputs, 2);
    mintcell = cell(1, ni);
    
    for n = 1:ni
        input = inputs(:, n);
        mini = ['and(' operand(input(1), 'I0') ',' operand(input(2), 'I1') ')'];
        for i = 3:numel(input)
            mini = strcat('and(', mini, ',', operand(input(i), ['I' num2str(i - 1)]), ')');
        end
        mintcell{n} = mini;
    end
   
    if (ni < 2)
        
    else
        
    end
    
    
    
    %16 -> 6
    %8 -> 5
    %4 -> 4
    %2 -> 3
    %1 -> 2
    
    
    
    
    out_equations{k} = mintcell;
end


    function [out_name] = operand(in_input, in_name)
        if (in_input == 0)
            out_name = ['not(' in_name ')'];
        else
            out_name = in_name;
        end
    end



out_range = [];





























%{
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
%}
    











%{

%}





%{

%}




%{
not(not(A OR B))
not(notA and notB)
not(and(notA, notB))
A
  OR
B
A INV
      AND INV
B INV
%}


%{






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



%out_instances = ;
%out_edges = edgesmap;





%}

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

