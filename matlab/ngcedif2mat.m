%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_delay, out_labels, out_range, out_equations, out_edif, out_stats] = ngcedif2mat(in_filename, in_lutsyn)
edifenvironment = edu.byu.ece.edif.util.parse.EdifParser.translate(in_filename);
topcell = edifenvironment.getTopCell();
edifgraph = edu.byu.ece.edif.util.graph.EdifCellInstanceGraph(topcell);
initerator = topcell.getCellInstanceList().iterator();
edgesiterator = edifgraph.getEdges().iterator();

alloc = intmax('uint16');

lutset   = containers.Map();
maplabel = containers.Map();

mapd = cell(1, alloc);
mapl = cell(1, alloc);
mapr = cell(1, alloc);
mape = cell(1, alloc);
uid  = 0;

lutbatch = cell(6, alloc);
lutindex = 0;

while (initerator.hasNext())
    instance = initerator.next();
    [hit, inputs, rename, isd, tt] = unmap_table_xilinx(instance);
    if (~hit), continue; end    
    lutindex = lutindex + 1;
    
    lutbatch{1, lutindex} = inputs;
    lutbatch{2, lutindex} = rename;
    lutbatch{3, lutindex} = isd;
    lutbatch{4, lutindex} = tt;
    lutbatch{5, lutindex} = char(instance.getName());
    lutbatch{6, lutindex} = char(instance.getType());
end

lutrange = 1:lutindex;
lutbatch = lutbatch(:, lutrange);

[dl, ll, rl, el] = abc_tt2mat(lutbatch(4, :), lutbatch(1, :), in_lutsyn);

for k = lutrange
    instancename = lutbatch{5, k};
    
    d = dl{k};
    l = ll{k};
    r = rl{k};
    e = el{k};
    
    if (lutbatch{3, k})
        lpo = get_inode(d, r.po);
        [d, l, r, e] = group_nets({d, sparse([], [], [], 1, 1, 1)}, {l, {'lo'}}, {r, prepare_range(0, 0, 1)}, {e, {''}});
        d(lpo, r.po) = 1;
    end
    
    [l, e] = rename_node(d, l, e, [r.pi, r.po], lutbatch{2, k});
    [l, e] = make_instance(instancename, d, l, r, e);
    push_net(d, l, r, e);
    lutset(instancename) = 0;
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

bufindex = find(~cellfun('isempty', regexp(out_labels, '.*,?buf_.*')));
mapproxy = cell(1, out_range.sz);

for k = bufindex
    onode = get_onode(out_delay, k);
    mapproxy{k} = sub2ind2(out_range.sz, repmat(get_inode(out_delay, k), 1, numel(onode)), onode);
end

out_delay(cell_collapse(mapproxy)) = 1;
[out_delay, out_labels, out_range, out_equations] = remove_node(out_delay, out_labels, out_range, out_equations, bufindex);

out_edif  = edifenvironment;
out_stats = lutbatch;

    function [out_isit] = test_lut(in_fullportname)
    pivot = find(in_fullportname == ',');
    out_isit = ~isempty(pivot) && lutset.isKey(in_fullportname(1:(pivot - 1)));
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
