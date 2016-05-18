
K = 4;
DF = false;
mode = 1;

%[delay, labels, range, equations, original] = load_leko_leku('leko-g5/g25');
%[delay, labels, range, equations, original] = load_leko_leku('leko-g5/g125');
%[delay, labels, range, equations, original] = load_leko_leku('leko-g5/g625');
%[delay, labels, range, equations, original] = load_leko_leku('leku/LEKU-CD');
%[delay, labels, range, equations, original] = load_lgsynth93('blif/ex1010');
[delay, labels, range, equations] = abc_tt2mat('ABCF', 4);

filename = 'C:/Users/jcds/Documents/GitHub/X38-02FO16/workspace/conetest.aig';
mat2aiger(filename, delay, labels, range, equations);

disp(size(delay));

script = [
    {['read_aiger ' filename]};
    {'strash'};
    {'ps'};
    {'b'};
    {'b'};
    
    {'rr'};
    {'resyn2'};
    repmat([{'rw -l'};{'b'};{'rw -lz'};{'b'};{'rf -l'};{'b'};{'resyn2rs'};{'b'}], 500, 1);
    
    %repmat([{'iresyn -l'}; {'irw -l'};], 300, 1);
    
    
    
    %repmat([{'resyn'};{'resyn2'};{'resyn2rs'};], 200, 1);
    
    %repmat([{'rw -l'};{'rw -lz'};{'b'};{'rw -lz'};{'b'};{'rf'};{'b'};], 30, 1);
    %repmat([{'rw -l'};{'b'};{'rw -lz'};{'b'};{'rf'};{'b'};], 1000, 1);
    %repmat([{'rw'};{'b'};{'rwz'};{'b'};{'rf'};{'b'};{'rfz'};{'b'};], 1000, 1);
    
    
    %{'resyn2'};
    %{'resyn2rs'};
    %{'resyn2rs'};
    %{'resyn2rs'};
    %{'resyn2rs'};
    %{'resyn2rs'};
    
    {'b'};
    {'b'};
    {'ps'};
    %{['write_aiger -s ' filename]};
    %{['read_blif ' original]};
    %{'comb'};
    %{['cec ' filename]};
    {'quit'};
    ];

response = invoke_abc(script);
%for k = 1:numel(response), fprintf('%s\n', response{k}); end

[delay, labels, range, equations] = aiger2mat(filename);

disp(size(delay));



[delay, labels, equations] = sort_graph(delay, labels, range, equations);

t = tic();
[s, cv] = hara(delay, range, mode, 4, 20, 2, 0, 0);

[rd, rl, rr, re] = rebuild_graph_from_cones(s, cv, delay, range, labels, equations);
[luts] = cones2luts(rd, rl, rr, re);
toc(t);



 

%}
%lutcount
%newedges = zeros(1, edgecount);
%for k = 1:edgecount, newedges(k) = sub2ind([out_range.sz, out_range.sz], signal2index(lutedges{1, k}), signal2index(lutedges{2, k})); end
%out_delay(newedges) = 1;
%check_network(delay, labels, range, equations);

%mat2aiger(filename, delay, labels, range, equations);

%response2 = invoke_abc({['read_blif ' original]; 'comb'; ['cec ' filename]; 'quit'});
%for k = 1:numel(response2), fprintf('%s\n', response2{k}); end
    %[cones] = generate_cones(delay, range, K);
    
    %redroenoc = 0;
    %containers.Map(num2cell(node), 1:subn);
    %coneorderc = graphtopoorder(sparse(cell2mat(noderemap.values(num2cell(edge(1, :)))), cell2mat(noderemap.values(num2cell(edge(2, :)))), 1, subn, subn));
    
    %keys = noderemap.keys();
    %keys = node;
    %remapnode = zeros(1, subn);%numel(keys));
    %remapnode(cell2mat(noderemap.values(keys))) = cell2mat(keys);
    %remapnode(noderemap.remap(node)) = node;
    
    % + in_range.pihi};
    %for l = remapnode(redroenoc), equation = strrep(equation, ['[' in_labels{l} ']'], ['(' in_equations{l} ')']); end
    %for l = remapnode(redroenoc), equation = strrep(equation, ['[' in_labels{l} ']'], [in_equations{l}]); end
    
%indices = find(tag);
%[~, I] = sort(tag(indices));
%out_labels = [in_labels(in_range.pi), in_labels(indices(I)), in_labels(in_range.po)];
%nsz = in_range.szpi + nin + in_range.szpo;
%nsz = out_range.sz;
%in_S = in_S;% - in_range.pihi;
%sum(in_delay(:) > 0);

%pilo = in_range.pilo;
%pihi = in_range.pihi;
%inlo = in_range.pihi + 1;
%inhi = in_range.pihi + nin;
%polo = inhi + 1;
%pohi = inhi + in_range.szpo;

%out_range = prepare_range(pilo, pihi, inlo, inhi, polo, pohi);
%{




%view(build_graph(delay, labels, range, equations));


[iedge, oedge] = prepare_edges(delay, range);
order = graphtopoorder(delay);
inorder = get_inorder(delay, range);
redro = fliplr(order);
depth = fill_depth(order, iedge, delay, range);
height = fill_height(redro, oedge, delay, range);
[af, noedge] = fill_af(order, iedge, oedge, range);


t = tic();
[cones] = generate_cones(inorder, iedge, oedge, range, K, delay);
toc(t);
%}






%{
    function [out_bc, out_bcdepth, out_bcaf] = best_cone(in_v)
    switch (in_mode)
        case 1, [out_bc, out_bcdepth, out_bcaf] = best_cone_depth(in_v);
        case 2, [out_bc, out_bcdepth, out_bcaf] = best_cone_area(in_v);
    end
    end
%}










%in_order
%in_iedge, in_oedge, in_noedge,
%in_depth, in_height, in_af,
%in_DF, 
 % DF/NDF








%if (~in_DF)
    %in_alpha = in_alpha;
%else
%    alpha = 0;
%end

%in_range.sz = in_range.sz;
%sum(in_delay(:) > 0);
%out_inode = cell(1, in_range.sz);
%out_onode = cell(1, in_range.sz);
%out_inode{n} = nv;
%out_onode{n} = nv;
%[tsort, allcones] = generate_cones_all(in_order, in_iedge, in_oedge, in_range, in_K, in_DF, in_delay);
%rtsort = fliplr(tsort);


%= in_depth;
 %= in_af;

%= in_height;

%= in_noedge;

%{
in_order, in_iedge, in_oedge
out_af = zeros(1, in_range.sz);
out_noedge = zeros(1, in_range.sz);
for v = in_order 
    Av = double(is_in(v, in_range));
    for i = in_iedge{v}
        idx = i(1);
        out_noedge(idx) = size(in_oedge{idx}, 2);
        Av = Av + (out_af(idx) / out_noedge(idx));
    end
    out_af(v) = Av;
end
%}
%{
in_redro, in_oedge, 
out_height = zeros(1, in_range.sz);
for v = in_redro
    for e = in_oedge{v}
        idx = e(2);
        h = out_height(idx) + in_delay(v, idx);
        if (h > out_height(v)), out_height(v) = h; end
    end
end
%}

%in_order, in_iedge, 
%in_iedge{v}
%{
out_depth = zeros(1, in_range.sz);
for v = in_order
    for e = in_iedge{v}
        idx = e(1);
        d = out_depth(idx) + in_delay(idx, v);
        if (d > out_depth(v)), out_depth(v) = d; end
    end
end
%}
%nodemarker = false(1, in_range.sz);
    %, nodemarker, in_range.all)); end
    
%, in_marker, in_map)
%marker = in_marker;
%marker(in_vector) = true;
%out_nodes = in_map(marker);
%filter = ~strcmpi('', stdout);
%filter = find(filter, 1, 'last');
%stdout = stdout(1:filter);

%celldisp(stdout);
%{
    function add_cone_generic(in_nr)
    nnr = numel(in_nr);
    subindex = 0;
    
    if (nnr == 0)
        allcones = cell(1, 1);
        try_add_cone(in);
    else
        vec = cell(1, nnr);
        offset = zeros(nnr, 1);
        adjnr = in_nr - in_range.szpi;
        nrc = cell_collapse(out_cones(adjnr));
        allcones = cell(1, prod(ncones(adjnr)));
        
        for k = 1:nnr, vec{k} = 1:ncones(adjnr(k)); end
        for k = 1:(nnr - 1), offset(k + 1) = offset(k) + ncones(adjnr(k)); end
        
        for combo = combvec(vec{:}), try_add_cone(unique_nodes([in, [nrc{combo + offset}]])); end
    end

    index = index + 1;
    cones{index} = allcones(1:subindex);
    ncones(adjin) = ncones(adjin) + subindex;
    end
%}
%{
function try_add_cone(in_c)
    ie = [in_iedge{in_c}];
    iec = ismembc(ie(1, :), in_c);
    iee = ~iec;
    if (numel(unique(ie(1, iee))) > in_K), return; end

    nroot = in_c ~= in;
    oenr = cell2mat(in_oedge(in_c(nroot)));
    if (~isempty(oenr)), oenr(:, ismembc(oenr(2, :), in_c)) = []; end

    index = index + 1;

    cones{1, index} = [in, in_c(nroot)];
    cones{2, index} = ie(:, iec);
    cones{3, index} = ie(:, iee);
    cones{4, index} = in_oedge{in};
    cones{5, index} = oenr;
end
%}
%{
    function add_cone(in_c)
    ie = [in_iedge{in_c}];
    iec = ismember(ie(1, :), in_c);
    iee = ~iec;
    
    oenr = [in_oedge{in_c(in_c ~= in)}];
    if (~isempty(oenr)), oenr(:, ismember(oenr(2, :), in_c)) = []; end
    
    index = index + 1;

    cones{1, index} = in_c;
    cones{2, index} = ie(:, iec);
    cones{3, index} = ie(:, iee);
    cones{4, index} = in_oedge{in};
    cones{5, index} = oenr;
    end
%}
%function push_cone_list()
    
    %end
%{
        
            %}

%mean(ncones)
    %max(ncones)

    %prune
    %dup
    %kcut
    

    %function [out_cone] = unique_nodes(in_c)
    %pick = nodemarker;
    %pick(in_c) = true;
    %out_cone = in_range.all(pick);
    %end
%if (sum(iee) > in_K)
    %kcut = kcut + 1;

%nnc = ;
        
        
        
        
        %newsubindex = ;
        %dup = dup + subindex - newsubindex;
        %prune = prune + (nnc1 * nnc2) - nnc;
%nr = in_nr - in_range.szpi;
        %nr1 = nr1;%nr1 - in_range.szpi;
        %nr2 = nr2;%nr2 - in_range.szpi;
%check_network(delay, labels, range, equations);
%[delay, labels, range, equations] = sample_valavan();
%{
{'balance'};
    {'refactor'};
    {'rewrite'}
    {'rr'};
    {'resyn2rs'};
    {'balance'};
    {'refactor'};
    {'rewrite'}
    {'rr'};
    {'resyn2rs'};
    {'balance'};
    {'refactor'};
    {'rewrite'}
    {'rr'};
%}

%paus
%response.m_cmd
%response2 = response.m_cmd;
%abc_response(response2);

%response = cell(1, ns);
%index = 0;
%disp('CALLBACK');
    %class(obj)
    %class(event)
    %stdoutresponse = [stdoutresponse; {char(event.Data)}];
    %celldisp(out_stdoutresponse);
    %disp(char(event.Data));
    %out_stdout.push(char(event.Data));
%disp('EXIT');

%process.StandardOutput.Close();

%celldisp(stdoutresponse);
%process.HasExited()
%s_lh.Source
%dbstack(0)


%refresh
%dbstack(0)
%fieldnames(s_lh)%class(s_lh)
%persistent stdoutresponse

%out_stdoutresponse = C_cmdfifo([]);
%out_stdout = C_vector(64);
%out_stdoutresponse = [];
%stdoutresponse = [];
%stdout = stdout.);

    %text = cell(1, (2 * ne) + 1);
    %subindex = 0;
    %subindex = subindex + 1;
        %text{subindex} = statement;
    
    
    
    
        %subindex = subindex + 1;
        %text{subindex} = [line(startindex(i):matchstop) in_script{j}];
        %subindex = subindex + 1;
            %text{subindex} = statement;
        
    
    
        
        
    
    %index = index + 1;
    %response{index} = text(1:subindex);

     %fprintf('%s\n', statement); end
    
    
    
    
        %fprintf('%s\n', );
    %fprintf('%s\n', statement); end
%class(in_response)


%while (in_cmdfifo.has_next())
    
    
%in_cmdfifo.next();%char(event.Data);






%out_response = [];


%if (in_output), h = @(obj, event)stdout_callback_abc(obj, event, C_cmdfifo(in_script)); else h = @stdout_callback_null; end



%--
%for e = edges
%    signal2uid.values(e);
%end
%--
%out_equations(out_range.top) = {''};
%symbol
    %if (isempty(symbol)), break; end
%strcat('[', in_labels(get_inode(in_delay, k)), ']');
%nodos = npi + nin + npo;
%id = 0;

%i = zeros(1, npi);
%v = zeros(1, nin);
%o = zeros(1, npo);
%for n = 1:npi, id = id + 1; i(n) = id; end
%for n = 1:nin, id = id + 1; v(n) = id; end
%for n = 1:npo, id = id + 1; o(n) = id; end
%m = 0;
%n2s = cell(1, m);
%i = 0;

%for n = 1:m, n2s{n} = num2str(n); end

%for n = 1:in_range.szpi, i = i + 1; out_labels{i} = ['i' n2s{n}]; end
%for n = 1:in_range.szin, i = i + 1; out_labels{i} = ['v' n2s{n}]; end
%for n = 1:in_range.szpo, i = i + 1; out_labels{i} = ['o' n2s{n}]; end
%newlabels = cell(1, in_range.sz);
%for k = in_range.all, newlabels{k} = [in_name ',' in_labels{k}]; end
%in_inorder
%nodestring = strtrim(cellstr(num2str(in_range.all.')).');
    %for n = 1:numel(nodestring), nodestring{n} = [nodestring{n} '.']; end
    %add_cone = @add_cone_2input;

%in = in;
    %in - in_range.szpi;
    
    
    
    %conemap = containers.Map();
    %conelist = [];
    
    
    %iedge = in_iedge{in};
    %inode = iedge(1, :);
%cones = cell_collapse(cones(1:index));
    %nc = numel(cones);
    %keep = true(1, nc);
    %for n = 1:nc, keep(n) = test_k(cones{n}); end
    %cones(keep);
    %function [out_ok] = test_k(in_c)
    %iee = sum(in_delay(:, in_c), 2) > 0;
    %iee(in_c) = 0;
    %out_ok = sum(iee) <= in_K;
    %end
%checkmap = containers.Map();
%for n = 1:in_range.szin
%    c = out_cones{n};
%    for m = 1:numel(c)
%        key = [nodestring{c{m}}];
%        if (checkmap.isKey(key)), disp(['DUP: ' num2str(checkmap(key)) ' : ' num2str([n, m])]); end
%        checkmap(key) = [n, m];
%    end
%end
%sortc = zeros(1, ncones(adjin));
    %for n = 1:ncones(adjin), sortc(n) = numel(scones{n}); end
    %[~, sortc] = sort(sortc);
    %scones(sortc);
%ncones(adjin) = ncones(adjin) + subindex;
%function trim_cones()
    %end
%{
        testcones = allcones(1:subindex);
        nc = zeros(1, subindex);
        prevsubindex = subindex;
        allcones = cell(1, subindex);
        subindex = 0;

        for j = 1:prevsubindex, nc(j) = numel(testcones{j}); end

        for j = unique(nc)
            tc = uniqueRowsCA(testcones(nc == j).');
            ntc = numel(tc);
            allcones((1:ntc) + subindex) = tc.';
            subindex = subindex + ntc;
        end
        %}
        %{
        
        %}
    
        %{

            disp('MISS');
            vec = cell(1, numel(nr));
            for k = 1:numel(nr), vec{k} = 1:ncones(nr(k)); end
            offset = zeros(numel(nr), 1);
            for k = 1:(numel(nr) - 1), offset(k + 1) = offset(k) + ncones(nr(k)); end
            
            nrcones = cell_collapse(out_cones(nr));
            for c = combvec(vec{:})
                cnr = unique([nrcones{c + offset}]);
                key = num2str(cnr);
                if (conemap.isKey(key)), continue; end
                conemap(key) = key;
                cone = [in, cnr];
                subindex = subindex + 1;
                allcones{subindex} = cone;
            end

            allcones = allcones(1:subindex);
            index = index + 1;
            cones{index} = allcones;
            
            ncones(adjin) = ncones(adjin) + subindex;
        end
    end
    %}%{
        vec = cell(1, nnr);
        offset = zeros(nnr, 1);
        adjnr = in_nr - in_range.szpi;
        nrc = cell_collapse(out_cones(adjnr));
        allcones = cell(1, prod(ncones(adjnr)));
        
        for k = 1:nnr, vec{k} = 1:ncones(adjnr(k)); end
        for k = 1:(nnr - 1), offset(k + 1) = offset(k) + ncones(adjnr(k)); end

        for combo = combvec(vec{:}), try_add_cone(unique_nodes([in, [nrc{combo + offset}]])); end
        trim_cones();
            %}
           
        %{
        
        %}
    
        %{

            disp('MISS');
            vec = cell(1, numel(nr));
            for k = 1:numel(nr), vec{k} = 1:ncones(nr(k)); end
            offset = zeros(numel(nr), 1);
            for k = 1:(numel(nr) - 1), offset(k + 1) = offset(k) + ncones(nr(k)); end
            
            nrcones = cell_collapse(out_cones(nr));
            for c = combvec(vec{:})
                cnr = unique([nrcones{c + offset}]);
                key = num2str(cnr);
                if (conemap.isKey(key)), continue; end
                conemap(key) = key;
                cone = [in, cnr];
                subindex = subindex + 1;
                allcones{subindex} = cone;
            end

            allcones = allcones(1:subindex);
            index = index + 1;
            cones{index} = allcones;
            
            ncones(adjin) = ncones(adjin) + subindex;
        end
    end
    %}
%cnr = unique([nrcones{combo + offset}]);
            %key = num2str(cnr);
            %if (conemap.isKey(key)), continue; end
            %conemap(key) = key;
            %try_add_cone([in, cnr]);
        
        
        
        
        
        
    
        %warning('Unimplemented operation');
        %allcones = [];
 %ie = [in_iedge{in_c}];
        %iee = ~ismembc(unique(ie(1, :)), in_c);
%tag1 = c1(1:(end - 1));
            %if (~isempty(tag1)), tag1 = tag1(end); end
            
            
            
                
                %tag2 = c2(1:(end - 1));
                %if (~isempty(tag2) && ~isempty(tag1) && any(tag1 == tag2)), prune = prune + 1; continue; end
                
                %x1 = c1(1:(end - 1));
                %x2 = c2(1:(end - 1));
                
                
                
                
                
                
                
                %{
                ck = [nodestring{cone}];
                if (conemap.isKey(ck))
                    dup = dup + 1;
                    continue;
                end
                conemap(ck) = 0;
                %}
%list2 = unique([list2 c2(1)]);
                %if (any(ismembc(list1, list2))), prune = prune + 1; continue; end
                
                %%if (any(tag == c2)), prune = prune + 1; continue; end
                %tag2 = c2(1:(end-1));
                %iex2 = [in_iedge{tag2}];
                %if ((~isempty(iex1) && ~isempty(iex2)) && any(ismembc(iex2(1,:), iex1(1,:)))), prune = prune + 1; continue; end
                
                %mk = marker;
                %mk([in, c1, c2]) = true;
                %cone = in_range.all(mk);
%cone = unique([in, c1, c2]);
                %ck = sprintf('%d.', cone);
                %%debug = conemap(ck);
                %if (any(strcmpi(ck, conelist))), dup = dup + 1; continue; end
                %conelist = [conelist, {ck}];
                %{nrc1; nrc2; k; l};
%list1 = unique([list1 c1(1:(end-1))]);
            %if (any(ismembc(list1, list2))), prune = prune + sum(keep2); continue; end
            
            %tag1 = c1(1:(end - 1));
            %iex1 = [in_iedge{tag1}];
%for k = v1, iex = [in_iedge{nrc1{k}}]; keep1(k) = ~any(iex(1, :) == nr2); end
        %for k = v2, iex = [in_iedge{nrc2{k}}]; keep2(k) = ~any(iex(1, :) == nr1); end

        %prune = prune + ((nnc1 * nnc2) - (sum(keep1) * sum(keep2)));
        
        
        
        %list1 = [];
        %list2 = [];
%{
        nncm = min([nnc1, nnc2]);
        keep1 = true(1, nnc1);
        keep2 = true(1, nnc2);
        for k = 1:nncm
            iex = [in_iedge{nrc1{k}}];
            keep1(k) = ~any(iex(1,:) == nr2);
            iex = [in_iedge{nrc2{k}}];            
            keep2(k) = ~any(iex(1,:) == nr1);
            if (~keep2(k) || ~keep1(k)), break; end
        end        
        for l = (k + 1):nnc1
            iex = [in_iedge{nrc1{l}}];
            keep1(l) = ~any(iex(1,:) == nr2);
        end
        for l = (k + 1):nnc2
            iex = [in_iedge{nrc2{l}}];
            keep2(l) = ~any(iex(1,:) == nr1);
        end
        
        v1 = 1:nnc1;
        v2 = 1:nnc2;
        %}
%end
   
    
         %for k = 1:index
   %     c = cones(k);
        
    %end
 %{
    total = index * prod(ncones(inpre));
    
    
    
    
    allcones = cell(1, total);
    allindex = 0;
    
    vec = cell(1, szin);
    for n = 1:szin, vec{n} = 1:ncones(inpre); end    
    nrcones = cell_collapse(out_cones(inpre));
    
    for c = combvec(vec{:})
    end
    %}
    
    
    %nrcones = ;
    %[nrcones{:}];
    

        
        
%disp([num2str(in) ': ' num2str(ncones(adjin))]);
%{
    if (isempty(nr))
        allcones = cell(1, 1);
        nnr = 0;
        try_add_cone(in);
    else
        nr = nr - in_range.szpi;
        allcones = cell(1, prod(ncones(nr)));
        
        
        if (nnr == 1)
            nnc = ncones(nr);
            nrcones = out_cones{nr};
            for k = 1:nnc
                cnr = sort(nrcones{k});
                key = num2str(cnr);
                try_add_cone([in, cnr]);
                conemap(key) = key;
            end          
        elseif (nnr == 2)
        else
        end
        
        
            if (isempty(nr))
        index = index + 1;
        allcones = cell(1, 1);
        allcones{1} = in;
        cones{index} = allcones;
        ncones(adjin) = ncones(adjin) + 1;
    else
        nr = nr - in_range.szpi;
        total = prod(ncones(nr));
        allcones = cell(1, total);
        subindex = 0;
        
        nnr = numel(nr);
        if (nnr < 2)
            nnc = ncones(nr);
            allcones = cell(1, nnc);
            nrcones = out_cones{nr};
            for k = 1:nnc
                cnr = sort(nrcones{k});
                key = num2str(cnr);
                allcones{k} = [in, nrcones{k}];
                conemap(key) = key;
                disp(['< 2: ' num2str(k) ' / ' num2str(nnc)]);
            end
            index = index + 1;
            cones{index} = allcones;
            ncones(adjin) = ncones(adjin) + nnc;
        elseif (nnr < 3)
            nnc1 = ncones(nr(1));
            nnc2 = ncones(nr(2));
            nrc1 = out_cones{nr(1)};
            nrc2 = out_cones{nr(2)};
            nnc = nnc1 * nnc2;
            allcones = cell(1, nnc);
            total = 0;
            for k = 1:nnc1
                for l = 1:nnc2
                    disp(['< 3: ' num2str((k - 1) * nnc2 + l) ' / ' num2str(nnc)]);
                    cnr = unique([nrc1{k}, nrc2{l}]);
                    key = num2str(cnr);
                    if (conemap.isKey(key)), continue; end
                    conemap(key) = key;
                    total = total + 1;
                    allcones{total} = [in, cnr];
                end
            end
            index = index + 1;
            cones{index} = allcones(1:total);
            ncones(adjin) = ncones(adjin) + total;
            
            
        else
        
        
%}
%numi = numel(in_inorder);
%counter = 0;
    %counter = counter + 1;
    %disp([num2str(counter) ' / ' num2str(numi)]);
    %conemap = containers.Map();
 %if (sum(is_pi(ind, in_range)) > in_K), disp('> K PI'); return; end
        %if (sum(is_pi(unique(ie(1, iee)), in_range)) > in_K), return; end
        %{
        if (nnr > 1)
            
            
            %if (sum(is_pi(unique(ie), in_range)) > in_K), disp('not K'); return; end
            
            
            
        end
            %}
        
    %in_nr = in_nr - in_range.szpi;
                %cnr = sort(nrcones{k});
                %key = num2str(cnr);
                
                %conemap(key) = key;
            
            
    %{
    subindex = 0;
    
    
    
%function [out_key] = hash_cone(in_c)
        %out_key = num2str(in_c); %628.324600 621.391284
        %out_key = sprintf('%d.',in_c); %434.963708
        %end
%ck = hash_cone(cone);
                    %disp(num2str(conemap(ck)));
                    %if (conemap(ck) ~= 2)
                    %    disp('BRKP');
                    %end
%1:nnc1
            %1:nnc2
            %if (any(c1 == nr2)), disp('HIT 1'); continue; end
            %if (any(c2 == nr1)), disp('HIT 2'); continue; end
   %ie1 = in_iedge{nr1};
        %ie2 = in_iedge{nr2};
        %if (any(ie1(1,:) == nr2) || any(ie2(1,:) == nr1))
        %    disp('HIT');
        %    return;
        %end
%ie1 = in_iedge{nr1};
                %ie2 = in_iedge{nr2};
                
                
                
                
                
                
                
                %if (any(c1 == nr2) || any(c2 == nr1))
                %    disp('        HIT');
                %    continue;
                %end
                %disp('    INNER');
            %disp('OUTER')
            %{
            key = num2str(unique(in_c));
            if (conemap.isKey(key))
                disp('DUP');% num2str(conemap(key)) ' :: ' num2str(nnr)]);
                debug_info = conemap(key);
                
                if (nnr < 1)
                    next_step = {
                        nnr;
                        in_c;
                        };
                elseif (nnr < 2)
                    next_step = {
                        nnr;
                        in_c;
                        nrcones;
                        k;
                        };
                else
                    next_step = {
                        nnr;
                        in_c;
                        nrc1;
                        nrc2;
                        k;
                        l;
                        };
                end
                if (debug_info{1} == 1)
                    return;
                end
                
                return;
            end
            if (nnr < 1)
                conemap(key) = {
                    nnr;
                    in_c;
                    };
            elseif (nnr < 2)
                conemap(key) = {
                    nnr;
                    in_c;
                    nrcones;
                    k;
                    };
            else
                conemap(key) = {
                    nnr;
                    in_c;
                    nrc1;
                    nrc2;
                    k;
                    l;
                    };
            end
            %}
            
        %ie = in_iedge{in_c};
        %ie = unique(ie(1, :));
        %iec = ismember(ie, in_c);
        %iee = ~iec;
        %if (numel(ie(iee)) > in_K), return; end
        %in_c = unique(in_c);
        
        %iec = ismembc(ie(1, :), in_c);
        %{
        ie = [in_iedge{in_c}];
        iec = ismember(ie(1, :), in_c);
        iee = ~iec;
        ind = unique(ie(1, iee));
        if (numel(ind) > in_K), return; end
        %}
%allcones{((k - 1) * nnc2) + l} = [in, unique([nrc1{k}, nrc2{l}])];
            %{
            if (any((ie1(1, :) >= (nr2 - 0.5)) & (ie1(1, :) <= (nr2 + 0.5))) || any((ie2(1, :) >= (nr1 - 0.5)) & (ie2(1, :) <= (nr1 + 0.5))))
                disp('HIT');
                ie1(1, :)
                nr2
                ie2(1, :)
                nr1
                allcones = [];
                subindex = 0;
            elseif (any(nr1 == nrc2{end}) || any(nr2 == nrc1{end}))
                disp('HIT2');
                allcones = [];
                subindex = 0;
        
            else
            
                nnc = nnc1 * nnc2;
                allcones = cell(1, nnc);
                subindex = 0;
                for k = 1:nnc1
                    for l = 1:nnc2
                        %allcones{((k - 1) * nnc2) + l} = [in, unique([nrc1{k}, nrc2{l}])];
                        try_add_cone([in, unique([nrc1{k}, nrc2{l}])]);
                    end
                end
            %end
                %}
%allcones = cell(1, nnc1);
                %for k = 1:nnc1, allcones{k} = [in, nrc1{k}]; end
                %subindex = nnc1;

                %allcones = cell(1, nnc2);
                %for k = 1:nnc2, allcones{k} = [in, nrc2{k}]; end
                %subindex = nnc2;
            %{
            total = 0;
            
                    disp(['< 3: ' num2str((k - 1) * nnc2 + l) ' / ' num2str(nnc)]);
                    cnr = unique([nrc1{k}, nrc2{l}]);
                    key = num2str(cnr);
                    if (conemap.isKey(key)), continue; end
                    conemap(key) = key;
                    total = total + 1;
                    allcones{total} = [in, cnr];
                end
            end
            %}
        
            %allcones = [];
            %subindex = 0;
                %}