
function [out_delay, out_labels, out_range, out_equations, out_edif] = ngcedif2mat(in_filename)

edifenvironment = edu.byu.ece.edif.util.parse.EdifParser.translate(in_filename);
out_edif = edifenvironment;
topcell = edifenvironment.getTopCell();
edifgraph = edu.byu.ece.edif.util.graph.EdifCellInstanceGraph(topcell);
edges = edifgraph.getEdges();


inlist = topcell.getCellInstanceList();



lut2uid = containers.Map();
uid2d = containers.Map('KeyType', 'double', 'ValueType', 'any');
uid2l = containers.Map('KeyType', 'double', 'ValueType', 'any');
uid2r = containers.Map('KeyType', 'double', 'ValueType', 'any');
uid2e = containers.Map('KeyType', 'double', 'ValueType', 'any');
uid = 0;





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
    [l, e] = rename_node(d, l, e, [1, 2, 3, 4, numel(l)], {'I0', 'I1', 'I2', 'I3', 'O'});
    [l, e] = make_instance(instancename, l, r, e);
    uid = uid + 1;
    uid2d(uid) = d;
    uid2l(uid) = l;
    uid2r(uid) = r;
    uid2e(uid) = e;
    lut2uid(instancename) = uid;
end

keys = num2cell(1:uid);
[out_delay, out_labels, out_range, out_equations] = group_nets(uid2d.values(keys), uid2l.values(keys), uid2r.values(keys), uid2e.values(keys));



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

edgesiterator = edges.iterator();
while (edgesiterator.hasNext())
    edge = edgesiterator.next();

    sourcefullportname = make_port_name(edge.getSourceEPR(), true);
    sinkfullportname = make_port_name(edge.getSinkEPR(), false);
    
    if (~test_lut(sourcefullportname) && ~test_lut(sinkfullportname)), continue; end
    
    connect = false;
    sourceindex = find(strcmpi(sourcefullportname, out_labels));
    if (isempty(sourceindex)), sourceindex = connect_lut_port(sourcefullportname, true, sinkfullportname); connect = true; end    
    sinkindex = find(strcmpi(sinkfullportname, out_labels));
    if (isempty(sinkindex)), sinkindex = connect_lut_port(sinkfullportname, false, sourcefullportname); connect = true; end
    
    %
    if (~connect)
    out_delay(sourceindex, sinkindex) = 1;
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
            if (~port.isInputOnly()),  suffix = '@O'; else suffix = ''; end
        else
            if (~port.isOutputOnly()), suffix = '@I'; else suffix = ''; end
        end
    end
    out_name = [prefix name bit suffix];
    end
    
    function [out_isit] = test_lut(in_fullportname)
    pivot = find(in_fullportname == ',');
    out_isit = ~isempty(pivot) && lut2uid.isKey(in_fullportname(1:(pivot - 1)));
    end

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



   
    
  
end
