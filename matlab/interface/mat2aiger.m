%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************
% References
% http://fmv.jku.at/aiger/
%**************************************************************************

function mat2aiger(in_filename, in_delay, in_labels, in_range, in_equations)
fid = fopen(in_filename, 'w');
if (fid == -1), error(['Failed to open file ' in_filename '.']); end
dtor = onCleanup(@()fclose(fid));

signal2literal = containers.Map();
andinputs      = containers.Map();
and2uid        = containers.Map();

literal = 0;
uid     = 0;

ilatch  = strcmpi('#AIGERLATCH', in_equations(in_range.pi));
pinodes = in_range.pi(~ilatch);
pilatch = in_range.pi( ilatch);

for k = [pinodes, pilatch], push_literal(in_labels{k}); end

for k = get_inorder(in_delay, in_range)
    equation = in_equations{k};
    label = in_labels{k};

    if (any(strcmpi(equation, {'0', '1'})))
        push_constant(label, equation);
    elseif (strncmpi(equation, 'and', 3))
        inode = get_inode(in_delay, k);
        ina = in_labels{inode(1)};
        inb = in_labels{inode(end)};
        push_and(label, ina, inb);
    elseif (strncmpi(equation, 'not', 3))
        ina = in_labels{get_inode(in_delay, k)};
        push_not(label, ina);
    else
        error('Network is not AIG');
    end
end

vl = sum(ilatch);
vi = in_range.szpi - vl;
vo = in_range.szpo - vl;
va = uid;
vm = vi + vl + va;

write_line(['aig ' num2str(vm) ' ' num2str(vi) ' ' num2str(vl) ' ' num2str(vo) ' ' num2str(va)]);

olatch  = strcmpi('#AIGERLATCH', in_equations(in_range.po));
ponodes = in_range.po(~olatch);
polatch = in_range.po( olatch);

for k = [polatch, ponodes], write_line(num2str(signal2literal(in_labels{get_inode(in_delay, k)}))); end

keys = and2uid.keys();
andlist = cell(1, va);
andlist(cell2mat(and2uid.values(keys))) = keys;

for andgate = andlist
    signal = andgate{1};
    inputs = andinputs(signal);
    rh0 = inputs(1);    
    fwrite(fid, [encode(signal2literal(signal) - rh0), encode(rh0 - inputs(2))]);
end

piid = 0;
liid = 0;
poid = 0;

for k = pinodes
    write_line(['i' num2str(piid) ' ' in_labels{k}]);
    piid = piid + 1;
end

for k = pilatch
    label = in_labels{k};
    split = find(label == '_');
    write_line(['l' num2str(liid) ' ' label(1:(split(end - 1) - 1))]);
    liid = liid + 1;
end

for k = ponodes
    write_line(['o' num2str(poid) ' ' in_labels{k}]);
    poid = poid + 1;
end

write_line('c');
write_line(['Written by mat2aiger on ' datestr(now)]);

    function [out_bytes] = encode(in_u64)
    out_bytes = uint8(zeros(1, 8));
    wp = 0;
    x = uint64(in_u64);
    while (true)
        b = bitand(x, 127);
        x = bitshift(x, -7);
        if (x ~= 0), b = bitor(b, 128); end
        wp = wp + 1;
        out_bytes(wp) = uint8(b);
        if (x == 0), break; end;
    end
    out_bytes = out_bytes(1:wp);
    end

    function write_line(in_line)
	fprintf(fid, '%s\n', in_line);
    end

    function push_literal(in_label)
    literal = literal + 2;
    signal2literal(in_label) = literal; 
    end

    function push_and(in_label, in_a, in_b)
    andinputs(in_label) = sort([signal2literal(in_a), signal2literal(in_b)], 'descend');
    uid = uid + 1;
    and2uid(in_label) = uid;
    push_literal(in_label);
    end

    function push_constant(in_label, in_equation)
    signal2literal(in_label) = str2double(in_equation);
    end

    function push_not(in_label, in_a)
    lit = signal2literal(in_a);
    if (is_odd(lit)), lit = lit - 1; else lit = lit + 1; end
    signal2literal(in_label) = lit;
    end
end
