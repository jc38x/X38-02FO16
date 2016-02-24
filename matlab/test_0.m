
n = 1000;
sz = 1000;

t = tic();
for i = 1:n
    clear x
    x = zeros(sz, sz);
end
toc(t)

t = tic();
for i = 1:n
    clear y
    y(sz, sz) = 0;
end
toc(t)
