
function [out_delay, out_labels, out_range, out_equations, out_edif] = ngcedif2mat(in_filename)
edifenvironment = edu.byu.ece.edif.util.parse.EdifParser.translate(in_filename);
topcell = edifenvironment.getTopCell();
edifgraph = edu.byu.ece.edif.util.graph.EdifCellInstanceGraph(topcell);

inlist = topcell.getCellInstanceList();
initerator = inlist.iterator();
edges = edifgraph.getEdges();
edgesiterator = edges.iterator();

lut2uid   = containers.Map();
mapd      = containers.Map('KeyType', 'double', 'ValueType', 'any');
mapl      = containers.Map('KeyType', 'double', 'ValueType', 'any');
mapr      = containers.Map('KeyType', 'double', 'ValueType', 'any');
mape      = containers.Map('KeyType', 'double', 'ValueType', 'any');
maplabel  = containers.Map();
mapremove = containers.Map('KeyType', 'double', 'ValueType', 'any');
mapproxy  = containers.Map('KeyType', 'double', 'ValueType', 'any');
mapedges  = containers.Map('KeyType', 'double', 'ValueType', 'any');

uid = 0;
edgecount = 0;

while (initerator.hasNext())
    instance = initerator.next();
    if (~any(strcmpi(char(instance.getType()), {'LUT2', 'LUT3', 'LUT4', 'LUT5', 'LUT6'}))), continue; end
    instancename = char(instance.getName());
    [d, l, r, e] = tt2mat(char(instance.getProperty('INIT').getValue().getStringValue()));
    [l, e] = rename_node(d, l, e, [1, 2, 3, 4, numel(l)], {'I0', 'I1', 'I2', 'I3', 'O'});
    [l, e] = make_instance(instancename, l, r, e);
    push_net(d, l, r, e);
    lut2uid(instancename) = uid;
end

while (edgesiterator.hasNext())
    edge = edgesiterator.next();
    sourcefullportname = make_port_name(edge.getSourceEPR(), true);
    sinkfullportname   = make_port_name(edge.getSinkEPR(),  false);    
    if (~test_lut(sourcefullportname) && ~test_lut(sinkfullportname)), continue; end
    if (~maplabel.isKey(sourcefullportname)), push_net(sparse([], [], [], 1, 1, 1), {sourcefullportname}, prepare_range(1, 0, 0), {''}); end
    if (~maplabel.isKey(sinkfullportname)),   push_net(sparse([], [], [], 1, 1, 1), {sinkfullportname},   prepare_range(0, 0, 1), {''}); end
    edgecount = edgecount + 1;
    mapedges(edgecount) = {sourcefullportname; sinkfullportname};
end

keys = num2cell(1:uid);
[out_delay, out_labels, out_range, out_equations] = group_nets(mapd.values(keys), mapl.values(keys), mapr.values(keys), mape.values(keys));
signal2index = containers.Map(out_labels, 1:numel(out_labels));
lutedges = cell_collapse(mapedges.values());

newedges = zeros(1, edgecount);
for k = 1:edgecount, newedges(k) = flatten_index_2d(signal2index(lutedges{1, k}), signal2index(lutedges{2, k}), out_range.sz); end
out_delay(newedges) = 1;

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
    mapproxy(k) = flatten_index_2d(repmat(inode, 1, numel(onode)), onode, out_range.sz);
end

for k = out_range.po
    label = out_labels{k};
    if (~test_lut(label)), continue; end
    mapremove(k) = k;
    onode = find(out_delay(k, :));
    if (isempty(onode)), continue; end
    mapproxy(k) = flatten_index_2d(find(out_delay(:, k)), onode, out_range.sz);
end

out_delay(cell_collapse(mapproxy.values())) = 1;
[out_delay, out_labels, out_range, out_equations] = remove_node(out_delay, out_labels, out_range, out_equations, cell_collapse(mapremove.values()));
out_edif = edifenvironment;

    function push_net(in_d, in_l, in_r, in_e)
    uid = uid + 1;
    mapd(uid) = in_d;
    mapl(uid) = in_l;
    mapr(uid) = in_r;
    mape(uid) = in_e;
    maplabel = [maplabel; containers.Map(in_l, in_l)];
    end

    function [out_isit] = test_lut(in_fullportname)
    pivot = find(in_fullportname == ',');
    out_isit = ~isempty(pivot) && lut2uid.isKey(in_fullportname(1:(pivot - 1)));
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

    
end
