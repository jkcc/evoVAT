function streamDataVatSubplot(sDataOption, windowSize, disFactor, step)
%
% INPUT:
% sDataOption       - Option for the data stream input.
%
% OUTPUT:
%
% @Author: Jeffrey Chan & Bingzan Liang, 2013
%

    cmData = getData(sDataOption);
    

    % construct distance matrix
    mDis = squareform(pdist(cmData{1}(:,1:2), 'euclidean'));
  
    % construct original MST
    [mDis, vRearrangedVert, ~, ~, mMst] = Vat(mDis);
    
    % prepare figure
    cmap = hot;
    totalFigNum = ceil(length(cmData) / step);
    figure;
    hold on;
    
    bSubplot = true;
    figNum = 1;
    subplot(1, totalFigNum, figNum);
    visualiseVat(mDis, vRearrangedVert, sprintf('time = %d', 1), cmap, false, bSubplot);
    figNum = figNum + 1;
    
    %[mDis] = iVat(mDis);
    mExist = ones(size(mDis,1),size(mDis,2));
    
    % feed in data, one slice at a time
    for t  = 2 : length(cmData)
        
        if mod(t, step) == 0
            bVisualise = true;
        else
            bVisualise = false;
        end
        %visualise = false;
        
        %visulise when there are 3 clusters in time t
        %if cmData{t}(1,5) == 1
        %    visualise = true;
        %else
        %    visualise = false;
        %end
        
        %visulise when there are pure 3 clusters in time t
        %if (mod(t,3)==0) && (mod(t,6)~=0)
        %    visualise = true;
        %else
        %    visualise = false;
        %end
        
        if t <= windowSize
            mCurrDis = squareform(pdist(cmData{t}(:,1:2),'euclidean'));
            origVert = [];
            for i = 1:(t-1)
                origVert = cat(1,origVert,cmData{i});
            end
            mNewDis = pdist2(origVert(:,1:2),cmData{t}(:,1:2),'euclidean');
            mNewPtsDis = cat(1,mNewDis,mCurrDis);
            [mDis, mMst, ~, vNewRoot, mExist] = incVat(disFactor, mDis, mExist, mMst, mNewPtsDis);
            
            if bVisualise
                subplot(1, totalFigNum, figNum);
                visualiseVat(mDis, vRearrangedVert, sprintf('time = %d', t), cmap, false, bSubplot);
                figNum = figNum + 1;
            end                    
          
        % remove points that fall outside the window
        else
            if windowSize == 1
                mDis = squareform(pdist(cmData{t}(:,1:2), 'euclidean'));
                [mDis, vRearrangedVert, ~, ~, mMst] = Vat(mDis);  
                
                if bVisualise
                    subplot(1, totalFigNum, figNum);
                    visualiseVat(mDis, vRearrangedVert, sprintf('time = %d', t), cmap, false, bSubplot);
                    figNum = figNum + 1;
                end                    
            else
                % delete points that were in cmData{t-windowSize}
                %vPointsToDel = 1 : length(cmData{t-windowSize});
                vPointsToDel = 1 : size(cmData{t-windowSize},1);
            
                % remove from MST
                %[mDis,vRearrangedVert,mMst,mExist,vNewRoot] = deincVat(mDis,mMst,mExist,vPointsToDel,false);
                [mDis,vRearrangedVert,mMst,mExist,vNewRoot] = deincVat2(mDis,mMst,mExist,vPointsToDel);
                
                % compute new distances
                mCurrDis = squareform(pdist(cmData{t}(:,1:2), 'euclidean'));
                origVert = [];
                for i = (t-windowSize+1):(t-1)
                    origVert = cat(1,origVert,cmData{i});
                end
                mNewDis = pdist2(origVert(:,1:2),cmData{t}(:,1:2),'euclidean');
                mNewPtsDis = cat(1,mNewDis,mCurrDis);
                [mDis, mMst, vRearrangedVert, vNewRoot, mExist] = incVat(disFactor, mDis, mExist, mMst, mNewPtsDis);
                
                if bVisualise
                    subplot(1, totalFigNum, figNum);
                    visualiseVat(mDis, vRearrangedVert, sprintf('time = %d', t), cmap, false, bSubplot);
                    figNum = figNum + 1;
                end                    
            end % end of if windowSize == 1
        end % end of if t <= windowSize
    end % end of for loop
end % end of function