%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_delay, out_range, out_label, out_equation] = eqn2mat(in_feqn)
global CONFIG

EQN_NFGETS = CONFIG.EQN_NFGETS;
EQN_BUFFERSIZE = CONFIG.EQN_BUFFERSIZE;
EQN_NEDGES = CONFIG.EQN_NEDGES;

fl = char(zeros(1, EQN_BUFFERSIZE, 'uint16'));
wp = 1;
nl = sprintf('\n');
line = 0;
celledges = cell(1, EQN_NEDGES);
cellindex = 1;
signal2uid = containers.Map();
uid = 1;
out_equation = containers.Map();

while (true)
    next = fgets(in_feqn, EQN_NFGETS);
    if (next == -1), break; end
    if (next(end) == nl), line = line + 1; end
    
    step = numel(next);
    nwp = wp + step;
    fl(wp:(nwp - 1)) = next;
    
    flindex = find(next == ';');
    if (numel(flindex) < 1)
        wp = nwp;
        continue;
    end

    bp = 1;
    for fi = flindex
        nbp = wp + fi;
        parse_statement(fl(bp:(nbp - 1)));
        bp = nbp;
    end
    fl(1:(nwp - bp)) = fl(bp:(nwp - 1));
    wp = (nwp + 1) - bp;
end

if (~isempty(strtrim(fl(1:(wp-1))))), parse_error(['Incomplete statement ''' fl '''']); end

edges = [celledges{1:end}];
inodes = edges(1, :);
onodes = edges(2, :);
allnodes = cell2mat(signal2uid.values());

pi = setdiff(inodes, onodes);
po = setdiff(onodes, inodes);
in = setdiff(allnodes, [pi, po]);

pilo = 1;
pihi = numel(pi);
inlo = pihi + 1;
inhi = pihi + numel(in);
polo = inhi + 1;
pohi = inhi + numel(po);

out_range = prepare_range(pilo, pihi, inlo, inhi, polo, pohi);

mapall = [
    containers.Map(num2cell(pi), num2cell(out_range.pi));
    containers.Map(num2cell(in), num2cell(out_range.in));
    containers.Map(num2cell(po), num2cell(out_range.po))
    ];

for i = 1:size(edges, 2)
    edges(1, i) = mapall(edges(1, i));
    edges(2, i) = mapall(edges(2, i));
end

out_delay = sparse(edges(1, :), edges(2, :), 1, out_range.sz, out_range.sz);

kma = mapall.keys();
ksu = signal2uid.keys();

mapallinv = containers.Map(mapall.values(kma), kma);
uid2signal = containers.Map(signal2uid.values(ksu), ksu);
out_label = uid2signal.values(mapallinv.values(num2cell(out_range.all)));

    function [out_msg] = build_msg(in_msg)
    out_msg = ['(' num2str(line) '): ' in_msg '.'];
    end

    function parse_error(in_msg)
    error(build_msg(in_msg));
    end

    function parse_warning(in_msg)
    warning(build_msg(in_msg));
    end

    function parse_statement(in_s)
    pivot = find(in_s == '=');
    if (numel(pivot) ~= 1), parse_error('Unexpected expression'); end        
    lstr = strtrim(in_s(1:(pivot - 1)));        
    if (isempty(lstr)), parse_error('Left of = is empty'); end
    rstr = strtrim(in_s((pivot + 1):(end-1)));
    if (isempty(rstr)), parse_error('Right of = is empty'); end

    switch (lstr)
    case 'INORDER',  parse_warning('INORDER statement ignored, PI are to be inferred');
    case 'OUTORDER', parse_warning('OUTORDER statement ignored, PO are to be inferred');
    otherwise
        if (out_equation.isKey(lstr)), parse_error(['Duplicate signal ''' in_str '''']); end
        out_equation(lstr) = rstr;
        if (~signal2uid.isKey(lstr)), try_add_signal(lstr, true, true, false); end
        inputs = strtrim(strsplit(rstr, {'*','+','^'}));
        for list = inputs
            ss = list{1};
            if (~signal2uid.isKey(ss))
                try_add_signal(ss, true, true, true);
                if (ss(1) == '!')
                    ssid = ss(2:end);
                    if (~signal2uid.isKey(ssid)), try_add_signal(ssid, true, true, false); end
                    push_edge(ssid, ss);
                end
            end
            push_edge(ss, lstr);
        end
    end
    end

    function [out_ok] = test_name(in_str)
    us = in_str == '_';
    out_ok = all(isstrprop(in_str, 'alphanum') | us) && (isstrprop(in_str(1), 'alpha') || us(1));
    end

    function [out_ok] = test_id(in_str)
    out_ok = ((in_str(1) == '[') && (in_str(end) == ']')) && all(isstrprop(in_str(2:(end-1)), 'digit'));
    end

    function try_add_signal(in_str, in_checkname, in_checkid, in_allownot)
    if (in_allownot && (in_str(1) == '!')), tss = in_str(2:end); else tss = in_str; end
    if (~(in_checkname && test_name(tss)) && ~(in_checkid && test_id(tss))), parse_error(['Unexpected token ''' in_str '''']); end
    signal2uid(in_str) = uid;
    uid = uid + 1;
    end

    function push_edge(in_strhead, in_strtail)
    celledges{cellindex} = [signal2uid(in_strhead); signal2uid(in_strtail)];
    cellindex = cellindex + 1;
    end
end
