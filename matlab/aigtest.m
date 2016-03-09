
[delay, labels, range] = aiger2mat('C:/Users/jcds/desktop/aigha.txt');

bg = build_graph(delay, labels, range);
view(bg);






%push_signal(in_inst);
%if (invertermap.isKey(in_inst)), return; end
        %invertermap(in_inst) = 1;
%%edges = [edges; {[literal '->' signal]}];
%edges = [edges; {[input1 '->' literal]}];
    %edges = [edges; {[input2 '->' literal]}];
%edges = [edges; {[num2str(newval) '->' in_inst]}];
 
    %out_remap = num2cell(out_final);

%edgelist = edgemap.values();
%edgelist = [edgelist{:}];
%n = max(edgelist(:));
%out_delay = sparse(out_final(1, :), out_final(2, :), 1, n, n);
%out_labels = [];
    
    %push_signal(signal);
    
%out_delay = edges;

%push_instance(literal, signal);
    %push_instance(['s' literal], signal);
%invtest = str2double(literal);
    %
    %li
    
    %uid = uid + 1;
    %signal2uid(str2double(nline{1})) = uid;
    %types{uid} = 2;
    
    %uid = uid + 1;
    
    %{
    latchinput = str2double();
    if (~signal2uid.isKey(latchinput))
        push_signal(latchinput);
        if (isodd(latchinput))
            inv = latchinput - 1;
            if (~signal2uid.iskey(inv))
                push_signal(inv);
            end
            edges = [edges, [inv; latchinput]];
        end
    end
    %}
    %map() = uid;
    %types{uid} = 3;
%types{uid} = 1;


%types = cell(1000);
%invertermap = containers.Map();
%push_instance('0', 'c_low');
%push_signal('c_low');
%push_instance('1', 'c_high');
%push_signal('c_high');



%out_raw = edges;
    


%out_intermediate = edges;










