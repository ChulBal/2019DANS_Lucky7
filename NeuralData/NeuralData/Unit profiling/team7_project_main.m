% Team 7 Single Unit data analysis code
clear all;close all;clc;

data_path = 'C:\Users\spiri\Desktop\DANS\day4\LIA\NeuralData\project';
program_path='C:\Users\spiri\Desktop\DANS\day4\LIA\NeuralData\Unit profiling';
result_path = 'C:\Users\spiri\Desktop\DANS\day4\LIA\NeuralData\Unit profiling\results';
cd(program_path);

% Script for cell profiling and PETH data import for python
UnitProfiling;

% Script for Group A decoding (input A when prompted)
UnitProfiling_for_Bayes;

% Script for Group B decoding (input B when prompted)
UnitProfiling_for_Bayes;

% Script for Group Comparison between A and B
UnitComparison_for_Bayes;