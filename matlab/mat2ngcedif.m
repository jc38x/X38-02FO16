
function mat2ngcedif(in_filename, in_delay, in_labels, in_range, in_luts, in_inputs, in_names, in_edif)



ts = strsplitntrim(datestr(now, 'yyyy mm dd HH MM SS'), ' ');

fos = java.io.FileOutputStream(in_filename);
epw = edu.byu.ece.edif.core.EdifPrintWriter(fos);
dtor = onCleanup(@()epw.close());
tc = in_edif.getTopCell();

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

instanceiterator = tc.cellInstanceIterator();
while (instanceiterator.hasNext())
    instance = instanceiterator.next();
    type = char(instance.getType());
    if (strcmpi(type(1:3), 'LUT')), continue; end
    instance.toEdif(epw);
end






for k = 1:numel(in_luts)
    lutinit = in_luts{k};
    name = in_names{k};
    inputs = in_inputs{k};
    
    epw.printlnIndent(['(instance ' 'mat2ngcedif_LUT_' name]);
    epw.incrIndent();
    epw.printlnIndent(['(viewRef black_box (cellRef LUT' num2str(numel(inputs)) ' (libraryRef UNISIMS)))']);
    epw.printlnIndent('(property XSTLIB (boolean (true)))');
    epw.printlnIndent(['(property INIT (string "' lutinit '"))']);
    epw.decrIndent();
    epw.printlnIndent(')');
end

%nets






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
end
