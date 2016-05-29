%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_hit, out_inputs, out_rename, out_isd, out_tt] = unmap_table_xilinx(in_instance)
table = [
    {'LUT1',    1, {'I0'                                      'O'}, false, 'INIT'};
    {'LUT1_L',  1, {'I0'                                'LO'},      false, 'INIT'};
    {'LUT1_D',  1, {'I0'                                'LO', 'O'}, true,  'INIT'};
    {'LUT2',    2, {'I0', 'I1',                               'O'}, false, 'INIT'};
    {'LUT2_L',  2, {'I0', 'I1',                         'LO'},      false, 'INIT'};
    {'LUT2_D',  2, {'I0', 'I1',                         'LO', 'O'}, true,  'INIT'};
    {'LUT3',    3, {'I0', 'I1', 'I2',                         'O'}, false, 'INIT'};
    {'LUT3_L',  3, {'I0', 'I1', 'I2',                   'LO'},      false, 'INIT'};
    {'LUT3_D',  3, {'I0', 'I1', 'I2',                   'LO', 'O'}, true,  'INIT'};
    {'LUT4',    4, {'I0', 'I1', 'I2', 'I3',                   'O'}, false, 'INIT'};
    {'LUT4_L',  4, {'I0', 'I1', 'I2', 'I3',             'LO'},      false, 'INIT'};
    {'LUT4_D',  4, {'I0', 'I1', 'I2', 'I3',             'LO', 'O'}, true,  'INIT'};
    {'LUT5',    5, {'I0', 'I1', 'I2', 'I3', 'I4',             'O'}, false, 'INIT'};
    {'LUT5_L',  5, {'I0', 'I1', 'I2', 'I3', 'I4',       'LO'},      false, 'INIT'};
    {'LUT5_D',  5, {'I0', 'I1', 'I2', 'I3', 'I4',       'LO', 'O'}, true,  'INIT'};
    {'LUT6',    6, {'I0', 'I1', 'I2', 'I3', 'I4', 'I5',       'O'}, false, 'INIT'};
    {'LUT6_L',  6, {'I0', 'I1', 'I2', 'I3', 'I4', 'I5', 'LO'},      false, 'INIT'};
    {'LUT6_D',  6, {'I0', 'I1', 'I2', 'I3', 'I4', 'I5', 'LO', 'O'}, true,  'INIT'};
    ];

match = find(strcmpi(char(in_instance.getType()), table(:, 1)));
if (isempty(match))
    out_hit    = false;
    out_inputs = [];
    out_rename = [];
    out_isd    = [];
    out_tt     = [];
else
    tt = table{match, 5};
    switch (tt)
    case 'INIT', tt = char(in_instance.getProperty('INIT').getValue().getStringValue());
    end
    
    out_hit    = true;
    out_inputs = table{match, 2};
    out_rename = table{match, 3};
    out_isd    = table{match, 4};
    out_tt     = tt;
end
end
