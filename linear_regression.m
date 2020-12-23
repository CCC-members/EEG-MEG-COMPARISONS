function [data2_regressed,B,R2] = linear_regression(data1,data2)
%% lirear regression of the median
% apply linear regression to the median data2 to fit the median of data1 obtaining for all subjects 
% linearly transformed data2 (data2_regressed), B (intercept and slope),R2 (goodnes of fit)
nfreq      = size(data1,2);
nsubj      = size(data1,3);
mean_data1 = squeeze(mean(data1,3)); % median MEG
mean_data2 = squeeze(mean(data2,3)); % median EEG
for freq = 1:nfreq
    Y         = squeeze(mean_data1(:,freq)); % MEG
    X2        = squeeze(mean_data2(:,freq)); % EEG
    X         = [ones(length(X2),1) X2];
    B(:,freq) = X\Y;
    R2(freq)  = 1 - sum((Y - B(1,freq)*X(:,1) - B(2,freq)*X(:,2)).^2)/sum((Y - mean(Y)).^2);
    for subj = 1:nsubj
        X2                           = squeeze(data2(:,freq,subj)); % EEG
        X                            = [ones(length(X2),1) X2];
        data2_regressed(:,freq,subj) = X*B(:,freq);
    end
    
end
end