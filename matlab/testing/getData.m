function [ cmData ] = getData( sDataOption )
%
% Determines the source of the streaming data and reads it in.
%
% INPUT:
% sDataOption       - Option for the data stream input.
%
% OUTPUT:
% cmData            -
%
% @Author: Jeffrey Chan & Bingzan Liang, 2013
%

    switch sDataOption
        case 'mahsaSyn'
            %stDb = load('X7.mat'); %center drifting (99 points in one timestep, 11 timesteps)
           stDb = load('X6.mat'); %24 points in one timestep, 20 timesteps 
            
            tempData = stDb.X;
        case 'sensor'
            
            
            
        otherwise
        
    end
    cmData = cell(max(tempData(:,3)),1);
    for i = 1:length(cmData)
        cmData{i} = tempData((tempData(:,3)==i),:);

        %temp = tempData(:,3) == i;
        %for j = 1:length(temp)
            %if temp(j) == 1
                %cmData{i} = cat(1,cmData{i},tempData(j,:));
            %end
        %end
    end

end % end of function

