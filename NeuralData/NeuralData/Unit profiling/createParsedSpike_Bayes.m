% clear; close all; clc
% thisClName = '317-03-1-1';
% pilotSession = false;

function [t_spk, x_spk, y_spk] = createParsedSpike_Bayes(posTable, spkFile, startTimestamp,endTimestamp)
%posTable = t, x, y, a


%load spk timestamp
thisEpochCLTS = dlmread(spkFile, ',', 13, 17); %x_spk, y_spk, t_spk

thisEpochCLTS(thisEpochCLTS<= startTimestamp | thisEpochCLTS >= endTimestamp) = [];
thisEpochCLTS = thisEpochCLTS/10^6;


%posTable setup
t = posTable{:,1};
x = posTable{:,2};
y = posTable{:,3};
posN = size(t,1);

%assign x, y coordinate to spike
spkN = length(thisEpochCLTS);
t_spk = zeros(spkN, 1);
x_spk = zeros(spkN, 1);
y_spk = zeros(spkN, 1);


clRUN = 1;
posRUN = 1;
while posRUN <= posN
    if t(posRUN,1) >= thisEpochCLTS(clRUN) && posRUN == 1 %spk before first position
        cPos = posRUN;
        spkAssign;
        clRUN = clRUN + 1;
    elseif t(posRUN,1) >= thisEpochCLTS(clRUN) % spk before specific pos data  pos(n-1) ... spk ... pos(n)
        if t(posRUN,1)-thisEpochCLTS(clRUN) < thisEpochCLTS(clRUN)-t(posRUN-1,1) %position after spk is close to spk
            
            cPos = posRUN;
                  
            
            spkAssign;
            posRUN = posRUN - 1; clRUN = clRUN + 1; %to not increase posRUN
        else %position before spk is closed to spk
            
            cPos = posRUN-1;       
            
            spkAssign;  
            posRUN = posRUN - 1; clRUN = clRUN + 1; %to not increase posRUN
        end
    end
    
    if clRUN > length(thisEpochCLTS)
        break;
    end
    
    posRUN = posRUN + 1;
end


if clRUN <= length(thisEpochCLTS)   % spikes after last position sampling.
    posRUN = posRUN - 1;
    
    while clRUN <= length(thisEpochCLTS)    
%     for iter = clRUN : length(thisEpochCLTS)    
        
        cPos = posRUN;
        spkAssign;
        clRUN = clRUN + 1;
    end
end


