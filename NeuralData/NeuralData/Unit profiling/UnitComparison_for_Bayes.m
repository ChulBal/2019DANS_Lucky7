% Statistical comparison of prediction error between A and B
clear all; close all;

data_path = 'C:\Users\spiri\Desktop\DANS\day4\LIA\NeuralData\project';
program_path='C:\Users\spiri\Desktop\DANS\day4\LIA\NeuralData\Unit profiling';
result_path = 'C:\Users\spiri\Desktop\DANS\day4\LIA\NeuralData\Unit profiling\results';
cd(program_path);

group_strings=['A', 'B'];

load(['dans_team7_Bayes_' group_strings(1) '.mat'],'error_dist');
group_error_dist=error_dist;

load(['dans_team7_Bayes_' group_strings(2) '.mat'],'error_dist');
group_error_dist=[group_error_dist error_dist];

[P,H] = ranksum(group_error_dist(:,1),group_error_dist(:,2));

% plot histograms
error_dist_edges=[0:1:ceil(max(group_error_dist,[],'all'))];
figure;
subplot(2,1,1)
histogram(group_error_dist(:,1),error_dist_edges,'Normalization','pdf');
xlabel('Euclidean Prediction Error Distance');ylabel('Proportion');title('Group A');
subplot(2,1,2)
histogram(group_error_dist(:,2),error_dist_edges,'Normalization','pdf');
xlabel('Euclidean Prediction Error Distance');ylabel('Proportion');title('Group B');
plot_file_name=[result_path '\Bayes_Decoding_Error_Distance_PDF.bmp'];
saveas(gcf,plot_file_name,'bmp');close(gcf);


figure;
subplot(2,1,1)
histogram(group_error_dist(:,1),error_dist_edges,'Normalization','cdf');
xlabel('Euclidean Prediction Error Distance');ylabel('CDF');title('Group A');
subplot(2,1,2)
histogram(group_error_dist(:,2),error_dist_edges,'Normalization','cdf');
xlabel('Euclidean Prediction Error Distance');ylabel('CDF');title('Group B');
plot_file_name=[result_path '\Bayes_Decoding_Error_Distance_CDF.bmp'];
saveas(gcf,plot_file_name,'bmp');close(gcf);

[P,H] = ranksum(group_error_dist(:,1),group_error_dist(:,2));
