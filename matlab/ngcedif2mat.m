
function [out_delay, out_labels, out_range, out_equations] = ngcedif2mat(in_filename)

edifenvironment = edu.byu.ece.edif.util.parse.EdifParser.translate(in_filename);
topcell = edifenvironment.getTopCell();
edifgraph = edu.byu.ece.edif.util.graph.EdifCellInstanceGraph(topcell);
edges = edifgraph.getEdges();

alllist = topcell.getPortList();
pilist = topcell.getInputPorts();
inlist = topcell.getCellInstanceList();
polist = topcell.getOutputPorts();

lut2uid = containers.Map();
uid2lut = containers.Map();
lut2net = containers.Map();
uid = 0;
piindex = 0;
poindex = 0;




out_delay = [];
out_labels = [];
out_range = [];
out_equations = [];

initerator = inlist.iterator();
while (initerator.hasNext())
    instance = initerator.next();
    if (~any(strcmpi(char(instance.getType()), {'LUT2', 'LUT3', 'LUT4', 'LUT5', 'LUT6'}))), continue; end
    
    instancename = char(instance.getName());
    [d, l, r, e] = tt2mat(char(instance.getProperty('INIT').getValue().getStringValue()));
    [l, e] = make_instance(instancename, l, r, e);
    
    uid = uid + 1;
    if (uid == 1)
        out_delay = d;
        out_labels = l;
        out_range = r;
        out_equations = e;
    else
        [out_delay, out_labels, out_range, out_equations] = join_net(out_delay, out_labels, out_range, out_equations, d, l, r, e, []);
    end
    
    lut2uid(instancename) = uid;
end


    

edgesiterator = edges.iterator();
while (edgesiterator.hasNext())
    edge = edgesiterator.next();
    sourceepr = edge.getSourceEPR();
    sinkepr = edge.getSinkEPR();
    
    sourcefullportname = make_port_name(sourceepr, true);
    sinkfullportname = make_port_name(sinkepr, false);    
    issourcelut = test_lut(sourcefullportname);
    issinklut = test_lut(sinkfullportname);
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
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
end


    function [out_name] = make_port_name(in_portepr, in_source)
    port = in_portepr.getPort();
    name = char(port.getName());
    if (port.isBus()), bit = ['(' num2str(in_portepr.getSingleBitPort().bitPosition()) ')']; else bit = ''; end
    if (~in_portepr.isTopLevelPortRef())
        prefix = [char(in_portepr.getCellInstance().getName()) ','];
        suffix = '';
	else
        prefix = '';
        if (in_source)
            if (~port.isInputOnly()),  suffix = '@o'; else suffix = ''; end
        else
            if (~port.isOutputOnly()), suffix = '@i'; else suffix = ''; end
        end
    end
    out_name = lower([prefix name bit suffix]);
    end
    
    function [out_isit] = test_lut(in_fullportname)
    pivot = find(in_fullportname == ',');
    out_isit = ~isempty(pivot) && lut2uid.isKey(in_fullportname(1:(pivot - 1)));
    end





   
    
  
end
