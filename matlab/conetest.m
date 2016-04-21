
K = 4;
DF = false;

[delay, labels, range, equations] = load_leko_leku('leko-g5\g25');
%[delay, labels, range, equations] = load_lgsynth93('blif\alu4');
%[delay, labels, range, equations] = sample_valavan();


%{
filename = 'C:/Users/jcds/Documents/GitHub/X38-02FO16/workspace/conetest.aig';
mat2aiger(filename, delay, labels, range, equations);

script = [
    {['read_aiger ' filename ';']};
    {'strash'};
    {'resyn2rs'};
    {'resyn2rs'};
    {'resyn2rs'};
    {'resyn2rs'};
    {'resyn2rs'};
    {'resyn2rs'};
    %repmat([{'balance'}; {'rewrite'}; {'refactor'};], 200, 1);    
    {['write_aiger -s ' filename]};
    {'quit'};
    ];

invoke_abc(script, false);

[delay, labels, range, equations] = aiger2mat(filename);
%}

[delay, labels, equations] = sort_graph(delay, labels, range, equations);


%view(build_graph(delay, labels, range, equations));


[iedge, oedge] = prepare_edges(delay, range);
order = graphtopoorder(delay);
inorder = get_inorder(delay, range);
redro = fliplr(order);
depth = fill_depth(order, iedge, delay, range);
height = fill_height(redro, oedge, delay, range);
[af, noedge] = fill_af(order, iedge, oedge, range);


t = tic();
[cones] = generate_cones(inorder, iedge, oedge, range, K);
toc(t);

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