function [ cmData ] = getData( sDataOption, dataset )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
switch sDataOption
        case 'mahsaSyn'
            %stDb = load('X7.mat'); %center drifting (99 points in one timestep, 11 timesteps)
           stDb = load(dataset); %24 points in one timestep, 20 timesteps 
            
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


end

