close all
clear all
% fspace  = 0.1:0.5:(99*0.5+0.1); % frequency space
fspace  = 0.1:0.5:(79*0.5+0.1); % frequency space
load('E:\CCLAB\EEG-MEG Project - Paper_draft\BTOP paper\EEG-MEG\goodIndEEG.mat');
% method       = 'eLORETA';
% method       = 'sSSBLpp';
method       = 'LCMV';
%% load data
load(['E:\CCLAB\EEG-MEG Project - Paper_draft\BTOP paper\EEG-MEG\BC-V_Activation_final\FSAverage\MEG\',method,'\J3D_interp.mat']);
%dataMEG = abs(J3D).^(1/6); % cubic transformation of highly skewed data
dataMEG = J3D;
load(['E:\CCLAB\EEG-MEG Project - Paper_draft\BTOP paper\EEG-MEG\BC-V_Activation_final\FSAverage\EEG\',method,'\J3D.mat']);
%dataEEG = abs(J3D).^(1/6); % cubic transformation of highly skewed data
dataEEG = J3D;

%% check data periodicity
figure;
subplot(1,2,1); plot(dataMEG(:));
title('MEG periodicity - before')
% dataMEG(:,:,[63 67]) = []; % remove subject 63 and 67 
dataMEG = dataMEG(:,:,[1:45]); % keep 45 cases (45 good cases for EEG) 
dataMEG = dataMEG(:,[1:80],:); % remove frequencies above 40Hz
subplot(1,2,2); plot(dataMEG(:));
title('MEG periodicity - after')
figure; 
plot(dataEEG(:));
title('EEG periodicity')
% dataEEG(:,:,[63 67]) = []; % remove subject 63 and 67 
dataEEG = dataEEG(:,:,goodind); % keep good cases
dataEEG = dataEEG(:,[1:80],:); % remove frequencies above 40Hz

%% log transformation
% sSSBL
dataMEG = log(dataMEG);
dataMEG = dataMEG - repmat(dataMEG(:,1,:),1,80,1); %subtracting lowest frequency from data
dataEEG = log(dataEEG);
dataEEG = dataEEG - repmat(dataEEG(:,1,:),1,80,1); %subtracting lowest frequency from data

%% plot each source spectra (median and mean for 70 subjects)
[medianMEG,median2MEG,meanMEG,mean2MEG,medianEEG,median2EEG,meanEEG,mean2EEG] = PSD_MEEG(dataMEG,dataEEG,fspace,method);

%% plot source spectra histogram (data for all sources and subjects' median)
% sSSBL
[PDF_MEG,CDF_MEG,figdata] = histogram3D(medianMEG,fspace,'Median','MEG',method);
[PDF_EEG,CDF_EEG,figdata] = histogram3D(medianEEG,fspace,'Median','EEG',method);

%% plot source spectra histogram (data for all sources and subjects)
% sSSBL
dataMEG2D = squeeze(reshape(permute(dataMEG,[1,3,2]),size(dataMEG,1)*size(dataMEG,3),size(dataMEG,2)));
dataEEG2D = squeeze(reshape(permute(dataEEG,[1,3,2]),size(dataEEG,1)*size(dataEEG,3),size(dataEEG,2)));
[PDF_MEG,CDF_MEG,figdata] = histogram3D(dataMEG2D,fspace,'Full','MEG',method);
[PDF_EEG,CDF_EEG,figdata] = histogram3D(dataEEG2D,fspace,'Full','EEG',method);

%% statistical comparison
% sSSBL
[B,R2] = statMEG_EEG(medianMEG,medianEEG,fspace,method);

%% auxiliarly function for spectra
function [medianMEG,median2MEG,meanMEG,mean2MEG,medianEEG,median2EEG,meanEEG,mean2EEG] = PSD_MEEG(dataMEG,dataEEG,fspace,method)
medianMEG  = squeeze(median(dataMEG,3));
median2MEG = squeeze(median(medianMEG,1));
meanMEG    = squeeze(mean(dataMEG,3));
mean2MEG   = squeeze(mean(meanMEG,1));
medianEEG  = squeeze(median(dataEEG,3));
median2EEG = squeeze(median(medianEEG,1));
meanEEG    = squeeze(mean(dataEEG,3));
mean2EEG   = squeeze(mean(meanEEG,1));
figure;
subplot(4,2,1);
plot(fspace,meanEEG')
xlabel('freq(Hz)'); ylabel('source PSD');
title(['Mean EEG for ',method])
subplot(4,2,2);
plot(fspace,meanMEG')
xlabel('freq(Hz)'); ylabel('source PSD');
title(['Mean MEG for ',method])
subplot(4,2,3);
plot(fspace,mean2EEG)
xlabel('freq(Hz)'); ylabel('source PSD');
title(['Mean-Mean EEG for ',method])
subplot(4,2,4);
plot(fspace,mean2MEG)
xlabel('freq(Hz)'); ylabel('source PSD');
title(['Mean-Mean MEG for ',method])
subplot(4,2,5);
plot(fspace,medianEEG')
xlabel('freq(Hz)'); ylabel('source PSD');
title(['Median EEG for ',method])
subplot(4,2,6);
plot(fspace,medianMEG')
xlabel('freq(Hz)'); ylabel('source PSD');
title(['Median MEG for ',method])
subplot(4,2,7);
plot(fspace,median2EEG')
xlabel('freq(Hz)'); ylabel('source PSD');
title(['Median-Median EEG for ',method])
subplot(4,2,8);
plot(fspace,median2MEG')
xlabel('freq(Hz)'); ylabel('source PSD');
title(['Median-Median MEG for ',method])
end

%% auxiliarly function for histograms
function [PDFdata,CDFdata,figdata] = histogram3D(data,fspace,stat,modality,method)
data_min  = min(data(:));
data_max  = max(data(:));
d_data    = (data_max - data_min)/50;
grid_data = (data_min + d_data):d_data:data_max;
CDFdata   = zeros(length(grid_data),size(data,2));
PDFdata   = zeros(length(grid_data),size(data,2));
ndata     = size(data,1);
myxticks  = cell(1,length(fspace));
for i = 1:length(fspace)
    myxticks{i} = num2str(fspace(i));
end
myyticks  = cell(1,length(grid_data));
for i = 1:length(grid_data)
    myyticks{i} = num2str(grid_data(i));
end
for ii = 1:size(PDFdata,2)
    data_tmp = data(:,ii);
    CDFdata0 = 0;
    for i =1:size(PDFdata,1)
        count_data    = length(find(data_tmp <= grid_data(i)));
        CDFdata(i,ii) = count_data/ndata;
        PDFdata(i,ii) = CDFdata(i,ii) - CDFdata0;
        CDFdata0      = CDFdata(i,ii);
    end
end
figdata = figure;
subplot(1,2,1)
bar3(grid_data',PDFdata)
xlabel(['freq(',num2str(fspace(1)),'Hz','-',num2str(fspace(end)),'Hz',')']);
ylabel('data values');
zlabel('PDF');
title(['PDF of ',stat,' ',modality,' for ',method])
subplot(1,2,2)
bar3(grid_data',CDFdata)
xlabel(['freq(',num2str(fspace(1)),'Hz','-',num2str(fspace(end)),'Hz',')']);
ylabel('data values');
zlabel('CDF');
title(['CDF of ',stat,' ',modality,' for ',method])
end

%% auxiliarly function statistical comparison
function [B,R2] = statMEG_EEG(data1,data2,fspace,method)
figure
scatter(data1(:),data2(:));
xlabel('logMEG');
ylabel('logEEG');
title([method ' MEG-EEG linearity']);
figure
hist3([data1(:) data2(:)],'Nbins',[50 50],'CDataMode','auto','FaceColor','interp');
xlabel('logMEG');
ylabel('logEEG');
title([method ' MEG-EEG histogram']);
figure
for i = 1:length(fspace)
    scatter3(repmat(fspace(i),length(data1),1),data1(:,i),data2(:,i));
    hold on
    Y  = data2(:,i); % EEG
    X  = [ones(length(data1(:,i)),1) data1(:,i)]; % MEG
    B  = X\Y;
    R2(i) = 1 - sum((Y - B(1)*X(:,1) - B(2)*X(:,2)).^2)/sum((Y - mean(Y)).^2);
end
title([method ' logMEG-logEEG-frequency dispersion']);
xlabel('freq(Hz)');
ylabel('logMEG');
zlabel('logEEG');
figure
plot(fspace',R2)
xlabel('freq(Hz)');
ylabel('R2 stat');
title([method ' R2 stat']);
end