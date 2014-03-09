classdef ExpIntensityMapper
    %
    % Compute the intensity given the normalised time values, using a
    % expontential expolation between m_minIntensity and m_maxIntensity.
    %
    % @author: Jeffrey Chan, 2013
    %
    
    properties
        m_minIntensity = 0;
        m_maxIntensity = 1;
        
        % convenience
        m_logIntensityDiff = 1;
    end % end of properites
    
    methods
        function [obj] = ExpIntensityMapper(minIntensity, maxIntensity)
            obj.m_minIntensity = minIntensity;
            obj.m_maxIntensity = maxIntensity;
            
            obj.m_logIntensityDiff = log(maxIntensity - minIntensity);
        end
        
        
        function [mIntensity] = computeIntensity(obj, mNormTime)
            minTime = min(min(mNormTime));
            maxTime = max(max(mNormTime));
            
            exponent = log(exp(maxTime) - exp(minTime)) - obj.m_logIntensityDiff;
            intercept = obj.m_maxIntensity - exp(exponent * maxTime);
            
%             mIntensity = exp(exponent * mNormTime) + intercept;
            mIntensity = max(min(exp(exponent * mNormTime) + intercept, obj.m_maxIntensity), obj.m_minIntensity);
        end % end of function
    end % end of methods
    
end % end of class