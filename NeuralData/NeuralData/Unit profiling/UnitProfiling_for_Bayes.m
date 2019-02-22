%% Read cluster file , perform profile, perform bayes 1-step decoding
clear; clc; close all;

%define 
group_id=input('Which Group, A or B?? ::','s');

data_path = 'C:\Users\spiri\Desktop\DANS\day4\LIA\NeuralData\project';
program_path='C:\Users\spiri\Desktop\DANS\day4\LIA\NeuralData\Unit profiling';
result_path = 'C:\Users\spiri\Desktop\DANS\day4\LIA\NeuralData\Unit profiling\results';
cd(program_path);

startTimestamp = 2141191116079;
endTimestamp = 2142313305048;

posFile = [data_path '\' 'Pos.p.ascii'];

%load position data
posTable = readtable(posFile, 'FileType', 'text');
posTable.Properties.VariableNames = {'t', 'x', 'y', 'a'};
posTable(posTable.t < startTimestamp | posTable.t > endTimestamp, :) = []; %remain open field data
raw_Timestamp=[posTable.t posTable.x posTable.y];
orig_posTable=posTable;
posTable((posTable.x == 0 & posTable.y == 0), :) = []; %remove 0 data
posTable.t = posTable.t/10^6; %convert time unit from us to s

%% Perform cell profiling for Group A
folder_dir=dir([data_path '\' group_id]);
A_cell = struct2cell(folder_dir);

target_cell=[A_cell(:,[3:end-1])];
cellNum=size(target_cell,2);

% define save matrix
cell_profile_mat=nan(cellNum,6);
FRMAP_array={};% smoothed FR map for training

%% Define timestamps into 10 temporal bins for Bayesian decoding set
bin_size=1000;test_fold=5;
temporal_interval=linspace(startTimestamp,endTimestamp,test_fold+1);

% Define bin for PETH
bin_edge=[temporal_interval(test_fold):1000*bin_size:endTimestamp];binNum=size(bin_edge,2)-1;
test_PETH_cell_SPKCount=nan(cellNum,binNum);

% Define train set
train_posTable=orig_posTable;
train_posTable(train_posTable.t < temporal_interval(1) | train_posTable.t > temporal_interval(test_fold)-1, :) = []; %remain open field data
train_posTable((train_posTable.x == 0 & train_posTable.y == 0), :) = []; %remove 0 data
train_posTable.t = train_posTable.t/10^6; %convert time unit from us to s

% Define test set
test_posTable=orig_posTable;
test_posTable=test_posTable(test_posTable.t > temporal_interval(test_fold) & test_posTable.t < endTimestamp, :); %remain open field data
test_posTable((test_posTable.x == 0 & test_posTable.y == 0), :) = []; %remove 0 data
test_posTable.t = test_posTable.t/10^6; %convert time unit from us to s

for iC=1:cellNum
    
    cellFile=target_cell{1,iC}
    group_path=target_cell{2,iC};
    spkFile = [group_path '\' cellFile];
    
    switch group_id
        case 'A'
            group_index=1;
        case 'B'
            group_index=-1;
    end
    
    
    % load spike data
    
    [t_spk, x_spk, y_spk] = createParsedSpike_Bayes(train_posTable, spkFile,temporal_interval(1),temporal_interval(test_fold)-1);
    train_spkMat = [x_spk, y_spk, t_spk];
    
    [t_spk, x_spk, y_spk] = createParsedSpike_Bayes(test_posTable, spkFile,temporal_interval(test_fold),endTimestamp);
    test_spkMat = [x_spk, y_spk, t_spk];
    
    
    %% make ratemap
    train_spikeMat = [train_spkMat(:,3) train_spkMat(:,1:2)];
    train_positionMat = [train_posTable.t train_posTable.x train_posTable.y];
    
    imROW = 48;
    imCOL = 72;
    thisSCALE = 10;
    samplingRate = 30;
    
    [train_occMat_bin, train_spkMat_bin, train_rawMat, train_smoothMat] = abmFiringRateMap(train_spikeMat, train_positionMat, imROW, imCOL, thisSCALE, samplingRate);
    
    % linearize & save smoothed FR map for Decoding
    linear_occ=reshape(train_occMat_bin,[numel(train_occMat_bin) 1]);
    linear_smoothMat=reshape(train_smoothMat,[numel(train_smoothMat) 1]);
    linear_smoothMat(isnan(linear_occ))=[];
    
    if numel(linear_smoothMat) ~= 1175
        disp('Position Linearization Error');
    end
    concatenated_smoothMat(:,iC)=linear_smoothMat;
    
    
    %% PETH using test set
    [N,edges] = histcounts(test_spkMat(:,3).*1000000,bin_edge);
    test_PETH_cell_SPKCount(iC,:)=N;
    
end

save(['dans_team7_Bayes_' group_id '.mat']);
window_num=150;
[max_prob x_prob] = simple_bayes_decod(concatenated_smoothMat, test_PETH_cell_SPKCount,1000,window_num);

index_link=find(~isnan(linear_occ));
x_pred=index_link(x_prob(1:window_num));
[y_pred x_pred]=ind2sub(size(train_smoothMat),x_pred);

% Calculate averaged actual location from 1000ms interval
x_actual=nan(150,2);
for iW=1:150
    this_interval_posTable=test_posTable(test_posTable.t > temporal_interval(test_fold)./10^6+(iW-1) & test_posTable.t < temporal_interval(test_fold)./10^6+iW, :);
    x_actual(iW,1)= mean(this_interval_posTable.x)./10;
    x_actual(iW,2)= mean(this_interval_posTable.y)./10;
end

if ~isfolder(result_path)
    mkdir(result_path);
end

% plot and save
for iF=1:window_num/10
    figure;
    plot_file_name=[result_path '\Group_' group_id '_Bayes_Decoding_Interval_' num2str(iF) '.bmp'];
    start_index=10*(iF-1)+1;
    end_index=10*iF;
    text_string=cellstr(num2str([1:10]'));
    
    plot(x_actual([start_index:end_index],1),x_actual([start_index:end_index],2),'-ok');hold on;
    text(x_actual([start_index:end_index],1),x_actual([start_index:end_index],2),text_string,'Color','black'); hold on;
    plot(x_pred([start_index:end_index]),y_pred([start_index:end_index]),'-xb');
    text(x_pred([start_index:end_index]),y_pred([start_index:end_index]),text_string,'Color','red'); hold on;
    set(gca,'XLim',[0 75],'YLim',[0 50]);legend('Actual','Prediction');
    xlabel('Position_X');ylabel('Position_Y');title(['Interval: ' num2str(start_index) '~' num2str(end_index)]);
    saveas(gcf,plot_file_name,'bmp');close(gcf);
end

% calculate prediction error
error_dist=sqrt((x_pred-x_actual(:,1)).^2+(y_pred-x_actual(:,2)).^2);
save(['dans_team7_Bayes_' group_id '.mat']);

