function [avgFr, information] = informationContent(occMat, rateMat)
%to calculate information content, occMat and rateMat are needed.

occMat(isnan(occMat) == 1) = 0;

rateMat((isnan(rateMat) == 1 | isinf(rateMat)) == 1) = 0;

[row, col] = size(rateMat);

totOcc = sum(nansum(occMat,2),1);

Pi = occMat / totOcc;

%to calcultate average firing rate

avgFr = 0;

for rIter = 1:row
    for cIter = 1:col
        avgFr = avgFr + Pi(rIter, cIter) * rateMat(rIter, cIter);
    end
end

%to calculate information content

information = 0;

for rIter = 1:row
    for cIter = 1:col
        if rateMat(rIter, cIter) ~= 0
            information = information + Pi(rIter,cIter) * rateMat(rIter, cIter) / avgFr * log2(rateMat(rIter, cIter) / avgFr);
        end
    end
end