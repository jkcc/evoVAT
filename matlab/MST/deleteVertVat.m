function [mNewMst,mNewDis,vRootVert,mNewExist] =  deleteVertVat(mMst, mDis, mExist, delVert)
%
% Uses a brute force approach to delete a vertex from an MST.
%
% ***Input ****
% mMst      - Existing minimal spanning tree, in adjacency matrix format.
% rootVert  - Root vertex of MST.
% mDis      - Distance matrix.
% mExist    - Matrix indicating which edge exists in mDis.
% delVert   - Vertex to delete from MST.
%
% ***Output***
% vNewMst   - New MST with delVert removed from it.
%
    % delete the delVert column and row of mDis
    mDis(delVert,:) = [];
    mDis(:,delVert) = [];
    mNewDis = mDis;
    
    [y,i]=max(mNewDis);
    [~,j]=max(y);
    vRootVert = i(j);
    
    mExist(delVert,:) = [];
    mExist(:,delVert) = [];
    mNewExist = mExist;
    
    % delete the delVert column and row of mMst
    tempMst = mMst;
    tempMst(delVert,:) = [];
    tempMst(:,delVert) = [];
    
    % obtain the connected components
    [comNum,series] =  graphconncomp(sparse(tempMst));
    
    if comNum == 1  % if the delVert is a leaf vertex
       mNewMst = tempMst;
    else  % the number of remainning components is greater than 2
        mNewMst = zeros(size(tempMst,1),size(tempMst,2));   % initialize mNewMst
        
        % copy the original MST chunk by chunk
        for i = 1:comNum
            tree = find(series == i);
            for j = 1:length(tree)
                for k = 1:length(tree)
                    mNewMst(tree(j),tree(k)) = tempMst(tree(j),tree(k));
                end
            end
        end
        
        % update MST
        while comNum >1  
            % a cell to store vertices of each component
            componentCell = cell(comNum,1);
            for i = 1:comNum
                componentCell{i} = find(series == i);
            end
            
            % a matrix to store smallest distance between each component
            distances = [];
            for i = 1:(comNum-1)
                for j = (i+1):comNum
                    dis = findAllMin(componentCell{i},componentCell{j},mDis);
                    distances = cat(1,distances,dis);
                end
            end
            [~,minIndex] = min(distances(:,3)); % find the minimum distance
            mNewMst(distances(minIndex,1),distances(minIndex,2)) = 1; % update MST
            [comNum,series] = graphconncomp(sparse(mNewMst)); % get the connected components of updated MST
        end 
    end
end % end of function

function minEdge = findMin(vert,component,mDis)
% 
% find the minimum edge between a vertex and a component
%
    minValue = mDis(vert,component(1));
    tarVert = component(1);
    if length(component) == 1
        minEdge = [vert,tarVert,minValue];
    else
        for i = 2:length(component)
            if minValue > mDis(vert,component(i));
               minValue = mDis(vert,component(i));
               tarVert = component(i);
            end
        end
        minEdge = [vert,tarVert,minValue];
    end
end

function aMinEdge = findAllMin(tree1,tree2,mDis)
%
% find the minimum edge between two components
%
    minEdge = findMin(tree1(1),tree2,mDis);
    minValue = minEdge(3);
    aTarVert = minEdge(2);
    aSrcVert = minEdge(1);
    if length(tree1) == 1
        aMinEdge = minEdge;
    else
        for i = 2:length(tree1)
            minEdge2 = findMin(tree1(i),tree2,mDis);
            if  minValue > minEdge2(3)
                minValue = minEdge2(3);
                aTarVert = minEdge2(2);
                aSrcVert = minEdge2(1);
            end
        end
        aMinEdge = [aSrcVert,aTarVert,minValue];
    end
end















