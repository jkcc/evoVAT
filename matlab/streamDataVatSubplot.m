function streamDataVatSubplot(cmData, windowSize, disFactor, step, mCMap,...
    sAlgorithm, varargin)
%
% VAT for visualising streaming data.
%
% INPUT:
% sDataOption       - Option for the data stream input.
% windowSize        - Size of window that a VAT image visualises over.
% disFactor         -
% step              - 
% mCMap             - (colourNum * 3) Colourmap to illustrate the
%                       distances.
% sAlgorithm        - Name of the algorithm to use to order the points of the VAT images.
%
% OUTPUT:
% None
%
% @Author: Jeffrey Chan & Bingzan Liang, 2013
%

    % parse arguments
    inParser = inputParser;
    % default values
    vFeatCols = 1:2;
    linearWeight = 0.5;
    
    addOptional(inParser, 'genSubplot', true);
    addOptional(inParser, 'featCols', vFeatCols);
    addOptional(inParser, 'linearWeight', linearWeight);

    parse(inParser, varargin{:});
    
    bGenSubplot = inParser.Results.genSubplot;
    vFeatCols = inParser.Results.featCols;
    linearWeight = inParser.Results.linearWeight;
    
    
    switch sAlgorithm
        case 'separate'
            fDisAlgor = DisAlgorSeparate();
        case 'linear'
            assert(length(varargin) == 1);
            alpha = linearWeight;
            fDisAlgor = DisAlgorLinear(alpha);
            
        otherwise
            warn(sprintf('Unknown sAlgorithm option %s', sAlgorithm));
            return;
    end % end of switch



%     % load data into cell form
%     cmData = genCmData(mData);

    % construct distance matrix
    mDis = squareform(pdist(cmData{1}(:,vFeatCols), 'euclidean'));
    % construct age matrix (age of points) (assuming age starts at 1)
    mAge = ones(size(cmData{1},1), size(cmData{1},1));
    % construct age of the points
    vPointAge = ones(size(cmData{1},1), 1);
  
    % construct original MST
    [mDis, vRearrangedVert, ~, ~, mMst] = Vat(mDis);
    
    % prepare figure
    % if subplot prepare
    if bGenSubplot
        totalFigNum = ceil(length(cmData) / step);
        figure;
        hold on;
    
    
        figNum = 1;
        % visualise first time step
        subplot(1, totalFigNum, figNum);
        figNum = figNum + 1;
    end
    visualiseVat(mDis, vRearrangedVert, sprintf('time = %d', 1),...
        'cmap', mCMap, 'visualiseLabels', false, 'genFigure', ~bGenSubplot, 'ageData', mAge);
    
    %[mDis] = iVat(mDis);
    mExist = ones(size(mDis,1),size(mDis,2));
    
    
    % past distances in window
    mPastData = cmData{1}(:,vFeatCols);
    
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
        
        % no need to remove points when our window size is growing
        if t <= windowSize
%             mCurrDis = squareform(pdist(cmData{t}(:,1:2),'euclidean'));
%             origVert = [];
%             for i = 1:(t-1)
%                 origVert = cat(1,origVert,cmData{i});
%             end
%             mNewDis = pdist2(origVert(:,1:2),cmData{t}(:,1:2),'euclidean');
%             mNewPtsDis = cat(1,mNewDis,mCurrDis);
%             
%             % to merge with incVAT later
%             mAge = cat(2, mAge, t*ones(size(origVert,1), size(mCurrDis,1)));
%             mTemp = cat(2, t*ones(size(mCurrDis,1), size(origVert,1) + size(mCurrDis,1)));
%             mAge = cat(1, mAge, mTemp);
         
            [mNewPtsDis, mAge, vPointAge] = fDisAlgor.computeNewDis(cmData{t}(:,1:2), mPastData, t, vPointAge, mAge);
%             [mNewPtsDis, mAge] = updateDis(cmData, mAge);
            
            [mDis, mMst, vRearrangedVert, vNewRoot, mExist] = incVat(disFactor, mDis, mExist, mMst, mNewPtsDis);
            
            
            mPastData = cat(1, cmData{t}(:,vFeatCols));
           
            if bVisualise
                if bGenSubplot
                    subplot(1, totalFigNum, figNum);
                    figNum = figNum + 1;
                end
                visualiseVat(mDis, vRearrangedVert, sprintf('time = %d', t),...
                    'cmap', mCMap, 'visualiseLabels', false, 'genFigure', ~bGenSubplot, 'ageData', mAge);
            end                    
          
        % remove points that fall outside the window
        else
            if windowSize == 1
                mDis = squareform(pdist(cmData{t}(:,1:2), 'euclidean'));
                mAge = t * ones(size(cmData{t},1), size(cmData{t},1));
                
                [mDis, vRearrangedVert, ~, ~, mMst] = Vat(mDis);  
                
                if bVisualise
                    if bGenSubplot
                        subplot(1, totalFigNum, figNum);
                        figNum = figNum + 1;
                    end                    
                    visualiseVat(mDis, vRearrangedVert, sprintf('time = %d', t),...
                        'cmap', mCMap, 'visualiseLabels', false, 'genFigure', ~bGenSubplot, 'ageData', mAge);
                end                    
            else
                % delete points that were in cmData{t-windowSize}
                %vPointsToDel = 1 : length(cmData{t-windowSize});
                vPointsToDel = 1 : size(cmData{t-windowSize},1);
            
                % remove from MST
                %[mDis,vRearrangedVert,mMst,mExist,vNewRoot] = deincVat(mDis,mMst,mExist,vPointsToDel,false);
                [mDis, vRearrangedVert, mMst, mExist, vNewRoot] = deincVat2(mDis,mMst,mExist,vPointsToDel);
                % to merge 
                mAge(vPointsToDel,:) = [];
                mAge(:,vPointsToDel) = [];
                mPastData(vPointsToDel,:) = [];
                vPointAge(vPointsToDel) = [];
                
%                 % compute new distances
%                 mCurrDis = squareform(pdist(cmData{t}(:,1:2), 'euclidean'));
%                 origVert = [];
%                 for i = (t-windowSize+1):(t-1)
%                     origVert = cat(1,origVert,cmData{i});
%                 end
%                 mNewDis = pdist2(origVert(:,1:2),cmData{t}(:,1:2),'euclidean');
%                 mNewPtsDis = cat(1,mNewDis,mCurrDis);
%                 % to merge with incVAT later
%                 mAge = cat(2, mAge, t*ones(size(origVert,1), size(mCurrDis,1)));
%                 mTemp = cat(2, t*ones(size(mCurrDis,1), size(origVert,1) + size(mCurrDis,1)));
%                 mAge = cat(1, mAge, mTemp);  
                               
%                 [mNewPtsDis, mAge] = updateDis(cmData, mAge);
                [mNewPtsDis, mAge, vPointAge] = fDisAlgor.computeNewDis(cmData{t}(:,1:2), mPastData, t, vPointAge, mAge);
                
                [mDis, mMst, vRearrangedVert, vNewRoot, mExist] = incVat(disFactor, mDis, mExist, mMst, mNewPtsDis);
             
                
                if bVisualise
                    if bGenSubplot
                        subplot(1, totalFigNum, figNum);
                        figNum = figNum + 1;
                    end                       
                    visualiseVat(mDis, vRearrangedVert, sprintf('time = %d', t),...
                        'cmap', mCMap, 'visualiseLabels', false, 'genFigure', ~bGenSubplot, 'ageData', mAge);
                end                    
            end % end of if windowSize == 1
        end % end of if t <= windowSize
    end % end of for loop
end % end of function


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
%%% UTILITIES %%%


function [cmData] = genCmData(mData)
%
% 
%

    timeCol = 3;

    cmData = cell(max(mData(:,timeCol)),1);
    for i = 1:length(cmData)
        cmData{i} = mData((mData(:,timeCol)==i),:);

        %temp = tempData(:,3) == i;
        %for j = 1:length(temp)
            %if temp(j) == 1
                %cmData{i} = cat(1,cmData{i},tempData(j,:));
            %end
        %end
    end
end % end of function


% function [mNewPtsDis, mAge] = updateDis(cmData, mAge)
% %
% %
% %
%     mCurrDis = squareform(pdist(cmData{t}(:,1:2),'euclidean'));
%     origVert = [];
%     for i = 1:(t-1)
%         origVert = cat(1,origVert,cmData{i});
%     end
%     mNewDis = pdist2(origVert(:,1:2),cmData{t}(:,1:2),'euclidean');
%     mNewPtsDis = cat(1,mNewDis,mCurrDis);
%             
%     % to merge with incVAT later
%     mAge = cat(2, mAge, t*ones(size(origVert,1), size(mCurrDis,1)));
%     mTemp = cat(2, t*ones(size(mCurrDis,1), size(origVert,1) + size(mCurrDis,1)));
%     mAge = cat(1, mAge, mTemp);
% 
% end % end of function