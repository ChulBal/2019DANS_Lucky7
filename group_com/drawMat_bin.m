function drawMat_bin(targetMat)

%draw raw rate map
figure

%for alpha
thisAlphaZ = targetMat;
thisAlphaZ(isnan(targetMat)) = 0;
thisAlphaZ(~isnan(targetMat)) = 1;

imagesc((targetMat));
hold on;

alpha(thisAlphaZ);
colormap(jet);

set(gca, 'YDir', 'rev', 'XLim', [15 65], 'YLim', [0 50]);
daspect([1 1 1]);
colorbar;