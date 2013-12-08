classdef DisAlgorLinear
    %
    % Combine the spatial and time distances into the spatial distance.
    %
    
    properties
        m_alpha = 1;
    end
    
    
    methods
        function [obj] = DisAlgorLinear(alpha)
            obj.m_alpha = alpha;
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
            mNewDis = pdist2(mPastData, mCurrData,'euclidean') +...
                obj.m_alpha * pdist2(vPointAge, currTime * ones(size(mCurrData,1),1), 'cityblock');
            mNewPtsDis = cat(1,mNewDis,mCurrDis);
            
            vPointAge = cat(1, vPointAge, currTime * ones(size(mCurrData,1),1));
                    
        end % end of function
        
    end % end of methods
    
end % end of class