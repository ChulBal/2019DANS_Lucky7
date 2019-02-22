function [occMat spkMat rawMat skaggsrateMat] = abmFiringRateMap(tmazeMat, finAlzPosMat, imROW, imCOL, thisSCALE, samplingRate)


%Generate firing rate map using Skaggs' adaptive binning methods
%[occMat spkMat rawMat skaggsrateMat] = abmFiringRateMap(tmazeMat, finAlzPosMat, imROW, imCOL, thisSCALE, samplingRate)
%
%Input format
%  tmazeMat	 [n x 3 matrix]									timestamp x-coord y-coord
%  finAlzPosMat [n x 3 matrix]									timestamp x-coord y-coord
%  imROW [1 x 1]												number of rows of ratemap
%  imCOL [1 x 1]												number of columns of ratemap
%  thisSCALE [1 x 1]											if you want to use original resolution, it should be 1. If you want to scale-down the resolusion by 10, it should be 10.
%  samplingRate [1 x 1]											sampling rate for behavioral traces. The current settings use 30 Hz.
%
%Output format
% occMat [imROW x imCOL matrix]									raw occupancy map
% spkMat [imROW x imCOL matrix]									raw spike position map
% rawMat [imROW x imCOL matrix; spkMat ./ (occMat .* samplingRate)]		raw firing rate map
% skaggsrateMat [imROW x imCOL matrix]								Skaggs' ABM firing rate map
%
%Originally from VB codes which Inah Lee has.
%Translate VB codes to matlab was done by [Jangjin Kim, July-13-2008]
%Verification was done
%
%Revised by Hyunwoo Lee, 2014-Dec-30

%pINDEX
pXCOORD = 2;																						%x coordinates [from Neuralynx]
pYCOORD = 3;																						%y coordinates [from Neuralynx]
alphaSET = .0001;

occMat = nan(imROW, imCOL);
spkMat = zeros(imROW, imCOL);
rawMat = zeros(imROW, imCOL);
skaggsrateMat = zeros(imROW, imCOL);

for rowRUN = 1:1:imROW
	for colRUN = 1:1:imCOL
		numspk =  size(tmazeMat(tmazeMat(:, pXCOORD) ./ thisSCALE >= (colRUN - 1) & tmazeMat(:, pXCOORD) ./ thisSCALE < colRUN & ... 
							tmazeMat(:, pYCOORD) ./ thisSCALE >= (rowRUN - 1) & tmazeMat(:, pYCOORD) ./ thisSCALE < rowRUN, :));
		if numspk(1, 1) == 0
			spkMat(rowRUN, colRUN) = 0;
		else
			spkMat(rowRUN, colRUN) = numspk(1, 1);
		end	%numspk(1, 1) == 0

		numocc = size(finAlzPosMat(finAlzPosMat(:, pXCOORD) ./ thisSCALE >= (colRUN - 1) & finAlzPosMat(:, pXCOORD) ./ thisSCALE < colRUN & ... 
							finAlzPosMat(:, pYCOORD) ./ thisSCALE >= (rowRUN - 1) & finAlzPosMat(:, pYCOORD) ./ thisSCALE < rowRUN, :));
		if numocc(1, 1) == 0
			occMat(rowRUN, colRUN) = nan;
		else
			occMat(rowRUN, colRUN) = numocc(1, 1);
		end	%numocc(1, 1) == 0
	end	%colRUN = 1:1:imCOL
end	%rowRUN = 1:1:imROW

rawMat = spkMat ./ occMat .* samplingRate;

i = -20:20; j = -20:20;
Ti = zeros(28, 400);
Tj = zeros(28, 400);
Nr = zeros(1, 400);

for ii = 1:1:41
    for jj = 1:1:41
        r = i(1, ii)^2 + j(1, jj)^2;    % r is square of distance from origin.
        if r == 0, r = 1; end
        
        if r <= 400
            N = Nr(r);
            Ti(N + 1, r) = i(1, ii);
            Tj(N + 1, r) = j(1, jj);
            Nr(r) = Nr(r) + 1;
        end	%r <= 400
    end	%jj = 1:1:40
end	%ii = 1:1:41

if sum(sum(spkMat)) <= 0
    skaggsrateMat = rawMat;
    return;
end

nanIND = find(isnan(occMat));
occMat(isnan(occMat)) = 0;

for colRUN = 1:1:imCOL
    for rowRUN = 1:1:imROW
        if occMat(rowRUN, colRUN) == 0
            skaggsrateMat(rowRUN, colRUN) = nan;
            continue;            
        end
        
        EnoughPoints = false;
        occCount = 0;						%Assume there's at least 1 spk and 1 occ -> Is this assuming really needed?
        spkCount = 0;
        r = 0;
        
        while (r < 36) && ~EnoughPoints
            r = r + 1;
            for iter = 1 : Nr(r)
                if (rowRUN + Ti(iter, r) < 1) || (rowRUN + Ti(iter, r) > imROW)
                    continue;
                elseif (colRUN + Tj(iter, r) < 1) || (colRUN + Tj(iter, r) > imCOL)
                    continue;
                else
                    occCount = occCount + occMat(rowRUN + Ti(iter, r), colRUN + Tj(iter, r));
                    spkCount = spkCount + spkMat(rowRUN + Ti(iter, r), colRUN + Tj(iter, r));
                end
            end
            
            if alphaSET^2 * occCount^2 * r * spkCount > 1
                EnoughPoints = true;
            end                        
        end
        
        if occCount < samplingRate / 2
            skaggsrateMat(rowRUN, colRUN) = 0;
        else
            skaggsrateMat(rowRUN, colRUN) = spkCount / occCount * samplingRate;
        end
        
    end
end

occMat(nanIND) = nan;

end