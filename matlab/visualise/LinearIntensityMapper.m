classdef LinearIntensityMapper
    %
    % Compute the intensity given the normalised time values, using a linear
    % expolation between m_minIntensity and m_maxIntensity.
    %
    % @author: Jeffrey Chan, 2013
    %
    
    properties
        m_minIntensity = 0;
        m_maxIntensity = 1;
        
    end % end of properites
    
    methods
        function [obj] = LinearIntensityMapper(minIntesity, maxIntensity)
            obj.m_minIntensity = minIntesity;
            obj.m_maxIntensity = maxIntensity;
        end
        
        
        function [mIntensity] = computeIntensity(obj, mNormTime)
            mIntensity = min((mNormTime * (obj.m_maxIntensity - obj.m_minIntensity)) + obj.m_minIntensity, obj.m_maxIntensity);
        end % end of function
    end % end of methods
    
end % end of class