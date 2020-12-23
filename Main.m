%% EEG-MEG-COMPARISONS
%
%
%
%
%
%
%%
clear all
close all
clc

disp("-->> Starting process.");
addpath("app");
addpath("functions");
addpath("templates");

%% prepare data
data_path    = 'E:\CCLAB\EEG-MEG Project - Paper_draft\BTOP paper\EEG-MEG\BC-V_Activation_final\';
% data_path    = 'D:\OneDrive - Neuroinformatics Collaboratory\BTOP paper\EEG-MEG\BC-V_Activation_final\';
% method       = 'eLORETA';
method       = 'sSSBLpp';
% method       = 'LCMV';
lin_coeff    = prepdata(data_path,method);

%% test original data
load meg_eeg_4test
nperm   = 100;
psignif = 0.01; 
[stats_max_abs_t,orig_max_abs_t,orig_t] = max_abs_t_2group(data1,data2,nperm,psignif);
plotperm(stats_max_abs_t,orig_max_abs_t);
tstat_cortex(orig_t,stats_max_abs_t);

%% test regressed data
load meg_eeg_regressed_4test
nperm   = 100;
psignif = 0.01; 
[stats_max_abs_t,orig_max_abs_t,orig_t] = max_abs_t_2group(data1,data2,nperm,psignif);
plotperm(stats_max_abs_t,orig_max_abs_t);
tstat_cortex(orig_t,stats_max_abs_t);












disp("-->> Process finished.");