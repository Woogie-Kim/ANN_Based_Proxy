%% RUN SCRIPT
warning('off');
run Eco.m
run('\Matlab(JW)\VVS_7PARAM(modify)\10Point\Best3\Final_copy\MPERM\MATPERM.m')
run Eco.m
run('\Matlab(JW)\VVS_7PARAM(modify)\10Point\Best3\Final_copy\NFPERM\NFRACPERM.m')
run Eco.m
run('\Matlab(JW)\VVS_7PARAM(modify)\10Point\Best3\Final_copy\MPORO\MATPORO.m')
run Eco.m
run('\Matlab(JW)\VVS_7PARAM(modify)\10Point\Best3\Final_copy\NFPORO\NFRACPORO.m')

movefile \Matlab(JW)\VVS_7PARAM(modify)\10Point\Best3\Final_copy\MPERM\NPV_Calculation.xlsx \Matlab(JW)\VVS_7PARAM(modify)\10Point\Best3\Final_copy\NPV\NPV_MPERM.xlsx
movefile \Matlab(JW)\VVS_7PARAM(modify)\10Point\Best3\Final_copy\NFPERM\NPV_Calculation.xlsx \Matlab(JW)\VVS_7PARAM(modify)\10Point\Best3\Final_copy\NPV\NPV_NFRACPERM.xlsx
movefile \Matlab(JW)\VVS_7PARAM(modify)\10Point\Best3\Final_copy\MPORO\NPV_Calculation.xlsx \Matlab(JW)\VVS_7PARAM(modify)\10Point\Best3\Final_copy\NPV\NPV_MATPORO.xlsx
movefile \Matlab(JW)\VVS_7PARAM(modify)\10Point\Best3\Final_copy\NFPORO\NPV_Calculation.xlsx \Matlab(JW)\VVS_7PARAM(modify)\10Point\Best3\Final_copy\NPV\NPV_NFRACPORO.xlsx

