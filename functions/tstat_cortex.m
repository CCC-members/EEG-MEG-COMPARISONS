function tstat_cortex(orig_t,stats_max_abs_t)
load('FSAve_cortex_8k.mat');
load('mycolormap_brain_basic_conn');
smoothValue          = 0.66;
SurfSmoothIterations = 10;
Vertices             = tess_smooth(Vertices, smoothValue, SurfSmoothIterations, VertConn, 1);
th                   = stats_max_abs_t.th;
orig_t               = reshape(orig_t,8002,80);
fspace               = 0.1:0.5:(79*0.5+0.1); % frequency space 99 for full frequencies
frequencies          = [0.1 4; 4 7; 7 14; 14 31; 32 50];
figure
for i = 1:length(frequencies)
    [~,nf1]    = min(abs(fspace - frequencies(i,1)));
    [~,nf2]    = min(abs(fspace - frequencies(i,2)));
    f1         = fspace(nf1);
    f2         = fspace(nf2);
    sources_iv = abs(orig_t(:,nf1:nf2));
    sources_iv(sources_iv < th) = 0;
    sources_iv = sum(sources_iv,2);
    sources_iv(sources_iv > 0) = 1;
    subplot(1,length(frequencies),i);
    patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+...
    log(1+sources_iv),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
    set(gca,'xcolor','w','ycolor','w','zcolor','w');
    az = 90; el = 270;
    view(az,el);
    colormap(gca,cmap);
    title(['cortex-tstat ',num2str(f1),'Hz-',num2str(f2),'Hz']);
end
end