%% Unit Comparison (2nd step)

%%% Loading data

data_path = 'D:\DANS\DANS_Elec\NeuralData\project';
program_path='D:\DANS\DANS_Elec\NeuralData\Unit Profiling';
result_file = 'D:\DANS\DANS_Elec\NeuralData\Unit Profiling\dans_team7.mat';
cd(program_path);

load(result_file,'cell_profile_mat','target_cell');


%% Graphs and T_test
%%% AverFr
Aver_A = cell_profile_mat(1:21,1);
Aver_B = cell_profile_mat(22:56,1);

subplot(2, 2, 1)
Av_G = scatter(1:length(Aver_A), Aver_A, 'r', 'filled')
hold on;
Av_G = scatter(1:length(Aver_B), Aver_B, 'b', 'filled')
title('AvgFr (p-value < .024*)'); xlabel('Cells'); ylabel('AvgFr');
legend('Group A', 'Group B')

[h p] = ttest2(Aver_A, Aver_B) 
Av_ttest = [h p]


%%% Information 
hold 
Info_A = cell_profile_mat(1:21,2);
Info_B = cell_profile_mat(22:56,2);
subplot(2, 2, 2)
Info_G = scatter(1:length(Info_A), Info_A, 'r', 'filled')
hold on;
Info_G = scatter(1:length(Info_B), Info_B, 'b','filled')
title('Information Score (p-value < .001***)'); xlabel('Cells'); ylabel('Info_score');
legend('Group A', 'Group B')

[h p] = ttest2(Info_A, Info_B) 
Info_ttest = [h p]



%%% Peak 

Peak_A = cell_profile_mat(1:21,3);
Peak_B = cell_profile_mat(22:56,3);
subplot(2, 2, 3)
Peak_G = scatter(1:length(Peak_A), Peak_A, 'r', 'filled')
hold on;
Peak_G = scatter(1:length(Peak_B), Peak_B, 'b', 'filled')
title('AvgPeak (p-value > .38)'); xlabel('Cells'); ylabel('Peak');
legend('Group A', 'Group B')

[h p] = ttest2(Peak_A, Peak_B) 
Peak_ttest = [h p]


%%% Coherence

Coherence_A = cell_profile_mat(1:21,4);
Coherence_B = cell_profile_mat(22:56,4);
subplot(2, 2, 4)
Co_G = scatter(1:length(Coherence_A), Coherence_A, 'r', 'filled')
hold on;
Co_G = scatter(1:length(Coherence_B), Coherence_B, 'b', 'filled')
title('Coherence (p-value < .001***)'); xlabel('Cells'); ylabel('Coherence');
legend('Group A', 'Group B')

[h p] = ttest2(Coherence_A, Coherence_B) 
Co_ttest = [h p]

%% T-test results

ttest_result = [Av_ttest, Info_ttest, Peak_ttest, Co_ttest]


