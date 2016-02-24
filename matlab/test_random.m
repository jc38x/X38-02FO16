

t = tic();

% recursion max 500, INmax aprox. 500+(NPI-5)
%[delay, range] = random_dag(385, 555, 60, 1, 10); %ok
[delay, range] = random_dag(100, 200, 10, 1, 10); %ok
%[delay, range] = random_dag(20, 30, 10, 1, 10); %ok
%[delay, range] = random_dag(6, 6, 2, 1, 10); %ok
toc(t)


[labels] = node_labels(range);

bg = build_graph(delay, labels, range);
view(bg);




%{
errors = 0
for i = 1:1000
    try
        [delay, range] = random_dag(6, 6, 2, 1, 10);
    catch
        errors = errors + 1;
    end
end
errors
%}