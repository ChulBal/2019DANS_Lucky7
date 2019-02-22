%% Decoding

% aggregated spike count is saveed in PETH_cell_SPKCount;
% Raw position data is saved in raw_Timestamp;
% Cell group is stored in cell_profile_mat(:,6)

%%
idir = pwd;
spmpath = 'C:\toolbox\spm12';
addpath(spmpath)
libsvmpath = 'C:\Users\spiri\Desktop\DANS\libsvm-3.23\libsvm-3.23\matlab';
addpath(libsvmpath)

myfontsize = 8;
mylinewidth = 1;
mymarkersize = 5;
%%
idir = pwd;
addpath(genpath([idir '/code']))
spmpath = 'C:\toolbox\spm12';
addpath(spmpath)
libsvmpath = 'C:\Users\spiri\Desktop\DANS\libsvm-3.23\libsvm-3.23\matlab';
addpath(libsvmpath)


%% Exercise #6 - one-run-leave-out cross-validation, Continuous variable (DV)
% iSL = Searchlight_r3(i(1),i(2),i(3),sizeMap);

% h = figure;
% set(h,'position',[0 0 500 1400])
% for iRun = 1:8
%     subplot(8,3,3*(iRun-1)+1)
%     hold on
%     plot(find(Run==iRun & Chc==1)-25*(iRun-1),iDV(Run==iRun & Chc==1)...
%         ,'marker','o','markerfacecolor','r','markersize',mymarkersize,'linewidth',mylinewidth,'color','k','linestyle','none')
%     plot(find(Run==iRun & Chc==-1)-25*(iRun-1),iDV(Run==iRun & Chc==-1)...
%         ,'marker','o','markerfacecolor','b','markersize',mymarkersize,'linewidth',mylinewidth,'color','k','linestyle','none')
%     xlim([1 25])
%     set(gca,'fontsize',myfontsize,'xtick',5:5:25,'ytick',[0 0.5 1])
%     ylabel('DV')
%     grid on
% end
% xlabel('trial')
% pause
% %
% nv = size(v,1);
% colors = lines(nv); 
% for iRun = 1:8
%     subplot(8,3,3*(iRun-1)+2)
%     hold on
%     set(gca,'xtick',5:5:25,'ytick',[-2 0 2],'fontsize',myfontsize)
%     ylabel('BOLD')
%     xlim([1 25])
%     ylim([-3.5 3.5])
%     for iv = 1:nv
%         x = v(iv,1);
%         y = v(iv,2);
%         z = v(iv,3);
%         ibold = squeeze(bold{iRun}(x,y,z,:));
%         plot(ibold,'linewidth',mylinewidth,'color',colors(iv,:))
%     end
%     grid on
% end
% xlabel('trials')
%
dDV = NaN(size(iDV));
icorr = NaN(8,1);
for iRun = 1:8
    subplot(8,3,3*(iRun-1)+3)
    hold on
    testInd = Run==iRun;
    trainInd = Run~=iRun;
    testDV = iDV(testInd);
    testBOL = BOL(testInd,:);
    trainDV = iDV(trainInd);
    trainBOL = BOL(trainInd,:);
    %
    model = svmtrain(trainDV,trainBOL,'-s 3 -t 0 -q');
    idDV = svmpredict(testDV,testBOL,model,'-q');
    %
    dDV(testInd) = idDV;
    plot(find(Run==iRun & Chc==1)-25*(iRun-1),dDV(Run==iRun & Chc==1),...
        'marker','o','markerfacecolor','r','markersize',mymarkersize,'linewidth',mylinewidth,'color','k','linestyle','none')
    plot(find(Run==iRun & Chc==-1)-25*(iRun-1),dDV(Run==iRun & Chc==-1),...
        'marker','o','markerfacecolor','b','markersize',mymarkersize,'linewidth',mylinewidth,'color','k','linestyle','none')    
    icorr(iRun) = corr(idDV,testDV);
    title(['r=' num2str(icorr(iRun))],'fontsize',myfontsize);
    set(gca,'fontsize',myfontsize,'xtick',5:5:25,'ytick',[0 0.5 1])
    ylabel('Decoded DV')
    grid on
    pause
end
xlabel('trials')
[r,p] = corr(dDV,DV(:));
disp(['Correlation=' num2str(r) ', p-value=' num2str(p)]);