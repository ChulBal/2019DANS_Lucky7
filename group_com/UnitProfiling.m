clear; clc; close all;

home = 'D:\DANS\DANS_Elec\NeuralData\project';
spkFile = [home '\' 'B', '\' 'r463_m8_tt15_all.6'];
posFile = [home '\' 'Pos.p.ascii'];

startTimestamp = 2141191116079;
endTimestamp = 2142313305048;

%% Load data
%load position data
posTable = readtable(posFile, 'FileType', 'text');
posTable.Properties.VariableNames = {'t', 'x', 'y', 'a'};
posTable((posTable.x == 0 & posTable.y == 0), :) = []; %remove 0 data
posTable(posTable.t < startTimestamp | posTable.t > endTimestamp, :) = []; %remain open field data
posTable.t = posTable.t/10^6; %convert time unit from us to s


%load spike data
[t_spk, x_spk, y_spk] = createParsedSpike(posTable, spkFile);
spkMat = [x_spk, y_spk, t_spk];


%% Draw occupancy & spike map

%draw occ map
figure;
plot(posTable.x, posTable.y, '.', 'MarkerEdgeColor', [0.7 0.7 0.7]);
hold on;
daspect([1 1 1]); %to maintain x,y axis scale
set(gca, 'YDir', 'rev', 'XLim', [150 650], 'YLim', [0 500]);

%draw spike map
plot(spkMat(:,1), spkMat(:,2), '.', 'MarkerEdgeColor', [1 0 0]);


%% make ratemap

spikeMat = [spkMat(:,3) spkMat(:,1:2)];
positionMat = [posTable.t posTable.x posTable.y];

imROW = 48;
imCOL = 72;
thisSCALE = 10;
samplingRate = 30;

[occMat_bin, spkMat_bin, rawMat, smoothMat] = abmFiringRateMap(spikeMat, positionMat, imROW, imCOL, thisSCALE, samplingRate);


%% draw maps with binning (occupancy, spike, firing rate map, smooth rate map)

%draw occupancy map
targetMat = occMat_bin;
drawMat_bin(targetMat);

%draw spike map
targetMat = spkMat_bin;
drawMat_bin(targetMat);

%draw raw firing rate map
targetMat = rawMat;
drawMat_bin(targetMat);

%draw smooth firing rate map
targetMat = smoothMat;
drawMat_bin(targetMat);


%% calculate measurements (average firing rate, spatial information score ...)

[avgFr, information] = informationContent(occMat_bin, rawMat);
fprintf('average firing rate (Hz): %2.2f \n', avgFr);
fprintf('spatial information (Bits/Spike): %2.2f \n', information);

%peak firing rate
peakFr = nanmax(nanmax(smoothMat));
fprintf('peak firing rate: %2.2f \n', peakFr);

%coherence
orgMat = rawMat;
coherence = calcCoherenceMap(orgMat);
fprintf('coherence: %2.2f \n', coherence);

