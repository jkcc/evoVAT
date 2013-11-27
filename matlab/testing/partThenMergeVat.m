function [mMergedMst, vRearrangedVert, rootVertNew] = partThenMergeVat(mDataDis, csLabels, vertOverlapPerc, interPartPerc, sPartOption)
%
% Used for testing mergeVat by dividing data a number of ways then comparing the
% VAT image produced. 
%
% INPUTS:
% mDataDis      - Distance matrix (n x n).
% vLabels       - Vector of labels for each point in mDis (n x 1).
% vertOverlapPerc - Percentage of overlap between vertices allowed.
% sPartOption   - Partitioning options.
% 
%
    
    % find maximum point
%     [vV, vColMax] = max(mDataDis);
%     [~,maxRow] = max(vV);
%     maxCol = vColMax(maxRow);
%     rootVert = maxCol;
    
    csClusLabels = unique(csLabels);
    clusNum = length(csClusLabels);
    
    assert(clusNum >= 1);    
    

       
    switch sPartOption
        case 'cluster'
            vRearrangedVert = clusByClus(mDataDis, csLabels, csClusLabels);
        case 'random'
            [mMergedMst, vRearrangedVert, rootVertNew] = randomStream(mDataDis, csLabels, vertOverlapPerc, interPartPerc);
        otherwise
            error('%s is an unknown sPartOption.', sPartOption);
    end
    
    
        

end % end of function



function [mMergedMst, vRearrangedVert, rootVertNew] = randomStream(mDataDis, csLabels, vertOverlapPerc, interPartPerc)
%
% Uniformally randomly partition the vertices into three parts, with the number
% of common vertices determined by vertOverlapPerc.
%
% Note that the two partitions are more or less equal sized.  This is to reduce
% the number of dimensions, but can be easily made to be random also.
%
% interPartPerc         - Percentage of edges/dissimilarity values that exist
%                           between the missing blocks of the full matrix.
%

    assert(vertOverlapPerc >= 0 && vertOverlapPerc <= 1.0);
    assert(length(csLabels) >= 3);

    % generate number of common vertices
    vertNum = length(csLabels);
    commonNum = round(vertNum * vertOverlapPerc);
    remainingNum = vertNum - commonNum;
    % relative size of two remaining halves (equal size)
    partNum1 = ceil(remainingNum / 2);
    partNum2 = remainingNum - partNum1;
    if partNum2 == 0
        partNum2 = 1;
        partNum1 = partNum1 - 1;
    end
    
    vVertOrder = randperm(vertNum);
    vDiffVert1 = vVertOrder(1:partNum1);
    vCommonVert = vVertOrder(partNum1+1:partNum1 + commonNum);
    vDiffVert2 = vVertOrder(partNum1 + commonNum + 1 : end);
    
    % compute the individual VAT
    vPartVert1 = cat(2, vDiffVert1, vCommonVert);
    [mRearrangedDis1, vPermVerts1, ~, ~, mMst1] = Vat(mDataDis(vPartVert1, vPartVert1), false);

    vPartVert2 = cat(2, vDiffVert2, vCommonVert);
    [mRearrangedDis2, vPermVerts2, ~, ~, mMst2] = Vat(mDataDis(vPartVert2, vPartVert2), false);    
    
    
    % compute the missing edges/values
    mExist = true(vertNum, vertNum);
    vMissing = randperm(length(vDiffVert1) * length(vDiffVert2), length(vDiffVert1) * length(vDiffVert2) * (1- interPartPerc));
    mExist(vMissing) = 0;
    
    % call merge vat
    [mMergedMst, vRearrangedVert, rootVertNew] = mergeVat(mDataDis, mExist, mMst1, mMst2, vPartVert1, vPartVert2, vPermVerts1(1), vPermVerts2(1));




end % end of function