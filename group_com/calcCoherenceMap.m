function coherenceValue = calcCoherenceMap(orgMat)

% orgMat = spkMat ./ occMat .* 30;

[row, col] = size(orgMat);

if row == 1 && col == 1
    fprintf('WARNING : this map is not suitable for coherence');
    coherenceValue = nan;
elseif col == 1 %column vector
%     rowN = size(orgMat, 1);
%     reshapedRawMat = orgMat(2:end-1);
%     for rIter = 2:rowN-1
%         pMeanSpk = nansum([spkMat(rIter-1), spkMat(rIter+1)], 2);
%         pMeanOcc = nansum([occMat(rIter-1), spkMat(rIter+1)], 2);
%         if pMeanOcc == 0
%             reshapedMeanMat(rIter-1, 1) = nan;
%         else
%             reshapedMeanMat(rIter-1, 1) = pMeanSpk/pMeanOcc  .* 30;
%         end
%     end
elseif row == 1 %row vector
%     colN = size(orgMat, 2);
%     reshapedRawMat = orgMat(2:end-1);
%     for rIter = 2:colN-1
%         pMeanSpk = nansum([spkMat(rIter-1), spkMat(rIter+1)]);
%         pMeanOcc = nansum([occMat(rIter-1), spkMat(rIter+1)]);
%         if pMeanOcc == 0
%             reshapedMeanMat(rIter-1, 1) = nan;
%         else
%             reshapedMeanMat(rIter-1, 1) = pMeanSpk/pMeanOcc  .* 30;
%         end
%     end 
else
    

    revicedRawMat = orgMat(2:row-1,2:col-1); % remove edge. because edge have no 8 neiborhood.
    meanMat = zeros(row-2,col-2);

%     occMat(isnan(occMat)) = 0;


    %to make 8-mean map
    for rIter = 2:row-1
        for cIter = 2:col-1
            %calculate total spk of neibor 8 pixels.
%             pMeanSpk = nansum([spkMat(rIter-1,cIter-1), spkMat(rIter,cIter-1), spkMat(rIter+1, cIter-1), ...
%                 spkMat(rIter-1,cIter), spkMat(rIter+1, cIter), ...
%                 spkMat(rIter-1,cIter+1), spkMat(rIter,cIter+1), spkMat(rIter+1,cIter+1)]);
%             pMeanOcc = nansum([occMat(rIter-1,cIter-1), occMat(rIter,cIter-1), occMat(rIter+1, cIter-1), ...
%                 occMat(rIter-1,cIter), occMat(rIter+1, cIter), ...
%                 occMat(rIter-1,cIter+1), occMat(rIter,cIter+1), occMat(rIter+1,cIter+1)]);
            meanMatSource = reshape(orgMat(rIter-1:rIter+1, cIter-1:cIter+1), 1, 9);
            if sum(~isnan(meanMatSource)) == 0
                meanMat(rIter-1,cIter-1) = nan;
            else
                meanMat(rIter-1,cIter-1) = nanmean(meanMatSource([1:4, 6:9]));
            end
        end
    end

    reshapedRawMat = reshape(revicedRawMat, 1, (row-2)*(col-2)); %original
    reshapedMeanMat = reshape(meanMat, 1, (row-2)*(col-2)); %made by edgeBins

end
    
reshapedRawMatNan = isnan(reshapedRawMat);
reshapedMeanMatNan = isnan(reshapedMeanMat);
nanVector = reshapedRawMatNan | reshapedMeanMatNan;
reshapedRawMat(nanVector) = [];
reshapedMeanMat(nanVector) = [];

%calculate correlation and coherence
[R, P] = corrcoef(reshapedRawMat, reshapedMeanMat);
r = R(1,2);
z = 0.5 * log((1+r)/(1-r));
coherenceValue = z;