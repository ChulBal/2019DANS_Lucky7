function [max_prob, x_prob] = simple_bayes_decod(train_set, test_set,avg_window,window_num)
% train_set: linearized skaggs' FR map
% test_set: PETH of test set with bin size 100 ms
% average_window=moving window size

% train_set=  concatenated_smoothMat;
% test_set =test_PETH_cell_SPKCount;
% avg_window=1000; %window of 1000ms moving 100ms
window_size=avg_window*1;

max_prob=nan(window_num,1);
x_prob=nan(window_num,1);
p_xn=nan(size(train_set,1),1);
p_x=1/size(train_set,1); % assume uniform p(x)

for iW=1:window_num
    iW
    % based on RT map, calculate p_nx for each pixel
    for iP=1:size(train_set,1)
        p_xn_cumu=1; %p_xn 1 then multiply all p_xn_iC
        
        for iC=1:size(train_set,2)
            expected_spk=train_set(iP,iC).*window_size./1000;% divide by 1000 to change ms to s
            actual_spk=test_set(iC,iW);
            p_xn_iC=poisspdf(actual_spk,expected_spk);
            p_xn_cumu=p_xn_cumu.*p_xn_iC;
        end
        p_xn(iP)=p_xn_cumu.*p_x;
    end
    % Normalized p_xn
    p_n=1/sum(p_xn);
    p_xn=p_n*p_xn;
    [max_prob(iW), x_prob(iW)]=max(p_xn);
end