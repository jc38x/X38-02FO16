
function [nets] = mat2ngcedif(in_filename, in_delay, in_labels, in_range, in_luts, in_inputs, in_names, in_edif)
fos = java.io.FileOutputStream(in_filename);
epw = edu.byu.ece.edif.core.EdifPrintWriter(fos);
dtor = onCleanup(@()epw.close());

ts = strsplitntrim(datestr(now, 'yyyy mm dd HH MM SS'), ' ');

epw.printlnIndent(['(edif ' char(in_edif.getName())]);
epw.incrIndent();
epw.printlnIndent('(edifVersion 2 0 0)');
epw.printlnIndent('(edifLevel 0)');
epw.printlnIndent('(keywordMap (keywordLevel 0))');
epw.printlnIndent('(status');
epw.incrIndent();
epw.printlnIndent('(written');
epw.incrIndent();
epw.printlnIndent(['(timeStamp ' ts{1} ' ' ts{2} ' ' ts{3} ' ' ts{4} ' ' ts{5} ' ' ts{6} ')']);
epw.printlnIndent('(author "matlab")');
epw.printlnIndent('(program "mat2ngcedif" (version "0.01a"))');
epw.decrIndent();
epw.printlnIndent(')');
epw.decrIndent();
epw.printlnIndent(')');





tc = in_edif.getTopCell();
edifgraph = edu.byu.ece.edif.util.graph.EdifCellInstanceGraph(tc);
edges = edifgraph.getEdges();
edgesiterator = edges.iterator();
instanceiterator = tc.cellInstanceIterator();
nets = containers.Map();
lutmap = containers.Map();
index2lutsize = {'1', '2', '3', '4', '5', '6'};
index2lutinput = {'I0', 'I1', 'I2', 'I3', 'I4', 'I5'};





in_edif.getLibrary('UNISIMS').toEdif(epw);

epw.printlnIndent(['(library ' char(tc.getLibrary().getName())]);
epw.incrIndent();
epw.printlnIndent('(edifLevel 0)');
epw.printlnIndent('(technology (numberDefinition))');
epw.printlnIndent(['(cell ' char(tc.getName())]);
epw.incrIndent();
epw.printlnIndent('(cellType GENERIC)');
epw.printlnIndent('(view view_1');
epw.incrIndent();
epw.printlnIndent('(viewType NETLIST)');

tc.getInterface().toEdif(epw);

epw.printlnIndent('(contents');
epw.incrIndent();

while (instanceiterator.hasNext())
    instance = instanceiterator.next();
    hit = unmap_table_xilinx(instance);
    if (hit), continue; end
    instance.toEdif(epw);
end

for k = get_inorder(in_delay, in_range)
    lutname = in_labels{k};
    inputs = in_labels(get_inode(in_delay, k));
    ni = numel(inputs);    
    initstring = regexp(in_luts{k}, '''[0-9a-fA-F]+''', 'match');
    initstring = initstring{1};
    initstring = initstring(2:(end - 1));
    
    epw.printlnIndent(['(instance ' lutname]);
    epw.incrIndent();
    epw.printlnIndent(['(viewRef black_box (cellRef LUT' index2lutsize{ni} ' (libraryRef UNISIMS)))']);
    epw.printlnIndent('(property XSTLIB (boolean (true)))');
    epw.printlnIndent(['(property INIT (string "' initstring '"))']);
    epw.decrIndent();
    epw.printlnIndent(')');
    
    for l = 1:ni
        input = inputs{l};
        if (lutmap.isKey(input)), source = [input ',O']; else source = input; end
        push_net(source, [lutname ',' index2lutinput{l}]);
    end
    
    lutmap(lutname) = lutname;
end

for k = in_range.po
    for e = get_inode(in_delay, k);
        label = in_labels{e};
        if (is_in(e,  in_range)), source = [label ',O']; else source = label; end
        push_net(source, in_labels{k})
    end
end

while (edgesiterator.hasNext())
    edge = edgesiterator.next();    
    sourceepr = edge.getSourceEPR();
    if (~sourceepr.isTopLevelPortRef() && unmap_table_xilinx(sourceepr.getCellInstance())), continue; end
    sinkepr   = edge.getSinkEPR();
    if (  ~sinkepr.isTopLevelPortRef() && unmap_table_xilinx(  sinkepr.getCellInstance())), continue; end    
    push_net(make_port_name(sourceepr, true), make_port_name(sinkepr, false));
end




    
    





netdrivers = nets.keys();
netid = 0;
for source = netdrivers
    netid = netid + 1;
    epw.printlnIndent(['(net mat2ngcedif_net_' num2str(netid)]);
    epw.incrIndent();
    epw.printlnIndent('(joined');
    epw.incrIndent();

    write_portref(source{:});
    for sink = nets(source{:})%nets.values(source);
        %class(sink{:})
        write_portref(sink{:});
    end
    
    epw.decrIndent();
    epw.printlnIndent(')');
    epw.decrIndent();
    epw.printlnIndent(')');
end






    function write_portref(in_portname)
        pivot = find(in_portname == ',');
        if (~isempty(pivot))
            instancename = in_portname(1:(pivot - 1));
            portbit = in_portname((pivot + 1):end);
            insttext = ['(instanceRef ' instancename ')'];
        else
            instancename = '';
            portbit = in_portname;
            insttext = [];
        end
        bitpivot = find(portbit == '(');
        if (~isempty(bitpivot))
            portname = portbit(1:(bitpivot - 1));
            bitpos = portbit((bitpivot + 1):(end - 1));
            porttext = ['(member ' portname ' ' bitpos ')'];
        else
            portname = portbit;
            bitpos = '';
            porttext = portname;
        end
        
        epw.printlnIndent(['(portRef ' porttext ' ' insttext ')']);
        
    end

    






epw.decrIndent();
epw.printlnIndent(')');
epw.decrIndent();
epw.printlnIndent(')');
epw.decrIndent();
epw.printlnIndent(')');
epw.decrIndent();
epw.printlnIndent(')');

in_edif.getTopDesign().toEdif(epw);

epw.decrIndent();
epw.printlnIndent(')');


    function push_net(in_sourceportname, in_sinkportname)    
    crop = find(in_sourceportname == '@');
    if (~isempty(crop)), sourcename = in_sourceportname(1:(crop - 1)); else sourcename = in_sourceportname; end
    crop = find(in_sinkportname == '@');
    if (~isempty(crop)), sinkname = in_sinkportname(1:(crop - 1)); else sinkname = in_sinkportname; end
    if (~nets.isKey(sourcename)), nets(sourcename) = {sinkname}; else nets(sourcename) = [nets(sourcename), {sinkname}]; end
    end


end
