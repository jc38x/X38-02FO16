
[delay, labels, range] = aiger2mat('C:/Users/jcds/desktop/aiglatch.txt');

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




%input1 = nline{2};
%{
    signal = ['inv1_' in_inst];    
    push_head_node(in_inst, signal);
    add_in_list(signal2uid(signal));
    %}
        %newval = ;
%push_instance(in_inst, signal);
    %push_signal(signal);
%{
    literal = nline;
    signal = ['i_' num2str(k)];
    push_instance(literal, signal);
    push_signal(signal);    
    add_pi_list(signal2uid(signal));
    %}
    %{
    literal = nline{1};
    signal = ['latch_i_' num2str(k)];
    push_instance(literal, signal);
    push_signal(signal);    
    add_pi_list(signal2uid(signal));
    %}
    %{
    literal = nline{2};
    signal = ['latch_o_' num2str(k)];
    push_signal(signal);
    try_push_inverter(literal);    
    push_edge(literal, signal);    
    add_po_list(signal2uid(signal));
    %}
    %{
    literal = nline;
    signal = ['o_' num2str(k)];
    push_signal(signal);
    try_push_inverter(literal);    
    push_edge(literal, signal);    
    add_po_list(signal2uid(signal));
    %}
%{
    literal = nline{1};
    signal = ['and_2_' num2str(k)];
    push_instance(literal, signal);
    push_signal(signal);    
    add_in_list(signal2uid(signal));
    %}

  %{
    input1 = nline{2};
    try_push_inverter(input1);    
    push_edge(input1, literal);
    %}
    %{
    input2 = nline{3};
    try_push_inverter(input2);    
    push_edge(input2, literal);
    %}


%inlist = [inlist, signal2uid(ss)];
        %edges = [edges, {in_head; in_tail}];
%pilist = [pilist, signal2uid(signal)];
    %pilist = [pilist, signal2uid(signal)];
    %polist = [polist, signal2uid(signal)];
    %inlist = [inlist, signal2uid(signal)];
    %polist = [polist, signal2uid(signal)];
    %edges = [];





   %literal = nline;
        %literal = nline{2}; 

    
    

    %function add_pi_list(in_uid)
    
    %end

    %function add_po_list(in_uid)
    
    %end

    %function add_in_list(in_uid)
    
    %end

%add_pi_list(signal2uid(signal));
%add_po_list(signal2uid(signal));
%add_in_list(signal2uid(signal));
    
%{
    %%%EST
(3 * a) + i + o + (2 * l)
edgesindex
i + l
piindex
o + l
poindex
(2 * a) + i
inindex
%}


    






    


    



