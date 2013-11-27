function [mNewMst,mNewDis,mNewExist,vNewRoot] = insertVertVatNonRecursive(mDis, vExist, vNewR, mMst,mExist)
%
% Implementation of the function INSERT(r), where r is the new vertex to be
% inserted into an existing MST.  See Chin and Houck, 1976, paper.
%
% This version is the non-recursive one.
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

    % find the root with the degree of 1
    vSum = sum(mMst);
    [~,rootVert] = min(vSum);
    
    assert(length(vNewR) == size(mDis, 1));
    assert(size(mMst,1) == size(mDis, 2));
    % ensure at least one valid edge to compare
    assert(sum(vExist) > 0);
    

    % pick initial vertex, which is the same as the root of the current MST
    assert(vExist(rootVert) == 1);
    
    % assume sequential numbering for new vertex
    insertedVert = size(mMst,1) + 1;
 
    
    [mNewMst] = insert3(mDis, vExist, vNewR, mMst, insertedVert, rootVert);
    
     mNewExist = cat(1,mExist,vExist');
     mNewExist = cat(2,mNewExist,[vExist;1]);
     
     mNewDis = cat(1,mDis,vNewR');
     mNewDis = cat(2,mNewDis,[vNewR;0]);
     
     [y,i]=max(mNewDis);
     [~,j]=max(y);
     vNewRoot = i(j);

                
end % end of function
function [mNewMst] = insert3(mDis, vExist, vNewR, mMst, insertedVert, rootVert)
%
% Insert new vertex 'insertedVert' into existing mst 'mMst'.
% Written by Lillian

    mNewMst = zeros(size(mMst,1)+1, size(mMst,1)+1);


    mTraversalOrder = depthFirstTraversal(rootVert, mMst);
    currTravHead = 1;
        
    %cSmallestK = cell(size(mMst,1), 1);
    
    
    edgeT = NaN;
    edgeTWeight = NaN;
    
    
    % preform reverse traversal from leaves of mst
    while currTravHead <= size(mTraversalOrder,1)
        % pop
        vNode = mTraversalOrder(currTravHead,:);
        currVert = vNode(1);
        parentVert = vNode(2);
        
        
        % edge 'm'
        edgeM = NaN;
        edgeMWeight = NaN;
        if vExist(currVert)
            edgeM = [currVert, insertedVert];
            edgeMWeight = vNewR(currVert);
        end
        if parentVert ~= 0
            if currTravHead == 1
                edgeP = NaN; % edge with parent
                degePWeight = NaN;
                if vExist(parentVert)
                    edgeP = [parentVert, insertedVert];
                    edgePWeight = vNewR(parentVert);
                end 
                if edgeMWeight < mDis(currVert, parentVert)
                    mNewMst(edgeM(1), edgeM(2)) = 1;
                    mNewMst(edgeM(2), edgeM(1)) = 1;
                    if edgePWeight < mDis(currVert,parentVert)
                        edgeKWeight = edgePWeight;
                        edgeK = edgeP;
                    else
                        edgeKWeight = mDis(currVert,parentVert);
                        edgeK = [currVert,parentVert];
                    end
                    
                else
                    mNewMst(parentVert, currVert) = 1;
                    mNewMst(currVert, parentVert) = 1;
                    
                    if edgePWeight < edgeMWeight
                        edgeKWeight = edgePWeight;
                        edgeK = edgeP;
                    else
                        edgeKWeight = edgeMWeight;
                        edgeK = edgeM;
                    end    
                end
                edgeT = edgeK;
                edgeTWeight = edgeKWeight;
            else
                if currVert ~= mTraversalOrder((currTravHead-1),2)
                    edgeP = NaN;
                    degePWeight = NaN;
                    if vExist(parentVert)
                        edgeP = [parentVert, insertedVert];
                        edgePWeight = vNewR(parentVert);
                    end 
                    if edgeMWeight < mDis(currVert, parentVert)
                        mNewMst(edgeM(1), edgeM(2)) = 1;
                        mNewMst(edgeM(2), edgeM(1)) = 1;
                    
                        if edgePWeight < mDis(currVert,parentVert)
                            edgeKWeight = edgePWeight;
                            edgeK = edgeP;
                        else
                            edgeKWeight = mDis(currVert,parentVert);
                            edgeK = [currVert,parentVert];
                        end
                    else
                        mNewMst(parentVert, currVert) = 1;
                        mNewMst(currVert, parentVert) = 1;
                    
                        if edgePWeight < edgeMWeight
                            edgeKWeight = edgePWeight;
                            edgeK = edgeP;
                        else
                            edgeKWeight = edgeMWeight;
                            edgeK = edgeM;
                        end
                    end
                    edgeT = edgeK;
                    edgeTWeight = edgeKWeight;   
                else
                    edgeP = NaN;
                    degePWeight = NaN;
                    if vExist(parentVert)
                        edgeP = [parentVert, insertedVert];
                        edgePWeight = vNewR(parentVert);
                    end 
                    if edgeTWeight < mDis(currVert, parentVert)
                        mNewMst(edgeT(1), edgeT(2)) = 1;
                        mNewMst(edgeT(2), edgeT(1)) = 1;
                    
                        if edgePWeight < mDis(currVert,parentVert)
                            edgeKWeight = edgePWeight;
                            edgeK = edgeP;
                        else
                            edgeKWeight = mDis(currVert,parentVert);
                            edgeK = [currVert,parentVert];
                        end
                    else
                        mNewMst(parentVert, currVert) = 1;
                        mNewMst(currVert, parentVert) = 1;
                    
                        if edgePWeight < edgeTWeight
                            edgeKWeight = edgePWeight;
                            edgeK = edgeP;
                        else
                            edgeKWeight = edgeTWeight;
                            edgeK = edgeT;
                        end
                    end
                    
                    edgeT = edgeK;
                    edgeTWeight = edgeKWeight;
                    
                end
            end
            
        end
    currTravHead = currTravHead + 1;
    end % end of while
    mNewMst(edgeT(1), edgeT(2)) = 1;
    mNewMst(edgeT(2), edgeT(1)) = 1;

end % end of function


function [mNewMst] = insert2(mDis, vExist, vNewR, mMst, insertedVert, rootVert)
%
% Insert new vertex 'insertedVert' into existing mst 'mMst'.
%

    mNewMst = zeros(size(mMst,1)+1, size(mMst,1)+1);


    vTraversalOrder = depthFirstTraversal(rootVert, mMst);
    currTravHead = 1;
    
    vRevTraversed = zeros(1, length(vTraversalOrder));
    
    edgeT = NaN;
    edgeTWeight = NaN;
    
    
    % preform reverse traversal from leaves of mst
    while currTravHead <= length(vTraversalOrder)
        % pop
        currVert = vTraversalOrder(currTravHead);
        currTravHead = currTravHead + 1;
        vRevTraversed(currVert) = 1;
        
        % edge 'm'
        edgeM = NaN;
        edgeMWeight = NaN;
        if vExist(currVert)
            edgeM = [currVert, insertedVert];
            edgeMWeight = vNewR(currVert);
        end
        
        % get children
        vNeighs = find(mMst(currVert,:));
        
        for w = 1 : length(vNeighs)
            neighVert = vNeighs(w);
            % only true if neighVert is a child
            if vRevTraversed(neighVert) == 1
            
                if ~isnan(edgeTWeight)
                    
                
                    if edgeTWeight < mDis(neighVert, currVert)
                        edgeKWeight = mDis(neighVert, currVert);
                        edgeK = [currVert, neighVert];
                
                        mNewMst(edgeT(1), edgeT(2)) = 1;
                        mNewMst(edgeT(2), edgeT(1)) = 1;
                    else
                        edgeKWeight = edgeTWeight;
                        edgeK = edgeT;

                        mNewMst(neighVert, currVert) = 1;
                        mNewMst(currVert, neighVert) = 1;
                    end
     
           
                    if edgeKWeight < edgeMWeight
                        edgeM = edgeK;
                        edgeMWeight = edgeKWeight;
                    end
            
                else
                    mNewMst(neighVert, currVert) = 1;
                    mNewMst(currVert, neighVert) = 1;
                end
            end % end of if
        end % end of for
    
    
        edgeT = edgeM;
        edgeTWeight = edgeMWeight;        
        
    end % end of while
        
    mNewMst(edgeT(1), edgeT(2)) = 1;
    mNewMst(edgeT(2), edgeT(1)) = 1;
end % end of function



function [mTraversalOrder] = depthFirstTraversal(rootVert, mMst)
%
% Perform a depth first traversal from root 'currVert', and return the order the
% traversal occured.
%

    mTraversalOrder = zeros(size(mMst,1), 2);
    vTraversed = zeros(1,size(mMst,1));
    
    currOrderIndex = length(vTraversed);
    
    mStack = zeros(length(vTraversed),2);
    mStack(1,:) = [rootVert, 0];
    currStackHead = 1;

    
    while currStackHead > 0
        % pop
        vNode = mStack(currStackHead,:);
        currVert = vNode(1); 
        currParent = vNode(2);
        currStackHead = currStackHead - 1;

        vTraversed(currVert) = 1;
        mTraversalOrder(currOrderIndex,:) = [currVert, currParent];
        currOrderIndex = currOrderIndex - 1;        
        
        % get neighbours
        vNeighs = find(mMst(currVert,:));

        for w = 1 : length(vNeighs)
            neighVert = vNeighs(w);
            if vTraversed(neighVert) == 0  
                currStackHead = currStackHead + 1;
                mStack(currStackHead,:) = [neighVert, currVert];
            end
        end
    end
      
end % end of function