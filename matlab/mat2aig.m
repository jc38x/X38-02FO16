%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************
% References
% http://fmv.jku.at/aiger/
%**************************************************************************

function mat2aig(in_filename, in_delay, in_labels, in_range, in_equations)
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






order = graphtopoorder(in_delay);

for k = order(is_in(order, in_range))
    equation = in_equations{k};
    start = find(equation == '(', 1);
    label = in_labels{k};

    switch (lower(equation(1:(start - 1))))
    case 'and'
        split = find(equation == ',');
        ns = numel(split);
        if (ns == 3), split = split(2); elseif (ns ~= 1), error_handler('Graph is not AIG.'); end
        push_and(label, equation((start + 2):(split - 2)), equation((split + 2):(end - 2)));
    case 'not'
        push_not(label, equation((start + 2):(end - 2)));
    otherwise
            
        if (equation == '1' || equation == '0')
            push_constant(label, equation);
        else
        error_handler('Graph is not AIG.');
        end
    end
end


l = sum(ilatch);
i = in_range.szpi - l;
o = in_range.szpo - l;
a = uid;
m = i + l + a;

write_line(['aig ' num2str(m) ' ' num2str(i) ' ' num2str(l) ' ' num2str(o) ' ' num2str(a)]);

latch = strcmpi('latch', in_equations(in_range.po));
ponodes = in_range.po(~latch);
polatch = in_range.po(latch);

for k = [polatch, ponodes], write_line(num2str(signal2literal(in_labels{in_delay(:, k) > 0}))); end

andlist = cell(1, a);
keys = and2uid.keys();
andlist(cell2mat(and2uid.values(keys))) = keys;

for andgate = andlist
    label = andgate{1};
    inputs = andinputs(label);
    rh0 = inputs(1);
    %disp('delta 0 ----');
    delta0 = encode(signal2literal(label) - rh0);
    if (delta0 < 1)
        disp(label);
    end
    %disp('delta 1 ----');
    delta1 = encode(rh0 - inputs(2));
    
    fwrite(fid, [delta0, delta1]);
end

piid = 0;
liid = 0;
poid = 0;

for k = pinodes, write_line(['i' num2str(piid) ' ' in_labels{k}]); piid = piid + 1; end
for k = pilatch, write_line(['l' num2str(liid) ' ' in_labels{k}]); liid = liid + 1; end
for k = ponodes, write_line(['o' num2str(poid) ' ' in_labels{k}]); poid = poid + 1; end

write_line('c');

write_line('Written by mat2aig');

%fclose(fid);



    function error_handler(in_msg)
    %fclose(fid);
    error(in_msg);
    end

    function [out_bytes] = encode(in_u32)
    if (in_u32 < 0), warning('< 0'); end
        
        
    out_bytes = uint8(zeros(1, 8));
    wp = 0;
    x = uint32(in_u32);
    while (true)
        b = bitand(x, 127);
        x = bitshift(x, -7);
        if (x ~= 0), b = bitor(b, 128); end
        wp = wp + 1;
        b = uint8(b);
        out_bytes(wp) = b;
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
        if (is_odd(lit))
            warning(['INVERTER OF INVERTER ' in_label ' | ' in_a ]);
            lit = lit - 1;
        else
            lit = lit + 1;
        end
        
        
    signal2literal(in_label) = lit;%signal2literal(in_a) + 1;
    end
end
