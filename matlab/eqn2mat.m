
function out_mat = eqn2mat(in_feqn)
out_mat = [];
fl = [];
index = 1;
line = 1;
nl = sprintf('\n');

haspilist = false;
haspolist = false;
signal2uid = containers.Map();
uid = 1;
edges = [];


while (true)
    next = fgets(in_feqn, 1024);
    if (next == -1), break; end
    fl = [fl, next];
    for c = fl(index:end)
        if (c ~= ';'),
            if (c == nl), line = line + 1; end
            index = index + 1;
            continue;
        end
        parse_statement(fl(1:index));
        fl(1:index) = [];
        index = 1;
        break;
    end
end

if (~isempty(fl)), parse_error(['Incomplete statement ''' fl '''']); end

    function parse_error(in_msg)
    error(['(' num2str(line) '): ' in_msg '.']);
    end

    function [out_ok] = test_name(in_str)
    us = in_str == '_';
    out_ok = all(isstrprop(in_str, 'alphanum') | us) && (isstrprop(in_str(1), 'alpha') || us(1));
    end

    function [out_ok] = test_id(in_str)
    out_ok = ((in_str(1) == '[') && (in_str(end) == ']')) && all(isstrprop(in_str(2:(end-1))));
    end

    function try_add_signal(in_str, in_checkname, in_checkid)        
    if (~(in_checkname && test_name(in_str)) && ~(in_checkid && test_id(in_str))), parse_error(['Unexpected token ''' str '''']); end
    if (signal2uid.isKey(in_str)), parse_error(['Duplicate signal ''' in_str '''']); end
    signal2uid(in_str) = uid;
    uid = uid + 1;
    end

    function push_signal_list(in_list)
    for signal = in_list, try_add_signal(signal{1}); end
    end



%str = ;
        %if (~test_name(str))
        %if (signal2uid.isKey(str)), parse_error(['Duplicate signal ''' str '''']); end


    function parse_statement(in_s)
        pivot = 1;
        
        
        for ch = in_s
            if (ch ~= '=')
                pivot = pivot + 1;
                continue;
            end
            lstr = strtrim(in_s(1:(pivot - 1)));
            rstr = strtrim(in_s((pivot + 1):end));
            break;
        end
        
        if (isempty(lstr)), parse_error('Left of = is empty'); end
        if (isempty(rstr)), parse_error('Right of = is empty'); end
        
        switch (lstr)
            case INORDER
                if (haspilist), parse_error('INORDER redefinition'); end
                push_signal_list(strtrim(strsplit(rstr)));
                haspilist = true;
            case OUTORDER
                if (haspolist), parse_error('OUTORDER redefinition'); end
                push_signal_list(strtrim(strsplit(rstr)));
                haspolist = true;
            otherwise
                try_add_signal(lstr);
                inputs = strtrim(strsplit(rstr, {'*','+','^'}));
                for list = inputs
                    ss = inputs{1};
                    
                    if (~signal2uid.isKey(ss))
                        if (ss(1) == '!')
                            tss = ss(2:end);
                        else
                            tss = ss;
                        end
                        try_add_signal(tss)
                        
                        
                        if (~test_name(tss) && ~test_id(tss)), parse_error('Unexpected expression'); end
                    
                    end
                    
                end
                
                
        end
        
        
        
        
        out_mat = [out_mat; {in_s}];
    end
end

%if (~testname(lstr) && test_id(str)), parse_error(['Unexpected token ''' str '''']); end
                %if (signal2uid.isKey(str)), parse_error(['Duplicate signal ''' str '''']); end
        %push_node_list()
                
                %{
                for pi = listpi
                    str = pi{1};
                    alphanum = isstrprop(str, 'alphanum');
                    us = str == '_';
                    an1 = isstrprop(str, 'alpha');                    
                    if (~all(alphanum | us) || ~(an1 || us(1))), parse_error(['Unexpected token ''' str '''']); end
                    if (signal2uid.isKey(str)), parse_error(['Duplicate signal ''' str '''']); end
                end
                %}
                
        %expr = strsplit(in_s);
        
        
        
        
        %and * or + not ! xor ^
