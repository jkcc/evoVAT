classdef DisAlgorSeparate
    %
    % Treat the spatial and time distances separately
    %
    
    properties
        
    end
    
    
    methods
        function [obj] = DisAlgorSeparate()
        
        end % end of constructor
        
        
        function [mNewPtsDis, mAge, vPointAge] = computeNewDis(obj, mCurrData, mPastData, currTime, vPointAge, mAge)
            
            % age
            mAge = cat(2, mAge, currTime * ones(size(mPastData,1), size(mCurrData,1)));
            mTemp = cat(2, currTime * ones(size(mCurrData,1), size(mPastData,1) + size(mCurrData,1)));
            mAge = cat(1, mAge, mTemp);       
            
            mCurrDis = squareform(pdist(mCurrData,'euclidean'));
%             origVert = [];
%             for i = 1:(t-1)
%                 origVert = cat(1,origVert,cmData{i});
%             end
            mNewDis = pdist2(mPastData, mCurrData,'euclidean');
            mNewPtsDis = cat(1,mNewDis,mCurrDis);
            
            vPointAge = cat(1, vPointAge, currTime * ones(size(mCurrData,1),1));            
%             
%             mCurrDis = squareform(pdist(cmData{t}(:,1:2),'euclidean'));
%             origVert = [];
%             for i = 1:(t-1)
%                 origVert = cat(1,origVert,cmData{i});
%             end
%             mNewDis = pdist2(origVert(:,1:2),cmData{t}(:,1:2),'euclidean');
%             mNewPtsDis = cat(1,mNewDis,mCurrDis);
           
        end % end of function
        
    end % end of methods
    
end % end of class