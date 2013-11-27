function [mNewDis, mNewMst] = incDecEdgeWeights(mDis, mMst, mEdgeChanges)
%
% Update the MST due to edge weight changes.
% Idea of the algorithm is to delete the edge(s) that have increased in weight, then
% find the minimum edge between the resulting component(s).
%
% INPUT
% mEdgeChanges              - Each row of matrix is (src,tar,newDis) for each
%                               edge that have experienced change.
%
% @author: Jeffrey Chan, 2013
%

    mNewDis = mDis;
    mNewMst = mMst;

    % update the distance matrix first
    for r = 1 : size(mEdgeChanges,1)
        src = mEdgeChanges(r,1);
        tar = mEdgeChanges(r,2);
        mNewDis(src, tar) = mNewDis(src, tar) + mEdgeChanges(r,3);
        mNewDis(tar, src) = mNewDis(src, tar);
    end
    
    % now update the mst
    % we update mst for non-tree edge weight decreases first, as this is less
    % likely to cause redundant work, where MST edges that increase in weight
    % are first removed, then we find that they would have been removed from MST
    % anyway when adjencent non-tree edges are considered.
    vIncEdge = find(mEdgeChanges(:,3) > 0);
    vDecEdge = find(mEdgeChanges(:,3) < 0);
    assert(length(vIncEdge) + length(vDecEdge) == size(mEdgeChanges,1));
    
    
    % edge weight decrease
    for r = 1 : length(vDecEdge)
        src = mEdgeChanges(vDecEdge(r),1);
        tar = mEdgeChanges(vDecEdge(r),2);  
        
        % call cycle elimination algorithm, by inserting a dummy vertex
%         mNewMstZ = cat(1, mNewMst, zeros(size(mDis,1),1));
%         mNewMstZ = cat(2, mNewMstZ, zeros(1, size(mDis,2)+1));
        dummyVert = size(mNewMst,1)+1;
        mNewPtDis = zeros(size(mNewMst,1),1);
        
        for v = 1 : size(mNewMst,1)
            mNewPtDis(v,1) = mNewDis(src,v);
        end
        mNewPtDis(src, 1) = min(min(mNewDis))-1;
        
        [~, mNewMst, ~, ~, ~] = incVat(1, mNewDis, ones(size(mNewDis,1), size(mNewDis,2)), mNewMst, mNewPtDis, false);
        % for each edge to z in mst, replace with (src,z)
        vToDummy = find(mNewMst(dummyVert,:));
        % remove the src vertex in vToDummy
        vToDummy(find(vToDummy == src)) = [];
        mNewMst(src, vToDummy) = 1;
        mNewMst(vToDummy,src) = 1;
        % delete dummy
        mNewMst(dummyVert,:) = [];
        mNewMst(:,dummyVert) = [];
    end
    
    
    % edge weight increases
    for r = 1 : length(vIncEdge)
        src = mEdgeChanges(vIncEdge(r),1);
        tar = mEdgeChanges(vIncEdge(r),2);
        % update mst
        % condition is true if modified edge is in the mst, hence we need to
        % upda
        if mNewMst(src,tar)
            mNewMst(src,tar) = 0;
            mNewMst(tar,src) = 0;
            % find connected components
            [commNum, vConn] = graphconncomp(sparse(mNewMst), 'Directed', false, 'Weak', false);
            assert(commNum == 2);
            
            % find minimum edge between the components
            vVertConn1 = find(vConn == 1);
            vVertConn2 = find(vConn == 2);
            [vMinColVals, vRowInd] =  min(mNewDis(vVertConn1, vVertConn2));
            [~, ind] = min(vMinColVals);
            minSrc = vVertConn1(ind);
            minTar = vVertConn2(vRowInd(ind));
            % update mst
            mNewMst(minSrc, minTar) = 1;
            mNewMst(minTar, minSrc) = 1;
        end
    end
    
end % end of function