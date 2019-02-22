clear; clc; close all;

data_path = 'D:\DANS\DANS_Elec\NeuralData\project';
program_path='D:\DANS\DANS_Elec\UnitProfiling_1';
result_path = 'D:\DANS\DANS_Elec\dans_team7.mat';
cd(program_path);

startTimestamp = 2141191116079;
endTimestamp = 2142313305048;

posFile = [data_path '\' 'Pos.p.ascii'];


%load position data
posTable = readtable(posFile, 'FileType', 'text');
posTable.Properties.VariableNames = {'t', 'x', 'y', 'a'};
posTable((posTable.x == 0 & posTable.y == 0), :) = []; %remove 0 data
posTable(posTable.t < startTimestamp | posTable.t > endTimestamp, :) = []; %remain open field data
posTable.t = posTable.t/10^6; %convert time unit from us to s


%% Perform cell profiling for Group A
folder_dir_A=dir([data_path '\A']);
A_cell = struct2cell(folder_dir_A);

folder_dir_B=dir([data_path '\B']);
B_cell = struct2cell(folder_dir_B);

target_cell=[A_cell(:,[3:end-1]) B_cell(:,[3:end-1])];
cellNum=size(target_cell,2);

% define save matrix
cell_profile_mat=nan(cellNum,6);

for iC=1:cellNum
    
    cellFile=target_cell{1,iC}
    group_path=target_cell{2,iC};
    spkFile = [group_path '\' cellFile];
    group_index=[ones(1,21) ones(1,35).*-1];
    
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
    saveas(gcf,[group_path '\results\Spike_Map_' cellFile '.bmp'],'bmp');close(gcf);
    
    %% make ratemap
    spikeMat = [spkMat(:,3) spkMat(:,1:2)];
    positionMat = [posTable.t posTable.x posTable.y];
    
    imROW = 48;
    imCOL = 72;
    thisSCALE = 10;
    samplingRate = 30;
    
    [occMat_bin, spkMat_bin, rawMat, smoothMat] = abmFiringRateMap(spikeMat, positionMat, imROW, imCOL, thisSCALE, samplingRate);
    
    
    %% draw maps with binning (occupancy, spike, firing rate map, smooth rate map)
    
    % %draw occupancy map
    % targetMat = occMat_bin;
    % drawMat_bin(targetMat);
    %
    % %draw spike map
    % targetMat = spkMat_bin;
    % drawMat_bin(targetMat);
    
    %draw raw firing rate map
    targetMat = rawMat;
    drawMat_bin(targetMat);
    saveas(gcf,[group_path '\results\RawFR_Map_' cellFile '.bmp'],'bmp');close(gcf);
    
    %draw smooth firing rate map
    targetMat = smoothMat;
    drawMat_bin(targetMat);
    saveas(gcf,[group_path '\results\Smooth_Map_' cellFile '.bmp'],'bmp');close(gcf);
    
    
    %% calculate measurements (average firing rate, spatial information score ...)
    
    [avgFr, information] = informationContent(occMat_bin, rawMat);
    % fprintf('average firing rate (Hz): %2.2f \n', avgFr);
    % fprintf('spatial information (Bits/Spike): %2.2f \n', information);
    
    %peak firing rate
    peakFr = nanmax(nanmax(smoothMat));
    % fprintf('peak firing rate: %2.2f \n', peakFr);
    
    %coherence
    orgMat = rawMat;
    coherence = calcCoherenceMap(orgMat);
    % fprintf('coherence: %2.2f \n', coherence);
    
    cell_profile_mat(iC,1)=avgFr;
    cell_profile_mat(iC,2)=information;
    cell_profile_mat(iC,3)=peakFr;
    cell_profile_mat(iC,4)=coherence;
    % cell_profile_mat(iC,6)=avgFr;
    cell_profile_mat(iC,6)=group_index(iC);% 1 = A, -1 = B
end

save('dans_team7.mat');