
%[delay, labels, range] = sample_valavan();
%[delay, labels, range] = sample_aaghalfadder();
%[delay, labels, range] = sample_aaglatch();
%[delay, labels, range, edges] = sample_edif(false);
%[delay, labels, range, edges] = sample_edif_special(false);

bg = build_graph(delay, labels, range);
view(bg);
