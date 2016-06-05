%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************
% References
% https://docs.oracle.com/javase/7/docs/api/java/io/FileOutputStream.html
%**************************************************************************

function mat2ngcedif(in_filename, in_delay, in_labels, in_range, in_luts, in_edif)
fos = java.io.FileOutputStream(in_filename);
epw = edu.byu.ece.edif.core.EdifPrintWriter(fos);
dtor = onCleanup(@()epw.close());
ts = strsplitntrim(datestr(now, 'yyyy mm dd HH MM SS'), ' ');
tc = in_edif.getTopCell();
edifgraph = edu.byu.ece.edif.util.graph.EdifCellInstanceGraph(tc);
edges = edifgraph.getEdges();
edgesiterator = edges.iterator();
instanceiterator = tc.cellInstanceIterator();
index2lutsize = {'1', '2', '3', '4', '5', '6'};
index2lutinput = {'I0', 'I1', 'I2', 'I3', 'I4', 'I5'};
nets = containers.Map();

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

lib = in_edif.getLibrary('UNISIMS');

for k = 1:6
    cellname = ['LUT' index2lutsize{k}];
    if (lib.containsCellByName(cellname)), continue; end
    lutcell = edu.byu.ece.edif.core.EdifCell(lib, cellname);
    for l = 1:k, lutcell.addPort(index2lutinput{l}, 1, edu.byu.ece.edif.core.EdifPort.IN); end
    lutcell.addPort('O', 1, edu.byu.ece.edif.core.EdifPort.OUT);
end

lib.toEdif(epw);

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
    inode = get_inode(in_delay, k);    
    ni = numel(inode);
    
    if (ni < 1), continue; end
    
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
    
    for l = 1:ni, push_net(translate_source(inode(l)), [lutname ',' index2lutinput{l}]); end
end
    
for k = in_range.po
    for e = get_inode(in_delay, k), push_net(translate_source(e), in_labels{k}); end
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

for k = 1:numel(netdrivers)
    epw.printlnIndent(['(net mat2ngcedif_net_' num2str(k)]);
    epw.incrIndent();
    epw.printlnIndent('(joined');
    epw.incrIndent();
    
    source = netdrivers{k};
    write_portref(source);
    for sink = nets(source), write_portref(sink{:}); end
    
    epw.decrIndent();
    epw.printlnIndent(')');
    epw.decrIndent();
    epw.printlnIndent(')');
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

    function [out_source] = translate_source(in_inode)
    if     (is_pi(in_inode, in_range)),      out_source =  in_labels{in_inode};
    elseif (strcmp(in_luts{in_inode}, '0')), out_source =  'XST_GND,G';
    elseif (strcmp(in_luts{in_inode}, '1')), out_source =  'XST_VCC,P';
    else                                     out_source = [in_labels{in_inode} ',O'];
    end
    end

    function write_portref(in_portname)
    pivot = find(in_portname == ',');
    if (~isempty(pivot))
        instancename = in_portname(1:(pivot - 1));
        portbit = in_portname((pivot + 1):end);
        insttext = ['(instanceRef ' instancename ')'];
    else
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
        porttext = portname;
    end
    epw.printlnIndent(['(portRef ' porttext ' ' insttext ')']);
    end

    function push_net(in_sourceportname, in_sinkportname)
	crop = find(in_sourceportname == '@');
    if (~isempty(crop)), sourcename = in_sourceportname(1:(crop - 1)); else sourcename = in_sourceportname; end
    crop = find(in_sinkportname == '@');
    if (~isempty(crop)),   sinkname =   in_sinkportname(1:(crop - 1)); else   sinkname =   in_sinkportname; end
    if (~nets.isKey(sourcename)), nets(sourcename) = {sinkname}; else nets(sourcename) = [nets(sourcename), {sinkname}]; end
    end
end
