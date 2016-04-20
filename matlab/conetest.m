
K = 4;
DF = false;

[delay, labels, range, equations] = load_leko_leku('leko-g5\g25');
%[delay, labels, range, equations] = sample_valavan();

%[delay, labels, equations] = sort_graph(delay, labels, range, equations);

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