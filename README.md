# EEG-MEG-COMPARISONS
1- give dataset path in test.m and mention the inverse solution folder name as well.
2- test.m will execute various funtions to perform permutation test on t-stat, linear regression(three different linear regression).
3- prepdata.m will perform cubic transformation of highly skewed data and transforms it into logData.
4- my_ttest2.m performs test stat performed during permutations test.
5- max_abs_t_2group.m performs MAX_ABAST_DIF_TEST permuation test of difference between two multivariate data.
6- plotperm.m plots p-values of pdf of permuted data
7- tstat_cortex.m plots test stat values on the cortex against all sources. this is peformed before and after liear regression. 
	'FSAve_cortex_8k.mat' and 'mycolormap_brain_basic_conn' are required for this function.