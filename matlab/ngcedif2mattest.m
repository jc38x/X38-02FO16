
t = tic();
[d, l, r, e, edif] = ngcedif2mat('C:/Users/jcds/Documents/GitHub/X38-02FO16/matlab/sample_ISE_mapped.edif');
toc(t)

bg = build_graph(d, l, r, e);
view(bg);




%merge_edges(get_graph_edges(out_delay), cell_collapse(mapproxy.values()), out_range.sz)
%{
newedges = zeros(2, edgecount);

for k = 1:edgecount, newedges(:, k) = [signal2index(lutedges{1, k}); signal2index(lutedges{2, k})]; end

out_delay = merge_edges(get_graph_edges(out_delay), newedges, out_range.sz);

for k = out_range.pi
    label = out_labels{k};
    if (~test_lut(label)), continue; end
    mapremove(k) = k;

    inode = find(out_delay(:, k));
    if (isempty(inode)), error(['Unconnected LUT input ' label '.']); end
    newlabel = out_labels{inode};

	onode = find(out_delay(k, :));
    if (isempty(onode)), continue; end
    for n = onode, out_equations{n} = strrep(out_equations{n}, label, newlabel); end
    mapproxy(k) = [repmat(inode, 1, numel(onode)); onode];
end

for k = out_range.po
    label = out_labels{k};
    if (~test_lut(label)), continue; end
    mapremove(k) = k;
    onode = find(out_delay(k, :));
    if (isempty(onode)), continue; end
    mapproxy(k) = [find(out_delay(:, k)); onode];
end

[out_delay, out_labels, out_range, out_equations] = remove_node(merge_edges(get_graph_edges(out_delay), cell_collapse(mapproxy.values()), out_range.sz), out_labels, out_range, out_equations, cell_collapse(mapremove.values()));
%}


%{
    function [out_index] = flatten_index(in_i, in_j)
    end

    function out_edges = get_graph_edges(in_graph)
    [di, dj] = find(in_graph);
    out_edges = [di.'; dj.'];
    end

    function [out_graph] = merge_edges(in_oldedges, in_newedges, in_sz)
    out_graph = sparse([in_oldedges(1, :), in_newedges(1, :)], [in_oldedges(2, :), in_newedges(2, :)], 1, in_sz, in_sz);
    end
%}
%[di, dj] = find(out_delay);
%[di, dj] = find(out_delay);
%out_delay = sparse([di.', newedges(1, :)], [dj.', newedges(2, :)], 1, out_range.sz, out_range.sz);





%[di, dj] = find(out_delay);
%proxyedges = cell_collapse(mapproxy.values());
%out_delay = sparse([dk.', proxyedges(1, :)], [dj.', proxyedges(2, :)], 1, out_range.sz, out_range.sz);
%{
piremove = false(1, out_range.szpi);
    piremove(k) = 1;
%}

%{
    function [out_portindex] = connect_lut_port(in_fullportname, in_source, in_node)
    pd = sparse([], [], [], 1, 1, 1);
    pl = {in_fullportname};
    pe = {''};
    
    if (in_source)
        [out_delay, out_labels, out_range, out_equations] = join_net(pd, pl, prepare_range(1, 0, 0), pe, out_delay, out_labels, out_range, out_equations, {in_fullportname; in_node});
    else
        [out_delay, out_labels, out_range, out_equations] = join_net(out_delay, out_labels, out_range, out_equations, pd, pl, prepare_range(0, 0, 1), pe, {in_node; in_fullportname});
    end
    
    out_portindex = find(strcmpi(in_fullportname, out_labels));
    end
%}

%labels = mapl.values();
%labels = [labels{:}];
%{
    sourceindex = find(strcmpi(sourcefullportname, out_labels));
    if (isempty(sourceindex))
    end
    sinkindex = find(strcmpi(sinkfullportname, out_labels));
    if (isempty(sinkindex))
    end
    %}
    
    
    
    %{
    connect = false;
    sourceindex = find(strcmpi(sourcefullportname, out_labels));
    if (isempty(sourceindex)), sourceindex = connect_lut_port(sourcefullportname, true, sinkfullportname); connect = true; end    
    sinkindex = find(strcmpi(sinkfullportname, out_labels));
    if (isempty(sinkindex)), sinkindex = connect_lut_port(sinkfullportname, false, sourcefullportname); connect = true; end
    
    %
    if (~connect)
    out_delay(sourceindex, sinkindex) = 1;
    end
    %}
%{
    uid = uid + 1;
    uid2d(uid) = d;
    uid2l(uid) = l;
    uid2r(uid) = r;
    uid2e(uid) = e;
    %}

%uid2d = containers.Map('KeyType', 'double', 'ValueType', 'any');
%uid2l = containers.Map('KeyType', 'double', 'ValueType', 'any');
%uid2r = containers.Map('KeyType', 'double', 'ValueType', 'any');
%uid2e = containers.Map('KeyType', 'double', 'ValueType', 'any');

%out_delay = [];
%out_labels = [];
%out_range = [];
%out_equations = [];
%{
    if (uid == 1)
        out_delay = d;
        out_labels = l;
        out_range = r;
        out_equations = e;
    else
        [out_delay, out_labels, out_range, out_equations] = join_net(out_delay, out_labels, out_range, out_equations, d, l, r, e, []);
    end
    %}

%jl = [in_ll{:}];
%je = [in_el{:}];
%jr = [in_rl{:}];
%{
offset = in_rd.sz;
jl = [in_ld, in_ls];



[id, jd] = find(in_dd);
[is, js] = find(in_ds);



sz = in_rd.sz + in_rs.sz;
uidall = 1:sz;
uidremap = C_remap([in_rd.pi, in_rs.pi + offset, in_rd.in, in_rs.in + offset, in_rd.po, in_rs.po + offset], uidall);
allremap = uidremap.remap(uidall);

%out_delay = sparse(uidremap.remap([id.', is.' + offset, edgesi]), uidremap.remap([jd.', js.' + offset, edgesj]), 1, sz, sz);
out_delay = sparse(uidremap.remap([id.', is.' + offset]), uidremap.remap([jd.', js.' + offset]), 1, sz, sz);

out_labels = cell(1, sz);
out_labels(allremap) = jl;

out_equations = cell(1, sz);
out_equations(allremap) = [in_ed, in_es];

out_range = prepare_range(in_rd.szpi + in_rs.szpi, in_rd.szin + in_rs.szin, in_rd.szpo + in_rs.szpo);
%}

%signal2uid = containers.Map(jl, num2cell([in_rd.all, in_rs.all]));
%nj = size(in_join, 2);
%edges = zeros(2, nj);

%for edgesindex = 1:nj, edges(:, edgesindex) = [signal2uid(in_join{1, edgesindex}), signal2uid(in_join{2, edgesindex})]; end
%if (isempty(edges))
%    edgesi = [];
%    edgesj = [];
%else
%    edgesi = edges(1, :);
%    edgesj = edges(2, :);
%end


%alllist = topcell.getPortList();
%pilist = topcell.getInputPorts();
%polist = topcell.getOutputPorts();
%uid2lut = containers.Map();
%lut2net = containers.Map();
%piindex = 0;
%poindex = 0;
%edges = edgesmap.values();
%edges = [edges{:}];
%replacelist = [];
%replacelist = edges(2, :);
%{
nes = in_es;
if (~isempty(replacelist))
for k = unique(replacelist - offset)
    equation = nes{k};
    signals = regexprep(unique(regexp(equation, '\[\w*,?\w+\]', 'match')), '[\[\]]', '');
    for j = 1:numel(signals)
        signal = signals{j};
        if (replacemap.isKey(signal)), equation = regexprep(equation, signal, replacemap(signal)); end
    end
    nes{k} = equation;
end
end
%}





%remove = removemap.values();
%remove = [remove{:}];
%[out_delay, out_labels, out_range, out_equations] = remove_node(out_delay, out_labels, out_range, out_equations, uidremap.remap(remove));
%edgesindex = 0;

%edgesmap = containers.Map('KeyType', 'double', 'ValueType', 'any');



    %edgesindex = edgesindex + 1;


%signal2uidd = containers.Map(in_ld, num2cell(in_rd.all));
%signal2uids = containers.Map(in_ls, num2cell(in_rs.all));

%replacemap = containers.Map();
%removemap = containers.Map('KeyType', 'double', 'ValueType', 'any');
%sink = j{2};
    
    %pit = signal2uids(sink);
    
    
    %onode = pit;
    
    
    %pod = signal2uidd(j{1});
    %inode = pod;
    
    %if (isempty(onode)), continue; end
    %find(in_ds(pit, :));
    %sink
    %if (~is_pi(pit, in_rs)), error('Sink node must be PI.'); end
    %if (is_pi(pod, in_rd)), inode = pod; elseif (is_po(pod, in_rd)), inode = pod; else error('Source node must be PI or PO.'); end
        %find(in_dd(:, pod)); 
    
    %replacemap(sink) = in_ld{inode};
    
    %removemap(index) = pit + offset;
    %assert(numel(sinkindex) == 1);
    
    %assert(numel(sourceindex) == 1);

    %{
        d = sparse([],[],[],1,1,1);
        l = {sourcefullportname};
        r = prepare_range(1,0,0);
        e = {''};
        
        [out_delay, out_labels, out_range, out_equations] = join_net(d, l, r, e, out_delay, out_labels, out_range, out_equations, {sourcefullportname; sinkfullportname});
        %}
        %{
        d = sparse([],[],[],1,1,1);
        l = {sinkfullportname};
        r = prepare_range(0, 0, 1);
        e = {''};
        
        [out_delay, out_labels, out_range, out_equations] = join_net(out_delay, out_labels, out_range, out_equations, d, l, r, e, {sourcefullportname; sinkfullportname});
        %}
    %{
    if (issourcelut && ~issinklut)
        sourceindex = find(strcmpi(sourcefullportname, out_labels));
        assert(numel(sourceindex) == 1);
        sinkindex = find(strcmpi(sinkfullportname, out_labels));
        if (numel(sinkindex) == 1)
            out_delay(sourceindex, sinkindex) = 1;
        elseif (numel(sinkindex) == 0)
            d = sparse([],[],[],1,1,1);
            l = {sinkfullportname};
            r = prepare_range(0, 0, 1);
            e = {''};
            
            [out_delay, ...
                out_labels, ...
                out_range, ...
                out_equations] = join_net(out_delay, out_labels, out_range, out_equations, d, l, r, e, {sourcefullportname; sinkfullportname});
        else
            error('???');
        end
    elseif (~issourcelut && issinklut)
        sinkindex = find(strcmpi(sinkfullportname, out_labels));
        assert(numel(sinkindex) == 1);
        sourceindex = find(strcmpi(sourcefullportname, out_labels));
        if (numel(sourceindex) == 1)
            out_delay(sourceindex, sinkindex) = 1;
        elseif (numel(sourceindex) == 0)
            d = sparse([],[],[],1,1,1);
            l = {sourcefullportname};
            r = prepare_range(1,0,0);
            e = {''};
            
            %sinkfullportname
            %out_labels
            [out_delay, ...
                out_labels, ...
                out_range, ...
                out_equations] = join_net(d, l, r, e, out_delay, out_labels, out_range, out_equations, {sourcefullportname; sinkfullportname});
        else
            error('???');
        end
    elseif (issourcelut && issinklut)
        sinkindex = find(strcmpi(sinkfullportname, out_labels));
        assert(numel(sinkindex) == 1);
        sourceindex = find(strcmpi(sourcefullportname, out_labels));
        assert(numel(sourceindex) == 1);
        
        out_delay(sourceindex, sinkindex) = 1;
    else
    end
    %}



  
    
    %{
    pivot = find(sourcefullportname == ',');
    issourcelut = ~isempty(pivot) && lut2uid.isKey(sourcefullportname(1:(pivot - 1)));
    pivot = find(sinkfullportname == ',');
    issinklut = ~isempty(pivot) && lut2uid.isKey(sinkfullportname(1:pivot - 1));
    %}
    
    
    
    %{
    if (sourceepr.isTopLevelPortRef())
        sourcelut = false;
    else
        sourceinstance = sourceepr.getCellInstance();
        sourceinstancename = char(sourceinstance.getName());
        sourcelut = lut2uid.isKey(sourceinstancename);
    end
    
    if (sinkepr.isTopLevelPortRef())
        sinklut = false;
    else
        sinkinstance = sinkepr.getCellInstance();
        sinkinstancename = char(sinkinstance.getName());
        sinklut = lut2uid.isKey(sinkinstancename);
    end
    %}
    %uid2lut(uid) = in_instance;
    
    
    
    
    
    
    
    %sourceportname = [sourceinstance.getName() ',' char(sourceepr.getPort().getName())];
    
    
    
    
%push_lut(instance);
    %assert(~lut2uid.isKey(instancename));
    %function push_lut(in_instance)
    
    %end


%{
for instance = uid2lut.values()
    lut = instance{:};
    lutname = char(lut.getName());
    
    
    ieprlist = lut.getInputEPRs();
    iepriterator = ieprlist.iterator();
    tail = lut2uid(lutname);
    
    while (iepriterator.hasNext())
        epr = iepriterator.next();
        ii = epr.getCellInstance();
        
        
        
    end
    
    
    
    oepr = lut.getOutputEPRs();
    
    
    
    
end
%}







    

%instancename = char(instance.getName());
%init = char(instance.getProperty('INIT').getValue().getStringValue());
    
    
    
    %
    %make_instance(instancename, labels, range, equations);


%{
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
    %}
%topcell = edu.byu.ece.edif.tools.flatten.FlattenedEdifCell(nftopcell);

%{
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






%}






















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
%{
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
%}