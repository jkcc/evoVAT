function [vPermVerts] = traverseMst(mDis, mMst)
% 
% Find smallest weighted edge, start at source vertex of that weighted edge.
%
% @author: Jeffrey Chan, 2013
%

    vPermVerts = zeros(1,size(mDis,1));

    % find maximum edge and use that as the start of the traversal
    [y,i]=max(mDis);
    [~,j]=max(y);
    rootVert = i(j);
%     vPermVerts(1) = rootVert;
    currIndex = 1;
    
    % priority queue
    javaComparator = PriorityComparator;
    qPriority = java.util.PriorityQueue(size(mMst,1), javaComparator);
    qPriority.add({0, rootVert});    
    vTraversed = false(1, size(mMst,1));
    
    while qPriority.size() > 0
        vHead = qPriority.poll();
        currVert = vHead(2);
        vTraversed(currVert) = true;
        vPermVerts(currIndex) = currVert;
        % find children + parents 
        vNeighs = find(mMst(currVert,:));

        for v = 1 : length(vNeighs)
            neighVert = vNeighs(v);
            if ~vTraversed(neighVert)
                qPriority.add({mDis(currVert, neighVert), neighVert});
            end
        end
        
        currIndex = currIndex + 1;
    end        

end % end of function