function [mNewMst,vNewRoot,mNewExist,mNewDis] = insertVertVat(mDis, mExist, vExist, vNewR, mMst)
%
% Implementation of the function INSERT(r), where r is the new vertex to be
% inserted into an existing MST.  See Chin and Houck, 1976, paper.
%
% ***Input***
% mDis      - Dissimility matrix.
% vExist    - (n by 1), vector of logical values indicating if values in vNewR
%               exist or are considered missing.
% vNewR     - Vector of dissimilarity to each existing vertex in mDis.
% mMst      - Existing MST, in adjacency matrix format.
% rootVert  - Root vertex of MST.
%
% ***Output***
% vNewMst   - New MST with new vertex inserted.
%
    vSum = sum(mMst);
    [~,rootVert] = min(vSum);

    assert(length(vNewR) == size(mDis, 1));
    assert(size(mMst,1) == size(mDis, 2));
    % ensure at least one valid edge to compare
    assert(sum(vExist) > 0);
    
    % vector to store 'new', 'old' markings, where '1' denote new and '0' for
    % old
    vTraversal = ones(1, length(vNewR));
%     vNewMst = zeros(1, length(vMst)+1);
    mNewMst = zeros(size(mMst,1)+1, size(mMst,1)+1);

    % pick initial vertex, which is the same as the root of the current MST
%     currVert = randi(length(vMst), 1);
    currVert = rootVert;
%     assert(vMst(currVert) == 0); 
    assert(vExist(currVert) == 1);
    
    edgeT = NaN;
    edgeTWeight = NaN;
    
    insertedVert = size(mMst,1) + 1;
  

    
    [newEdgeT, ~, mNewMst] = recursiveInsert(mDis, vExist, vNewR, mMst, mNewMst, insertedVert, currVert, vTraversal, edgeT, edgeTWeight); 
    

%     display('t');
%     newEdgeT
%     if vNewMst(newEdgeT(1)) ~= 0
% %         assert(vNewMst(newEdgeT(2)) == 0);
%         vNewMst(newEdgeT(2)) = newEdgeT(1);
%     else
%         vNewMst(newEdgeT(1)) = newEdgeT(2);
%     end
     mNewMst(newEdgeT(1), newEdgeT(2)) = 1;
     mNewMst(newEdgeT(2), newEdgeT(1)) = 1;
     
     mNewExist = cat(1,mExist,vExist');
     mNewExist = cat(2,mNewExist,[vExist;1]);
     
     mNewDis = cat(1,mDis,vNewR');
     mNewDis = cat(2,mNewDis,[vNewR;0]);
     
    [y,i]=max(mNewDis);
     [~,j]=max(y);

     vNewRoot = i(j);

end % end of function


function [newEdgeT, newEdgeTWeight, mNewMst] = recursiveInsert(mDis, vExist, vNewR, mMst, mNewMst, insertedVert, currVert, vTraversal, edgeT, edgeTWeight)


%     currVert
    vTraversal(currVert) = 0;
    
    edgeM = NaN;
    edgeMWeight = NaN;
    if vExist(currVert)
%     if insertedVert <= currVert
%         edgeM = [insertedVert, currVert];
%     else
        edgeM = [currVert, insertedVert];
%     end
        edgeMWeight = vNewR(currVert);
    end

        
        
    
    % get neighbours (parents and children) on vMst
%     parent = vMst(currVert);
    
    % get children
%     vNeighs = find(vMst == currVert);
    vNeighs = find(mMst(currVert,:));
%     if parent ~= 0
%         vNeighs = [vNeighs parent];
%     end
    
    for w = 1 : length(vNeighs)
        neighVert = vNeighs(w);
        if vTraversal(neighVert) == 1
%             currVert
%             neighVert
            [newEdgeT, newEdgeTWeight, mNewMst] = recursiveInsert(mDis, vExist, vNewR, mMst, mNewMst, insertedVert, neighVert, vTraversal, edgeT, edgeTWeight); 
            % TODO: decide how to break ties
            
            if ~isnan(newEdgeTWeight)
                
                if newEdgeTWeight < mDis(neighVert, currVert)
                    edgeKWeight = mDis(neighVert, currVert);
%                 if neighVert <= currVert
%                     edgeK = [neighVert, currVert];
%                 else
                    edgeK = [currVert, neighVert];
%                 end
                   
%                 display('t');
%                 newEdgeT
                    mNewMst(newEdgeT(1), newEdgeT(2)) = 1;
                    mNewMst(newEdgeT(2), newEdgeT(1)) = 1;
%                 if vNewMst(newEdgeT(1)) ~= 0
% %                     assert(vNewMst(newEdgeT(2)) == 0);
%                     vNewMst(newEdgeT(2)) = newEdgeT(1);
%                 else
%                     vNewMst(newEdgeT(1)) = newEdgeT(2);
%                 end
%                 mNewMst
                else
                    edgeKWeight = newEdgeTWeight;
                    edgeK = newEdgeT;
%                 display('(w,r)');
%                 [currVert, neighVert]
                    mNewMst(neighVert, currVert) = 1;
                    mNewMst(currVert, neighVert) = 1;
%                 if vNewMst(currVert) ~= 0
% %                     assert(vNewMst(neighVert) == 0);
%                     vNewMst(neighVert) = currVert;
%                 else
%                     vNewMst(currVert) = neighVert;
%                 end
%                 mNewMst
                end
           
                if edgeKWeight < edgeMWeight
                    edgeM = edgeK;
                    edgeMWeight = edgeKWeight;
                end
            else
                mNewMst(neighVert, currVert) = 1;
                mNewMst(currVert, neighVert) = 1;
                % we don't update mEdge, because edgeK should be edgeT, which is
                % Nan
            end
        end % end of if
    end % end of for
    
    
    newEdgeT = edgeM;
    newEdgeTWeight = edgeMWeight;
    
   
end