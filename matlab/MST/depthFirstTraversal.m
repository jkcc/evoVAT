function [mTraversalOrder] = depthFirstTraversal(rootVert, mMst)
%
% Perform a depth first traversal from root 'currVert', and return the order the
% traversal occured.
%
% @author: Jeffrey Chan, 2013
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