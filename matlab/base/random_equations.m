%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_equations] = random_equations(in_delay, in_labels, in_range)
out_equations = cell(1, in_range.sz);
out_equations(in_range.top) = {''};

constants = [
    {'0'};
    {'1'};
    ];

gates = [
    {'and('},         {','},      {')'};
    {'or('},          {','},      {')'};
    {'xor('},         {','},      {')'};
    {'not(and('},     {','},      {'))'};
    {'not(or('},      {','},      {'))'};
    {'not(xor('},     {','},      {'))'};    
    {'and(not('},     {'),'},     {')'};
    {'or(not('},      {'),'},     {')'};
    {'xor(not('},     {'),'},     {')'};
    {'and('},         {',not('},  {'))'};
    {'or('},          {',not('},  {'))'};
    {'xor('},         {',not('},  {'))'};
    {'and(not('},     {'),not('}, {'))'};
    {'or(not('},      {'),not('}, {'))'};
    {'xor(not('},     {'),not('}, {'))'};    
    {'not(and(not('}, {'),'},     {'))'};
    {'not(or(not('},  {'),'},     {'))'};
    {'not(xor(not('}, {'),'},     {'))'};
    {'not(and('},     {',not('},  {')))'};
    {'not(or('},      {',not('},  {')))'};
    {'not(xor('},     {',not('},  {')))'};
    {'not(and(not('}, {'),not('}, {')))'};
    {'not(or(not('},  {'),not('}, {')))'};
    {'not(xor(not('}, {'),not('}, {')))'};
    ];

gaterange = 1:size(gates, 1);
constantrange = 1:size(constants, 1);
signals = strcat('[', in_labels, ']');

for in = in_range.in
    input = get_inode(in_delay, in);
    nni = numel(input);
    switch (nni)
    case 0, equation = constants{datasample(constantrange, 1)};
    case 1, equation = ['not(' signals{input} ')'];
    otherwise
        equation = make_gate(signals{input(1)}, signals{input(2)});
        for k = 3:nni, equation = make_gate(equation, signals{input(k)}); end
    end
    out_equations{in} = equation;
end

    function out_equation = make_gate(in_a, in_b)
    gate = datasample(gaterange, 1);
    out_equation = [gates{gate, 1} in_a gates{gate, 2} in_b gates{gate, 3}];
    end
end
