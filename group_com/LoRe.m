%% Logistic Regression

%%% Loading data

data_path = 'D:\DANS\DANS_Elec\NeuralData\project';
program_path='D:\DANS\DANS_Elec\NeuralData\Unit Profiling';
result_file = 'D:\DANS\DANS_Elec\NeuralData\Unit Profiling\dans_team7.mat';
cd(program_path);

load(result_file,'cell_profile_mat','target_cell');

AverFr = cell_profile_mat(:,1);
Info = cell_profile_mat(:,2);
%Peak = cell_profile_mat(:,3);
%Coherence = cell_profile_mat(:,4);
Group = cell_profile_mat(:,6);
%Group(Group<1) = 5
%Features = cell_profile_mat(:,1:4);

x = [AverFr Info Group];
%y = [Group];
%Peak = [Peak Group];
%Coherence = [Coherence Group];

%%
 ytrain=x(:,end); % Target variable
 xtrain=zscore(x(:,1:end-1));% Normalized Predictors
 
 p=length(x);


 xtrain=[ones(length(xtrain),1) xtrain]; % one is added for calculation of biases.
 xtest=xtrain;
 ytest=ytrain;
 
 %% compute cost and gradient
  iter=1000; % No. of iterations for weight updation
  
  theta=zeros(size(xtrain,2),1); % Initial weights
  
  alpha=0.1 % Learning parameter
  
  [J grad h th]=cost(theta,xtrain,ytrain,alpha,iter) % Cost funtion
 
   ypred=xtest*th; %target prediction
 
 
   %% probability calculation
 [hp]=sigmoid(ypred); % Hypothesis Function
 ypred(hp>=0.5)=1;
 ypred(hp<0.5)=-1;
 
%% Decision Boundary

syms x1 x2
fnn=th(2)*x1+th(1)*x2

 figure
 hold on
 scatter(xtest(ytest==1,2),xtest(ytest==1,3),'b+','linewidth',5.0)
 scatter(xtest(ytest==-1,2),xtest(ytest==-1,3),'rs','filled','linewidth',3.0)
 h1=ezplot(fnn)
 set(h1,'color','k','linewidth',3)
 title('Logistic Regression Classification')
 xlabel('Average Fr'); ylabel('Information Score');
 legend('A Group','B Group','Decision boundary')
 xlim([-1.4 1.5])
 ylim([-2 3])
 