function [mMst, mDis] = insertEdgeVat(mDis, mExist, mMst, vNewEdge, bUpdateDis)
%
% Inserts a non-tree edge.
% Idea is to remove the largest edge in the cycle formed when an newEdge is added.  
% 
% INPUT:
% mDis          - (n by n), dissimilarity matrix.  Note a value of 0 or 1
%                   doesn't mean missing values, this is indicated by mExist.
% mExist        - (n by n), matrix to indicate which values/edges exist in mDis.
% vNewEdge      - (u, v, w).
% bUpdateDis    - Whether to update the distance matrix. 
%

    % start traversal from the two ends of the njewEdge
    vTraversed = false(1, size(mMst,1));
    
    srcVert = vNewEdge(1);
    tarVert = vNewEdge(2);
    
    
    % bfs queue
    vFront = zeros(1, size(mMst,1));
    cFrontInfo = cell(1, size(mMst,1));
    
    % format [vert, largetst vertex so far encountered, weight]
    vFront(1) = srcVert;
    currFrontIndex = 1;
    currTailIndex = 1;
    
    cFrontInfo{srcVert} = [srcVert, tarVert, vNewEdge(3)];
        
    while ~isempty(find(vFront, 1)) 
        currVert = vFront(currFrontIndex);
        vFront(currFrontIndex) = 0;
        vTraversed(currVert) = true;

        % check if we have hit tarVert
        if currVert == tarVert
            % see what is the largest edge
            largestVert = cFrontInfo{currVert}(1:2);
            % delete largestVert if not [srcVert, tarVert] and replace with
            % latter.
            if largestVert(1) ~= srcVert || largestVert(2) ~= tarVert
                mMst(largestVert(1), largestVert(2)) = 0;
                mMst(largestVert(2), largestVert(1)) = 0;
                mMst(srcVert, tarVert) = 1;
                mMst(tarVert, srcVert) = 1;
            end
            
            % update distance matrix
            if bUpdateDis
                mDis(srcVert, tarVert) = vNewEdge(3);
                mDis(tarVert, srcVert) = vNewEdge(3);
            end
            break;
        end
        vNeighs = find(mMst(currVert,:) & mExist(currVert,:));
        % can profile and optimise this for loop
        for w = 1 : length(vNeighs)
            neighVert = vNeighs(w);
            if ~vTraversed(neighVert) 
                if currTailIndex >= size(mMst,1)
                    currTailIndex = 1;
                else
                    currTailIndex = currTailIndex + 1;
                end
                vFront(currTailIndex) = neighVert;
                largerVert = cFrontInfo{currVert}(1:2);
                largerDis = cFrontInfo{currVert}(3);
                if mDis(currVert, neighVert) > largerDis
                    largerVert = [currVert, neighVert];
                    largerDis = mDis(currVert, neighVert);
                end
                cFrontInfo{neighVert} = [largerVert largerDis];
            end
        end
        
        currFrontIndex = currFrontIndex + 1;
        if currFrontIndex > length(vFront)
            currFrontIndex = 1;
        end
        
            
    
    end
    

end % end of function