classdef AlignSeqAbsDiff
    %
    % Align the sequence using the absolute difference as the measure.
    %
    % @author: Jeffrey Chan
    %
    
    properties
        % Map of vertex -> its order/rank in sequence.
        m_vPrevVertOrder = [];
    end
        
    methods
        function obj = AlignSeqPos(vPrevSeq)
            obj.m_vPrevVertOrder = vPrevSeq;
        end % end of constructor
        
        function rootVert = getRootVert(obj)
            rootVert = find(obj.m_vPrevVertOrder == 1);
        end
        
        
        function vNewCost = alignCost(obj, vExistVertSeq, vNewVert)
            % Return the align costs for appending each vertex in vNewVert to
            % the sequence vExistVertSeq.
            %
            % This version recomputes the whole sequence each time.
            %
            % INPUT:
            % vExistVertSeq     - (Vector of vertices) The sequence of vertices
            %                       that occupy the first length(vExistVertSeq) positions in the
            %                       compared sequence.
            % vNewVert          - (Vector of vertices) The set of vertices that 
            %                       we wish to evaluate after appending to
            %                       vExistVertSeq.
            %
            
            existCost = abs(obj.m_vPrevVertOrder(vExistVertSeq) - 1:length(vExistVertSeq) );
            vNewCost = abs(obj.m_vPrevSeq(vNewVert) - (length(vExistVertSeq) + 1) ) + existCost;
            
        end % end of function
    end
    
end % end of class