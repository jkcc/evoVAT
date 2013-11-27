function [mNewDis, mNewMst, vRearrangedVert, vNewRoot, mNewExist] = incVat(a,mDis, mExist, mMst, mNewPtsDis, bVisualise)
% incVat()
% Updates an existing Vat image with the new points described in mRNew.
% The new points are added sequentially to the end.
%
% INPUT:
% mDis      - (n by n), dissimilarity matrix.
% mExist    - (n by n), existence matrix.
% vMst      - Minimum spanning tree, 1 by n, with each entry denoting the parent of
%           the corresponding vertex.  Root vertex has entry '0'.
% mNewPtsDis     - New distances to existing points and all new points.  Dimensions
%           should be n' by (new points number), where n' = n + new points
%           number.  
% rootVert  - Root vertex.
% bVisualise    - Whether to visualise the updated MST.
%
% OUTPUT:
% mNewDis   - Updated distance measure with the new distances.
% vNewMst   - Updated MST.
% vRearrangedVerts - Ordered set of vertices (used for VAT display).
%
    mDis = a*mDis;
    mNewMst = mMst;
    mNewDis = mDis;
    mNewExist = mExist;
    oldSize = size(mMst,1);
    mNewPtsExist = ones((size(mExist,1)+size(mNewPtsDis,2)),size(mNewPtsDis,2));
    
    old = size(mDis,1);
    new = size(mNewPtsDis,1);
    mNewTempDis = a * mNewPtsDis(1:old,:);
    mNewTempDis2 = mNewPtsDis((old+1):new,:);
    mNewPtsDis = [mNewTempDis;mNewTempDis2];
    
    %mvNewDis = [mvDis mNewTempDis];
    %mvNewDis = [mvNewDis;[mNewTempDis' mNewTempDis2]];
    
    % add each new vertex
    for p = 1 : size(mNewPtsDis,2)
        vNewPtsDis = mNewPtsDis( 1:(oldSize+p-1), p);
        vNewPtsExist = mNewPtsExist(1:(oldSize+p-1), p);
        [mNewMst,vNewRoot,mNewExist,mNewDis] = insertVertVat(mNewDis, mNewExist, vNewPtsExist, vNewPtsDis, mNewMst);
        %[mNewMst,mNewDis,mNewExist,vNewRoot] = insertVertVatNonRecursive(mNewDis, vNewPtsExist, vNewPtsDis, mNewMst,mNewExist);
        %mNewMst = insertVertVatNonRecursive(mNewDis, vNewPtsExist, vNewPtsDis, mNewMst, rootVert);
        
        %mNewDis = cat(1, mNewDis, vNewPtsDis');
        %mNewDis = cat(2, mNewDi4es, [vNewPtsDis; 0]);
    end
    
    %
    % construct the rearraned vertices by traversing the updated MST
    %
    
    vRearrangedVert = zeros(1, size(mNewMst,1));
    
    % traverse the tree
    javaComparator = PriorityComparator;
    qPriority = java.util.PriorityQueue(size(mNewMst,1), javaComparator);
    qPriority.add({0, vNewRoot});
    vTraversed = false(1, size(mNewMst,1));
    currIndex = 1;
    
    while qPriority.size() > 0
        vHead = qPriority.poll();
        currVert = vHead(2);
        vTraversed(currVert) = true;
        vRearrangedVert(currIndex) = currVert;
        % find children + parents 
        vNeighs = find(mNewMst(currVert,:));
%         vNeighs = find(vNewMst == currVert);
%         parentVert = vNewMst(currVert);
%         if parentVert ~= 0
%             vNeighs = [vNeighs parentVert]; 
%         end        
        
        for v = 1 : length(vNeighs)
            neighVert = vNeighs(v);
            if ~vTraversed(neighVert)
                qPriority.add({mNewDis(currVert, neighVert), neighVert});
            end
        end
        
        currIndex = currIndex + 1;
    end    
    
end % end of function

