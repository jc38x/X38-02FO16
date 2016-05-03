%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_delay, out_labels, out_range, out_equations, out_edif] = ngcedif2mat(in_filename)
edifenvironment = edu.byu.ece.edif.util.parse.EdifParser.translate(in_filename);
topcell = edifenvironment.getTopCell();
edifgraph = edu.byu.ece.edif.util.graph.EdifCellInstanceGraph(topcell);
inlist = topcell.getCellInstanceList();
initerator = inlist.iterator();
edges = edifgraph.getEdges();
edgesiterator = edges.iterator();

lut2uid   = containers.Map();
maplabel  = containers.Map();
mapd      = containers.Map('KeyType', 'double', 'ValueType', 'any');
mapl      = containers.Map('KeyType', 'double', 'ValueType', 'any');
mapr      = containers.Map('KeyType', 'double', 'ValueType', 'any');
mape      = containers.Map('KeyType', 'double', 'ValueType', 'any');
mapremove = containers.Map('KeyType', 'double', 'ValueType', 'any');
mapproxy  = containers.Map('KeyType', 'double', 'ValueType', 'any');
mapedges  = containers.Map('KeyType', 'double', 'ValueType', 'any');

uid = 0;
edgecount = 0;

while (initerator.hasNext())
    instance = initerator.next();
    type = char(instance.getType());

    switch (upper(type))
    case 'LUT1',    inputs = 1; rename = {'I0'                                      'O'}; isd = false; tt = char(instance.getProperty('INIT').getValue().getStringValue());
    case 'LUT1_L',  inputs = 1; rename = {'I0'                                'LO'};      isd = false; tt = char(instance.getProperty('INIT').getValue().getStringValue());
    case 'LUT1_D',  inputs = 1; rename = {'I0'                                'LO', 'O'}; isd = true;  tt = char(instance.getProperty('INIT').getValue().getStringValue());
    case 'LUT2',    inputs = 2; rename = {'I0', 'I1',                               'O'}; isd = false; tt = char(instance.getProperty('INIT').getValue().getStringValue());
    case 'LUT2_L',  inputs = 2; rename = {'I0', 'I1',                         'LO'};      isd = false; tt = char(instance.getProperty('INIT').getValue().getStringValue());
    case 'LUT2_D',  inputs = 2; rename = {'I0', 'I1',                         'LO', 'O'}; isd = true;  tt = char(instance.getProperty('INIT').getValue().getStringValue());
    case 'LUT3',    inputs = 3; rename = {'I0', 'I1', 'I2',                         'O'}; isd = false; tt = char(instance.getProperty('INIT').getValue().getStringValue());
    case 'LUT3_L',  inputs = 3; rename = {'I0', 'I1', 'I2',                   'LO'};      isd = false; tt = char(instance.getProperty('INIT').getValue().getStringValue());
    case 'LUT3_D',  inputs = 3; rename = {'I0', 'I1', 'I2',                   'LO', 'O'}; isd = true;  tt = char(instance.getProperty('INIT').getValue().getStringValue());
    case 'LUT4',    inputs = 4; rename = {'I0', 'I1', 'I2', 'I3',                   'O'}; isd = false; tt = char(instance.getProperty('INIT').getValue().getStringValue());
    case 'LUT4_L',  inputs = 4; rename = {'I0', 'I1', 'I2', 'I3',             'LO'};      isd = false; tt = char(instance.getProperty('INIT').getValue().getStringValue());
    case 'LUT4_D',  inputs = 4; rename = {'I0', 'I1', 'I2', 'I3',             'LO', 'O'}; isd = true;  tt = char(instance.getProperty('INIT').getValue().getStringValue());
    case 'LUT5',    inputs = 5; rename = {'I0', 'I1', 'I2', 'I3', 'I4',             'O'}; isd = false; tt = char(instance.getProperty('INIT').getValue().getStringValue());
    case 'LUT5_L',  inputs = 5; rename = {'I0', 'I1', 'I2', 'I3', 'I4',       'LO'};      isd = false; tt = char(instance.getProperty('INIT').getValue().getStringValue());
    case 'LUT5_D',  inputs = 5; rename = {'I0', 'I1', 'I2', 'I3', 'I4',       'LO', 'O'}; isd = true;  tt = char(instance.getProperty('INIT').getValue().getStringValue());
    case 'LUT6',    inputs = 6; rename = {'I0', 'I1', 'I2', 'I3', 'I4', 'I5',       'O'}; isd = false; tt = char(instance.getProperty('INIT').getValue().getStringValue());
    case 'LUT6_L',  inputs = 6; rename = {'I0', 'I1', 'I2', 'I3', 'I4', 'I5', 'LO'};      isd = false; tt = char(instance.getProperty('INIT').getValue().getStringValue());
    case 'LUT6_D',  inputs = 6; rename = {'I0', 'I1', 'I2', 'I3', 'I4', 'I5', 'LO', 'O'}; isd = true;  tt = char(instance.getProperty('INIT').getValue().getStringValue());
    otherwise,      continue;
    end

    instancename = char(instance.getName());
    [d, l, r, e] = tt2mat(tt, inputs);
    if (isd)
        [d, l, r, e] = group_nets({d, sparse([], [], [], 1, 1, 1)}, {l, {'lo'}}, {r, prepare_range(0, 0, 1)}, {e, {''}});
        d(get_inode(d, find(strcmpi('o', l))), strcmpi('lo', l)) = 1;
    end
    [l, e] = rename_node(d, l, e, [r.pi, r.po], rename);
    [l, e] = make_instance(instancename, d, l, r, e);
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
out_delay(sub2ind2(out_range.sz, cell2mat(signal2index.values(lutedges(1, :))), cell2mat(signal2index.values(lutedges(2, :))))) = 1;

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
    mapproxy(k) = sub2ind2(out_range.sz, repmat(inode, 1, numel(onode)), onode);
end

for k = out_range.po
    label = out_labels{k};
    if (~test_lut(label)), continue; end
    mapremove(k) = k;
    inode = get_inode(out_delay, k);
    onode = get_onode(out_delay, k);
    if (isempty(onode)), error(['Unconnected LUT output ' label '.']); end
    onode = onode(is_po(onode, out_range));
    mapproxy(k) = sub2ind2(out_range.sz, repmat(inode, 1, numel(onode)), onode);
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
end
