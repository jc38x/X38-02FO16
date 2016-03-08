
t = tic();
[graph, labels, range, edges] = ediftools('C:/Users/jcds/desktop/example-special.edif', false);
toc(t)


bg = build_graph(graph, labels, range);
view(bg);





%edges.size()







%for i = range.in
%    if (sum(graph(:, i) > 0) > 2), disp([labels{i} ' has more than 2 inputs']); end
%end

%{            %add = ;
            %if (~add)
                
                %disp(['Multiple outputs ' hinst '.']);
            %end
            
            %instancemap(hinst) = unique([instancemap(hinst), headuid]);
    
%}
%function try_push_instance(in_inststr, in_instuid)
        %try_push_instance(hinst, headuid);
    %end


%if (edgemap.isKey(edgestr)), warning(['Found duplicate edge ' edgestr '.']); end
    %if (headuid == tailuid), warning(['Found edge with same head and tail ' edgestr '.']); end
%{
if (~graphisdag(out_graph)), warning('Resulting graph is not a DAG'); end

for i = out_range.pi
    if (~any(out_graph(i, :))), warning(['PI ' out_labels{i} ' has no outputs.']); end
    if (any(out_graph(:, i))), warning(['PI ' out_labels{i} ' has inputs.']); end
end

for i = out_range.in
    if (~any(out_graph(i, :))), warning(['IN ' out_labels{i} ' has no outputs.']); end
    if (~any(out_graph(:, i))), warning(['IN ' out_labels{i} ' has no inputs.']); end
end

for i = out_range.po
    if (any(out_graph(i, :))), warning(['PO ' out_labels{i} ' has outputs.']); end
    sie = sum(out_graph(:, i) > 0);
    if     (sie < 1), warning(['PO ' out_labels{i} ' has no inputs.']);
    elseif (sie > 1), warning(['PO ' out_labels{i} ' has multiple drivers.']); end
end
%}

    
    
    
    


%out_instance = 
        
        
        %{
        block = port{1};        
        x1 = find(block == '(');
        x2 = find(block == ')');
        x1 = x1(end);
        x2 = x2(end);
        out_instance = block(1:(x1 - 1));
        out_primitive = block((x1 + 1):(x2 - 1));
        out_io = port{2};
        out_istop = strcmp(out_instance(1:3), 'top');
        %}
    %id = strtrim(port, {'(', ')'}));
	%out_instance = port{1};
    %primin = id{1};
    %if (~primmap.isKey(primin)), primmap(primin) = id{2}; end



    
%{
while (edgesiter.hasNext())
    signals = strsplitntrim(char(edgesiter.next().toString()), '->');
    [hinst, hio, histop] = translate_port(signals{1});
    [tinst, tio, tistop] = translate_port(signals{2});
    headsignalstr = ['[' hinst ', ' hio ']'];
    
    try_push_signal(headsignalstr);
    if (tistop)
        try_push_signal(['[' tinst ', ' tio ']']);
    end
    if (~histop)
        try_push_instance(hinst, signal2uid(headsignalstr));
    end
end

edgesiter = edges.iterator();
while (edgesiter.hasNext())
    signals = strsplitntrim(char(edgesiter.next().toString()), '->');
    [hinst, hio, histop] = translate_port(signals{1});
    [tinst, tio, tistop] = translate_port(signals{2});
    
    headstr = ['[' hinst ', ' hio ']'];
    headuid = signal2uid(headstr);
    if (histop && ~pimap.isKey(headstr)), pimap(headstr) = headuid; end
    
    if (tistop)
        tailstr = ['[' tinst ', ' tio ']'];
        tailuids = signal2uid(tailstr);
        if (~pimap.isKey(tailstr)), pomap(tailstr) = tailuids; end
    else
        tailstr = tinst;
        tailuids = instancemap(tailstr);
    end
    
    edgestr = ['[' hinst ', ' hio ']->[' tinst ', ' tio ']'];
    if (~edgemap.isKey(edgestr))
        newedges = [repmat(headuid, 1, size(tailuids, 2)); tailuids];
        edgemap(edgestr) = newedges;

        for e = newedges
            edgesindex = edgesindex + 1;
            edgescell(:, edgesindex) = {headuid; e(2); tio};
        end
    end
end
%}


 %c = v{1};
%edgesiter = edges.iterator();
%while (edgesiter.hasNext())
%edge = char(edgesiter.next().toString());
%c = preprocess(edge);

    
    
    %hinst = ;
    %hio = ;
    %histop = c{1, 3};
    %head = ;
    
    
    
    %tinst = ;
    
    %tistop = ;

%out_edges = signal2uid;
%out_graph = instancemap;
%[];
%out_edges = containers.Map();
%outputmap = containers.Map();
%out_edges = [];
%out_graph = [];
%out_range = [];
%out_labels = [];




    

%edgesiter =

                
            %edgescell = [edgescell, {headuid; e(2); tio}];
            
            %out_edges([num2str(headuid, '%u') '->' num2str(e(2), '%u')]) = tio;
    
    %[tinst, tio, tistop] = translate_port(signals{2});    
    
    
    %headstr = ['[' hinst ', ' hio ']'];
    %tailstr = [
    
    
    
    %head = make_port_name(hinst, hio, histop);
    %tail = make_port_name(tinst, tio, tistop);
    
    

    
    
    %if (~isKey(hinst)), outputmap(hinst) = hio; end
    %if (~istop && ~strcmp(outputmap(hinst), hio)), error(['Cell ' hinst ' has more than one output. Cells with multiple outputs are not supported.']); end
    %{
    try_push_signal(head);
    try_push_signal(tail);
    
   
    tailuid = signal2uid(tail);
    
    

    
    
    
    
    
    
end
%}


    


%out_io(isspace(out_io)) = [];
%out_instance(isspace(out_instance)) = [];
    


%out_edges = [out_edges, {char(edgesiter.next().toString())}];
%cellname(isspace(cellname)) = [];
%disp(char(topcell.toString()));
%disp(char(flattopcell.toString()));
%disp(char(edifenv.getTopDesign().toString()));
%primmap = containers.Map();
%inputmap = containers.Map();
% Edge format: [instance(primitive), port[bit]]->[instance(primitive), port[bit]]
%count = 0;
   
%{
while (edgesiter.hasNext())
	
    
    
    
    
    headstr = ['[' hinst ', ' hio ']'];    
    tailstr = ['[' tinst ', ' tio ']'];
    
    
    
    
    
    try_push_instance(headstr, hinst);
    try_push_instance(tailstr, tinst);
    
    
    

    
end









%containers.Map();
    

%out_istop = strcmp(out_instance, topname);

    

    function [out_name] = make_port_name(in_instance, in_io, in_istop)
    if (in_istop), out_name = ['[' in_instance ', ' in_io ']']; else out_name = ['[' in_instance ']']; end
    end
%}
    

    