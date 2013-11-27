function [vRearrangedVert] = feedInLabelledData(mDataDis, csLabels, sStreamOption, varargin)
%
% Used for testing incVat with data fed in incrementally from labelled data.
%
% INPUTS:
% mDataDis      - Distance matrix (n x n).
% vLabels       - Vector of labels for each point in mDis (n x 1).
% sStreamOption - How the points are passed into incVat.
% varargin{1}   - The data points when to display a plot.
% varargin{2}   - If not empty, this is the filename to output video.
% 
% feedInLabelledData(mDis, mData(:,4), 'random', 1:5:size(mData,1),
% 'videoFileName')
    
    % find maximum point
    [vV, vColMax] = max(mDataDis);
    [~,maxRow] = max(vV);
    maxCol = vColMax(maxRow);
    rootVert = maxCol;
    
    csClusLabels = unique(csLabels);
    clusNum = length(csClusLabels);
    
    bMakeVideo = false;
    sVideoFilename = '';
    assert(clusNum >= 1);    
    
    % when to display a point
    vDisplayIter = zeros(1, clusNum);
    if isempty(varargin)
        runningSum = 0;
        for c = 1 : clusNum
            runningSum = runningSum + length(find(strcmp(csLabels, csClusLabels(c))));
            vDisplayIter(c) = runningSum;
        end
    else
        if length(varargin) == 2
            bMakeVideo = true;
            sVideoFilename = varargin{2};
        end
        vDisplayIter = varargin{1};
    end
    
    mExist = ones(size(mDataDis,1), size(mDataDis,2));
    
    
    switch sStreamOption
        case 'cluster'
            vRearrangedVert = clusByClus(mDataDis, mExist, csLabels, rootVert, csClusLabels, vDisplayIter, bMakeVideo, sVideoFilename);
        case 'random'
            vRearrangedVert = randomStream(mDataDis, mExist, csLabels, rootVert, vDisplayIter, bMakeVideo, sVideoFilename);
        otherwise
            error('%s is an unknown sSteamOption.', sStreamOption);
    end
    
end % end of function



function [vRearrangedVert] = clusByClus(mDataDis, mExist, csLabels, rootVert, csClusLabels, vDisplayIter, bMakeVideo, sVideoFilename)
%
% Evaluate cluster by cluster.
%

    % make the cluster with rootvert the first one
    temp = csClusLabels(1);
    idxRootVert = find(strcmp(csClusLabels, csLabels(rootVert)));
    csClusLabels(1) = csLabels(rootVert);
    csClusLabels(idxRootVert) = temp;
    
    
    vClusPoints = find(strcmp(csLabels, csClusLabels(1)));
    idx = vClusPoints == rootVert;
    vClusPoints(idx) = [];
    mDis = mDataDis(rootVert, rootVert);
    mMst = 0;
    vAdded = rootVert;
    
    bVisualise = false;
    currDisplayIndex = 1;
    displayedPoints = 1;
    
    % video setup
    if bMakeVideo
%         figure('Position', [100, 100, 800, 640]);
        imagesc(ones(size(mDataDis,1), size(mDataDis,2)));
%         set(gca, 'NextPlot', 'replacechildren', 'Visible', 'off');
        set(gca, 'NextPlot', 'replacechildren', 'Visible', 'off');
%         set(gcf, 'PaperPosition', [0,0, 800, 640]);
        writerObj = VideoWriter(sVideoFilename);
        writerObj.Quality = 100;
        writerObj.FrameRate = 10;
        open(writerObj); 
    end
    
    for v = 1 : length(vClusPoints)
        fprintf('feeding in %d\n', vClusPoints(v));
        mNewPtsDis = mDataDis(vAdded, vClusPoints(v));
        [mDis, mMst, vRearrangedVert] = incVat(mDis, mExist, mMst, mNewPtsDis, 1, bVisualise);
        vAdded = cat(1, vAdded, vClusPoints(v));
        
        displayedPoints = displayedPoints + 1;
        
        if vDisplayIter(currDisplayIndex) == displayedPoints
            % compute iVat
            [mIDis] = iVat(mDis(vRearrangedVert, vRearrangedVert), true, false);
    
            if ~bMakeVideo
                figure;
                colormap(gray);
                imagesc(mIDis);  
            else
                colormap(gray);
                imagesc(mIDis);
                writeVideo(writerObj, getframe(gca));
            end
            
            if currDisplayIndex < length(vDisplayIter)
                currDisplayIndex = currDisplayIndex + 1;
            end
        end 
        
    end


    
    
    % feed in each class label
    for c = 2 : length(csClusLabels)
        vClusPoints = find(strcmp(csLabels, csClusLabels(c)));
        for v = 1 : length(vClusPoints)
            fprintf('feeding in %d\n', vClusPoints(v));
            mNewPtsDis = mDataDis(vAdded, vClusPoints(v));
            [mDis, mMst, vRearrangedVert] = incVat(mDis, mExist, mMst, mNewPtsDis, 1, bVisualise);
            vAdded = cat(1, vAdded, vClusPoints(v));
            
            displayedPoints = displayedPoints + 1;
            
            if vDisplayIter(currDisplayIndex) == displayedPoints
                % compute iVat
                [mIDis] = iVat(mDis(vRearrangedVert, vRearrangedVert), true, false);
    
                if ~bMakeVideo
                    figure;
                    colormap(gray);
                    imagesc(mIDis);  
                else
                    colormap(gray);
                    imagesc(mIDis);
                    writeVideo(writerObj, getframe(gca)); 
                end
            
                if currDisplayIndex < length(vDisplayIter)
                    currDisplayIndex = currDisplayIndex + 1;
                end
            end    
            
            
        end
                     
    end
    
    if bMakeVideo
        close(writerObj);
    end
    

end % end of function


function [vRearrangedVert] = randomStream(mDataDis, mExist, csLabels, rootVert, vDisplayIter, bMakeVideo, sVideoFilename)
%
% Random stream data points in.
%
    vVertOrder = randperm(length(csLabels));
    % remove root then permutate
    idx = vVertOrder == rootVert;
    vVertOrder(idx) = [];
    vVertOrder = [rootVert vVertOrder];
    length(vVertOrder)
    
    % initialise datastructures
    mDis = mDataDis(rootVert, rootVert);
    mMst = 0;
    vAdded = rootVert;    
    
    bVisualise = false;
    currDisplayIndex = 1;
    
    % video setup
    if bMakeVideo
%         figure;
        imagesc(ones(size(mDataDis,1), size(mDataDis,2)));
%         set(gca, 'NextPlot', 'replacechildren', 'Visible', 'off');     
        set(gca, 'NextPlot', 'replacechildren', 'Visible', 'off');
        writerObj = VideoWriter(sVideoFilename);
        open(writerObj); 
    end    
    
    % feed in point by point, and display an image at the points indicated by
    % vDisplayIter
    for v = 2 : length(vVertOrder)
        fprintf('feeding in %d\n', vVertOrder(v));
        mNewPtsDis = mDataDis(vAdded, vVertOrder(v));
        [mDis, mMst, vRearrangedVert] = incVat(mDis, mExist, mMst, mNewPtsDis, 1, bVisualise);  
        vAdded = cat(1, vAdded, vVertOrder(v));

        
        if vDisplayIter(currDisplayIndex) == v    
            % compute iVat
            [mIDis] = iVat(mDis(vRearrangedVert, vRearrangedVert), true, false);
            
              
            if ~bMakeVideo
                figure;
                colormap(gray);
                imagesc(mIDis);  
            else
                colormap(gray);
                imagesc(mIDis);
                writeVideo(writerObj, getframe(gca));
            end            
            
            if currDisplayIndex < length(vDisplayIter)
                currDisplayIndex = currDisplayIndex + 1;
            end
        end
    end


end % end of function