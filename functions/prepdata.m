function [lin_coeff] = prepdata(data_path,method)
% load data tensors
load([data_path,'FSAverage\MEG\',method,'\','J3D_interp.mat']);
data1   = abs(J3D).^(1/6); % cubic transformation of highly skewed data
load([data_path,'FSAverage\EEG\',method,'\','J3D.mat']);
data2   = abs(J3D).^(1/6); % cubic transformation of highly skewed data

% keep good cases
load([data_path,'goodIndEEG.mat']); % good indices EEG
data1   = data1(:,:,[1:45]); % keep 45 cases (45 good cases for EEG)
data2   = data2(:,:,goodind); % keep good cases

% remove frequencies affected by amplification artifacts
data1   = data1(:,[1:80],:); % remove frequencies above 40Hz
data2   = data2(:,[1:80],:); % remove frequencies above 40Hz

%% log transformation
data1   = log(data1);
data2   = log(data2);

%% set f0 amplitude equal to zero and fequency regression
data1f0 = repmat(data1(:,1,:),1,size(data1,2),1);
data2f0 = repmat(data2(:,1,:),1,size(data2,2),1);
data1   = data1 - data1f0;
data2   = data2 - data2f0;
[data2_freq_regressed,B_freq,R2_freq] = linear_regression_freq(data1,data2,method);
lin_coeff.B_freq   = B_freq;
lin_coeff.R2_freq  = R2_freq;

%% space regression
% data1   = data1 + data1f0;
% data2   = data2 + data2f0;
[data2_space_regressed,B_space,R2_space] = linear_regression_space(data1,data2,method);
lin_coeff.B_space  = B_space;
lin_coeff.R2_space = R2_space;
data2_regressed    = data2_space_regressed;

%% save data
data1   = reshape(data1,size(data1,1)*size(data1,2),size(data1,3))';
data2   = reshape(data2,size(data2,1)*size(data2,2),size(data2,3))';
save meg_eeg_4test data1 data2

%% linear regression
data2   = reshape(data2_regressed,size(data2_regressed,1)*size(data2_regressed,2),size(data2_regressed,3))';
save meg_eeg_regressed_4test data1 data2

end