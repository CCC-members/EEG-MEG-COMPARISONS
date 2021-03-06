function ica_cortex(data)
[A, icasig, W] = fastica(data','approach' ,'symm','numOfIC',5,'g','gauss','a2',1,'mu',1,'stabilization','on');
load('FSAve_cortex_8k.mat');
load('mycolormap_brain_basic_conn');
smoothValue          = 0.66;
SurfSmoothIterations = 10;
Vertices             = tess_smooth(Vertices, smoothValue, SurfSmoothIterations, VertConn, 1);
icasig               = icasig';
fspace               = 0.1:0.5:(79*0.5+0.1); % frequency space 99 for full frequencies
figure
for i = 1:size(icasig,2)
    sources_iv = icasig(:,i);
    sources_iv(sources_iv > 0) = 1;
    subplot(1,size(icasig,2),i);
    patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',...
    exp(sources_iv),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
    set(gca,'xcolor','w','ycolor','w','zcolor','w');
    az = 90; el = 90;
    view(az,el);
    colormap(hot);
%     colormap(gca,cmap);
    title(['spatial-IC',num2str(1)]);
end
figure
plot(fspace,A);
title('spectral-ICs');
legend('IC1','IC2','IC3','IC4','IC5');
end