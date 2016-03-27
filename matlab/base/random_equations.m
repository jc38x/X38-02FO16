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

for in = in_range.in
    input = find(in_delay(:, in));
    switch (numel(input))
    case 0
        out_equations(in) = constants{datasample(constantrange, 1)};
    case 1
        out_equations(in) = {['not([' in_labels{input} '])']};
    case 2
        gate = datasample(gaterange, 1);
        out_equations(in) = {[gates{gate, 1} '[' in_labels{input(1)} ']' gates{gate, 2} '[' in_labels{input(2)} ']' gates{gate, 3}]};
    otherwise
        error('Gates with more than 2 inputs are not supported.');
    end
end
end
