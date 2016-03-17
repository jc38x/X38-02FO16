
function [out_test, out_labels] = edifimport(in_filename, in_flatten)
edifenv = edu.byu.ece.edif.util.parse.EdifParser.translate(in_filename);
topcell = edifenv.getTopCell();
if (in_flatten), topcell = edu.byu.ece.edif.tools.flatten.FlattenedEdifCell(topcell); end







edifgraph = edu.byu.ece.edif.util.graph.EdifCellInstanceGraph(topcell);

edges = edifgraph.getEdges();
signal2uid = containers.Map();
instancemap = containers.Map();
instancetype = containers.Map();
uid = 0;

pilist = topcell.getInputPorts();
inlist = topcell.getCellInstanceList();
polist = topcell.getOutputPorts();


%out_equations = cell(1, pilist.size() + inlist.size() + polist.size());
%out_equations{uid} = '';


piiterator = pilist.iterator();
while (piiterator.hasNext())
    port = piiterator.next();
    if (~port.isInputOnly()), suffix = '@O'; else suffix = ''; end
    push_port('', port, suffix);
end


initerator = inlist.iterator();
while (initerator.hasNext())
    instance = initerator.next();
    prefix = [char(instance.getName()) ','];
    
    celloutiterator = instance.getCellType().getOutputPorts().iterator();
    
    %celltype = ;
    
    

    while (celloutiterator.hasNext())
        port = celloutiterator.next();
        
        push_port(prefix, port, suffix);
    end
end


%if (~port.isOutputOnly()), suffix = '@O'; else suffix = ''; end 

poiterator = polist.iterator();
while (poiterator.hasNext())
    port = poiterator.next();
    if (~port.isOutputOnly()), suffix = '@I'; else suffix = ''; end
    push_port('', port, suffix);
end




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
    if (port.isBus())
        bitportlist = port.getSingleBitPortList();
        bitportlistiterator = bitportlist.iterator();
        while (bitportlistiterator.hasNext())
            bitport = bitportlistiterator.next();
            portindex = ['(' num2str(bitport.bitPosition()) ')'];
            signalname = [port.GetName() portindex suffix];
            push_signal(signalname);
        end
    else
        portindex = '';
        signalname = [port.getName() portindex suffix];
        push_signal(signalname);
    end
    %}
%{
piiterator = pilist.iterator();
while (piiterator.hasNext())
    port = piiterator.next();
    if (~port.isInputOnly()), suffix = '@O'; else suffix = ''; end
    
    
    bitportlist = port.getSingleBitPortList();
    bitportlistiterator = bitportlist.iterator();   
    
    if (port.isBus())
        while (bitportlistiterator.hasNext())
            bitport = bitportlistiterator.next();            
            portindex = ['(' num2str(bitport.bitPosition()) ')'];            
            signalname = [port.GetName() portindex suffix];
            push_signal(signalname);
        end
    else
        while (bitportlistiterator.hasNext())
            bitport = bitportlistiterator.next();
            portindex = '';
            signalname = [port.getName() portindex suffix];
            push_signal(signalname);
        end
    end
end
%}
%{
initerator = inlist.iterator();
while (initerator.hasNext())
    instance = initerator.next();
    instancename = char(instance.getName());
    
    celltype = instance.getCellType();
    cellout = celltype.getOutputPorts();
    celloutiterator = cellout.iterator();
    prefix = [instancename ','];
    
    
    while (celloutiterator.hasNext())
        port = celloutiterator.next();
        if (~port.isOutputOnly()), suffix = '@O'; else suffix = ''; end 
        
        bitportlist = port.getSingleBitPortList();
        bitportlistiterator = bitportlist.iterator();
        
        if (port.isBus())
            while (bitportlistiterator.hasNext())
                bitport = bitportlistiterator.next();
                portindex = ['(' num2str(bitport.bitPosition()) ')'];
                signalname = [prefix char(bitport.toString()) portindex suffix];
                push_signal(signalname);
            end
        else
        end
    end
end
%}







%net = bitport.getInnerNet();
    


%{
poiterator = polist.iterator();
while (poiterator.hasNext())
    port = poiterator.next();
    if (~port.isOutputOnly()), suffix = '@I'; else suffix = ''; end
    bitportlist = port.getSingleBitPortList();
    bitportlistiterator = bitportlist.iterator();
    while (bitportlistiterator.hasNext())
        bitport = bitportlistiterator.next();
        signalname = [char(bitport.toString()) suffix];
        push_signal(signalname);
    end
end
%}



%{
edgesiterator = edges.iterator();
while (edgesiterator.hasNext())
    edge = edgesiterator.next();
    
    %disp(edge.toString());
    
    sourceepr = edge.getSourceEPR();
    sinkepr = edge.getSinkEPR();
    sourcesbp = sourceepr.getSingleBitPort();
    sinksbp = sinkepr.getSingleBitPort();
    sourceport = sourceepr.getPort();
    sinkport = sinkepr.getPort();
    
    
    sourcename = char(sourceport.getName());
    if (sourceport.isBus()), sourceindex = ['(' num2str(sourcesbp.bitPosition()) ')']; else sourceindex = []; end
    if (~sourceepr.isTopLevelPortRef())
        sourceinstance = sourceepr.getCellInstance();
        sourceprefix = [char(sourceinstance.getName()) ','];
        if (~sourceport.isOutputOnly()), sourcesuffix = '@O'; else sourcesuffix = []; end
    else
        sourceprefix = [];
        if (~sourceport.isInputOnly()), sourcesuffix = '@O'; else sourcesuffix = []; end
    end
    head = [sourceprefix sourcename sourceindex sourcesuffix];
    
    
    sinkname = char(sinkport.getName());
    if (sinkport.isBus()), sinkindex = ['(' num2str(sinksbp.bitPosition()) ')']; else sinkindex = []; end
    if (~sinkepr.isTopLevelPortRef())
        sinkinstance = sinkepr.getCellInstance();
        sinkprefix = [char(sinkinstance.getName()) ','];
        if (~sinkport.isInputOnly()), sinksuffix = '@I'; else sinksuffix = []; end        
    else
        sinkprefix = [];
        if (~sinkport.isOutputOnly()), sinksuffix = '@I'; else sinksuffix = []; end
    end
    tail = [sinkprefix sinkname sinkindex sinksuffix];
        
    
    
    
    
    %else
    %    suffix = [];
    %end
    
    disp([head '->' tail]);
    
    
    

    
    
    
    
    %disp(edge);
end
%}

keys = signal2uid.keys();
out_labels(cell2mat(signal2uid.values(keys))) = keys;



    function push_input_port(in_port)
    end

    function push_output_port(in_port)
    end



    
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





%{
    
%}

edifgraph = edu.byu.ece.edif.util.graph.EdifCellInstanceGraph(topcell);



out_test = signal2uid;



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

