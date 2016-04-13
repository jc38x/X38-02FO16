
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









lutcount = 0;
while (initerator.hasNext())
    instance = initerator.next();
    type = char(instance.getType());
    if (~strcmpi(type(1:3), 'LUT')), continue; end

    instancename = char(instance.getName());
    inputs = str2double(type(4));
    [d, l, r, e] = tt2mat(char(instance.getProperty('INIT').getValue().getStringValue()), inputs);
    
    if (numel(type) < 6)
        rename = cell(1, inputs + 1);
        rename(end) = {'O'};
    elseif (strcmpi(type(6), 'L'))
        rename = cell(1, inputs + 1);
        rename(end) = {'LO'};
    elseif (strcmpi(type(6), 'D'))
        rename = cell(1, inputs + 2);
        rename(end) = {'O'};
        rename(end - 1) = {'LO'};
        [d, l, r, e] = group_nets({d, sparse([], [], [], 1, 1, 1)}, {l, {'lo'}}, {r, prepare_range(0, 0, 1)}, {e, {''}});
        d(get_inode(d, find(strcmpi('o', l))), strcmpi('lo', l)) = 1;
    else
        error('Unknown LUT type.');
    end
    
    for k = 1:inputs, rename{k} = ['I' num2str(k - 1)]; end
    [l, e] = rename_node(d, l, e, [r.pi, r.po], rename);
    [l, e] = make_instance(instancename, d, l, r, e);
    push_net(d, l, r, e);
    lut2uid(instancename) = uid;
    
    lutcount = lutcount + 1;
    
end
lutcount




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
    inode = get_inode(out_delay, k);
    if (isempty(inode)), error(['Unconnected LUT input ' label '.']); end
    if (test_lut(out_labels{inode})), inode = get_inode(out_delay, inode); end
    signal = ['[' label ']'];
    newsignal = ['[' out_labels{inode} ']'];
    onode = get_onode(out_delay, k);
    if (isempty(onode)), continue; end
    for n = onode, out_equations{n} = strrep(out_equations{n}, signal, newsignal); end
    mapproxy(k) = flatten_index_2d(repmat(inode, 1, numel(onode)), onode, out_range.sz);
end

for k = out_range.po
    label = out_labels{k};
    if (~test_lut(label)), continue; end
    mapremove(k) = k;
    inode = get_inode(out_delay, k);
    onode = get_onode(out_delay, k);
    if (isempty(onode)), error(['Unconnected LUT output ' label '.']); end
    onode = onode(is_po(onode, out_range));
    mapproxy(k) = flatten_index_2d(repmat(inode, 1, numel(onode)), onode, out_range.sz);
end

out_delay(cell_collapse(mapproxy.values())) = 1;
[out_delay, out_labels, out_range, out_equations] = remove_node(out_delay, out_labels, out_range, out_equations, cell_collapse(mapremove.values()));
out_edif = edifenvironment;
    
    function [out_isit] = test_lut(in_fullportname)
    pivot = find(in_fullportname == ',');
    out_isit = ~isempty(pivot) && lut2uid.isKey(in_fullportname(1:(pivot - 1)));
    end

    function push_net(in_d, in_l, in_r, in_e)
    uid = uid + 1;
    
    mapd(uid) = in_d;
    mapl(uid) = in_l;
    mapr(uid) = in_r;
    mape(uid) = in_e;
    
    maplabel = [maplabel; containers.Map(in_l, in_l)];
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
