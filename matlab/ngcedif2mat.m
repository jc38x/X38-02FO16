%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_delay, out_labels, out_range, out_equations, out_edif, out_stats] = ngcedif2mat(in_filename, in_lutsyn)
edifenvironment = edu.byu.ece.edif.util.parse.EdifParser.translate(in_filename);
topcell = edifenvironment.getTopCell();
edifgraph = edu.byu.ece.edif.util.graph.EdifCellInstanceGraph(topcell);
inlist = topcell.getCellInstanceList();
initerator = inlist.iterator();
edges = edifgraph.getEdges();
edgesiterator = edges.iterator();



lut2uid   = containers.Map();
maplabel  = containers.Map();

mapd      = cell(1, intmax('uint16'));
mapl      = cell(1, intmax('uint16'));
mapr      = cell(1, intmax('uint16'));
mape      = cell(1, intmax('uint16'));

uid = 0;


alloc = intmax('uint16');



lutbatch = cell(5, alloc);
lutindex = 0;

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
    
    lutindex = lutindex + 1;
    
    lutbatch{1, lutindex} = inputs;
    lutbatch{2, lutindex} = rename;
    lutbatch{3, lutindex} = isd;
    lutbatch{4, lutindex} = tt;
    lutbatch{5, lutindex} = char(instance.getName());
end




lutrange = 1:lutindex;
lutbatch = lutbatch(:, lutrange);

script = cell(alloc, 1);
scriptindex = 0;
wsp = get_workspace_path();
prefix = '_tmp_ngcedif2mat_';
ext = '.aig';

for k = lutrange
    tt = lutbatch{4, k};
    if (lutbatch{1, k} <= 1), continue; end
    nextindex = scriptindex + 4 + numel(in_lutsyn);
    script((scriptindex + 1):nextindex) = [{['read_truth ' tt]}; {'strash'}; in_lutsyn; {['write_aiger -s ' wsp prefix lutbatch{5, k} ext]}; {'empty'}];
    scriptindex = nextindex;
end

scriptindex = scriptindex + 1;
script(scriptindex) = {'quit'};
script = script(1:scriptindex);
        
invoke_abc(script);

lutcount = zeros(1, 6);

for k = lutrange
    instancename = lutbatch{5, k};
    inputs = lutbatch{1, k};

    if (inputs <= 1)
        switch (lutbatch{4, k})
        case '0', d = sparse(    2,      3,  1, 3, 3); l = {'i0', 'gnd_2', 'o'}; e = [{''}, {'0'},              {''}];
        case '1', d = sparse([1, 2], [2, 3], 1, 3, 3); l = {'i0', 'not_2', 'o'}; e = [{''}, {'not([i0])'},      {''}];
        case '2', d = sparse([1, 2], [2, 3], 1, 3, 3); l = {'i0', 'and_2', 'o'}; e = [{''}, {'and([i0],[i0])'}, {''}];
        case '3', d = sparse(    2,      3,  1, 3, 3); l = {'i0', 'vcc_2', 'o'}; e = [{''}, {'1'},              {''}];
        end
        
        r = prepare_range(1, 1, 1);
    else
        [d, l, r, e] = aiger2mat([wsp prefix instancename ext]);
        [l, e] = rename_node(d, l, e, r.po, {'o'});
        
        if (r.szin < 1)
            pt = get_inode(d, r.po);
            lpt = ['[' l{pt} ']'];
            r = prepare_range(r.szpi, 1, r.szpo);
            d = sparse([pt, r.in], [r.in, r.po], 1, r.sz, r.sz);
            l = [l(r.pi), {'and_2'}, l(end)];
            e = [e(r.pi), {['and(' lpt ',' lpt ')']}, e(end)];
        end
    end

    if (lutbatch{3, k})
        lpo = get_inode(d, r.po);
        [d, l, r, e] = group_nets({d, sparse([], [], [], 1, 1, 1)}, {l, {'lo'}}, {r, prepare_range(0, 0, 1)}, {e, {''}});
        d(lpo, r.po) = 1;
    end
    
    [l, e] = rename_node(d, l, e, [r.pi, r.po], lutbatch{2, k});
    [l, e] = make_instance(instancename, d, l, r, e);
    push_net(d, l, r, e);
    lut2uid(instancename) = uid;
    lutcount(inputs) = lutcount(inputs) + 1;
end

mapedges = cell(1, alloc);
edgecount = 0;

while (edgesiterator.hasNext())
    edge = edgesiterator.next();
    sourcefullportname = make_port_name(edge.getSourceEPR(), true);
    sinkfullportname   = make_port_name(edge.getSinkEPR(),  false);    
    if (~test_lut(sourcefullportname) && ~test_lut(sinkfullportname)), continue; end
    if (~maplabel.isKey(sourcefullportname)), push_net(sparse([], [], [], 1, 1, 1), {sourcefullportname}, prepare_range(1, 0, 0), {''}); end
    if (~maplabel.isKey(sinkfullportname)),   push_net(sparse([], [], [], 1, 1, 1), {sinkfullportname},   prepare_range(0, 0, 1), {''}); end
    edgecount = edgecount + 1;
    mapedges{edgecount} = {sourcefullportname; sinkfullportname};
end

nets = 1:uid;
mapd = mapd(nets);
mapl = mapl(nets);
mapr = mapr(nets);
mape = mape(nets);

[out_delay, out_labels, out_range, out_equations] = group_nets(mapd, mapl, mapr, mape);
signal2index = containers.Map(out_labels, out_range.all);
mapedges = cell_collapse(mapedges);
out_delay(sub2ind2(out_range.sz, cell2mat(signal2index.values(mapedges(1, :))), cell2mat(signal2index.values(mapedges(2, :))))) = 1;

mapremove = cell(1, out_range.sz);
mapproxy  = cell(1, out_range.sz);

for k = out_range.pi
    label = out_labels{k};
    if (~test_lut(label)), continue; end
    mapremove{k} = k;
    inode = get_inode(out_delay, k);
    if (isempty(inode)), error(['Unconnected LUT input ' label '.']); end
    if (test_lut(out_labels{inode})), inode = get_inode(out_delay, inode); end
    signal = ['[' label ']'];
    newsignal = ['[' out_labels{inode} ']'];
    onode = get_onode(out_delay, k);
    for n = onode, out_equations{n} = strrep(out_equations{n}, signal, newsignal); end
    mapproxy{k} = sub2ind2(out_range.sz, repmat(inode, 1, numel(onode)), onode);
end

for k = out_range.po
    label = out_labels{k};
    if (~test_lut(label)), continue; end
    mapremove{k} = k;
    inode = get_inode(out_delay, k);
    onode = get_onode(out_delay, k);
    if (isempty(onode)), error(['Unconnected LUT output ' label '.']); end
    onode = onode(is_po(onode, out_range));
    mapproxy{k} = sub2ind2(out_range.sz, repmat(inode, 1, numel(onode)), onode);
end

out_delay(cell_collapse(mapproxy)) = 1;
[out_delay, out_labels, out_range, out_equations] = remove_node(out_delay, out_labels, out_range, out_equations, cell_collapse(mapremove));
out_edif = edifenvironment;





        
        %d(get_inode(d, find(strcmpi('o', l))), strcmpi('lo', l)) = 1;
    
    
    
    













disp(['LUT1: ' num2str(lutcount(1))]);
disp(['LUT2: ' num2str(lutcount(2))]);
disp(['LUT3: ' num2str(lutcount(3))]);
disp(['LUT4: ' num2str(lutcount(4))]);
disp(['LUT5: ' num2str(lutcount(5))]);
disp(['LUT6: ' num2str(lutcount(6))]);
disp('-');
disp(['LUTs: ' num2str(lutindex)]);




























    function [out_isit] = test_lut(in_fullportname)
    pivot = find(in_fullportname == ',');
    out_isit = ~isempty(pivot) && lut2uid.isKey(in_fullportname(1:(pivot - 1)));
    end

    function push_net(in_d, in_l, in_r, in_e)
    uid = uid + 1;    
    mapd{uid} = in_d;
    mapl{uid} = in_l;
    mapr{uid} = in_r;
    mape{uid} = in_e;    
    maplabel = [maplabel; containers.Map(in_l, in_l)];
    end
end
