%% Decoding Bayesian

% aggregated spike count is saveed in PETH_cell_SPKCount;
% Raw position data is saved in raw_Timestamp;
% Cell group is stored in cell_profile_mat(:,6)

clear; clc; close all;

data_path = 'C:\Users\spiri\Desktop\DANS\day4\LIA\NeuralData\project';
program_path='C:\Users\spiri\Desktop\DANS\day4\LIA\NeuralData\Unit profiling';
result_path = 'C:\Users\spiri\Desktop\DANS\day4\LIA\NeuralData\Unit profiling\results';
cd(program_path);
load(dans_team7.mat')


