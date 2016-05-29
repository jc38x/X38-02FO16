%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_delay, out_labels, out_range, out_equations] = abc_tt2mat(in_tthex, in_inputs, in_lutsyn)
n = numel(in_tthex);
lutrange = 1:n;

out_delay     = cell(1, n);
out_labels    = cell(1, n);
out_range     = cell(1, n);
out_equations = cell(1, n);

wsp = get_workspace_path();
prefix = '_abc_tt2mat_';
ext = '.aig';
filelist = cell(1, n);
scriptdelta = 4 + numel(in_lutsyn);
script = cell((scriptdelta * n) + 1, 1);
scriptindex = 0;

for k = lutrange
    if (in_inputs{k} <= 1), continue; end
    nextindex = scriptindex + scriptdelta;
    filelist{k} = [wsp prefix num2str(k) ext];
    script((scriptindex + 1):nextindex) = [{['read_truth ' in_tthex{k}]}; {'strash'}; in_lutsyn; {['write_aiger -s ' filelist{k}]}; {'empty'}];
    scriptindex = nextindex;
end

scriptindex = scriptindex + 1;
script(scriptindex) = {'quit'};
script = script(1:scriptindex);

invoke_abc(script);

for k = lutrange
    inputs = in_inputs{k};

    if (inputs <= 1)
        switch (in_tthex{k})
        case '0', d = sparse(    2,      3,  1, 3, 3); l = {'i0', 'gnd_2', 'o'}; e = [{''}, {'0'},              {''}];
        case '1', d = sparse([1, 2], [2, 3], 1, 3, 3); l = {'i0', 'not_2', 'o'}; e = [{''}, {'not([i0])'},      {''}];
        case '2', d = sparse([1, 2], [2, 3], 1, 3, 3); l = {'i0', 'buf_2', 'o'}; e = [{''}, {'and([i0],[i0])'}, {''}];
        case '3', d = sparse(    2,      3,  1, 3, 3); l = {'i0', 'vcc_2', 'o'}; e = [{''}, {'1'},              {''}];
        end
        r = prepare_range(1, 1, 1);
    else
        [d, l, r, e] = aiger2mat(filelist{k});
        [l, e] = rename_node(d, l, e, r.po, {'o'});
        
        if (r.szin < 1)
            pt = get_inode(d, r.po);
            lpt = ['[' l{pt} ']'];
            r = prepare_range(r.szpi, 1, r.szpo);
            d = sparse([pt, r.in], [r.in, r.po], 1, r.sz, r.sz);
            l = [l(r.pi), {'buf_2'}, l(end)];
            e = [e(r.pi), {['and(' lpt ',' lpt ')']}, e(end)];
        end
    end
    
    out_delay{k}     = d;
    out_labels{k}    = l;
    out_range{k}     = r;
    out_equations{k} = e;
end
end
