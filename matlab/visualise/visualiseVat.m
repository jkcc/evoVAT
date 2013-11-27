function visualiseVat(mDis, vRearrangedVert, sHeading, varargin)
%
% Visualise the VAT image.
%
% @author: Jeffrey Chan, 2013
%
    % default cmap
    cmap = hsv;
    bVisualiseLabels = false;
    
    % check optional arguments
    switch length(varargin)
        case 1
            cmap = varargin{1};
        case 2
            cmap = varargin{1};
            bVisualiseLabels = varargin{2};
        case 3
            cmap = varargin{1};
            bVisualiseLabels = varargin{2};            
            bSubplot = varargin{3};
        otherwise
    end % end of switch
        
    if ~bSubplot
        figure;
        hold on;
        colormap(cmap);
    end
    imagesc(mDis(vRearrangedVert, vRearrangedVert));
    title(sHeading);
    
    if bVisualiseLabels
        set(gca,'XTickLabel', vRearrangedVert);
        set(gca,'YTickLabel', vRearrangedVert);
        set(gca,'XTick', 1:length(vRearrangedVert));
        set(gca,'YTick', 1:length(vRearrangedVert));
    end
    
    if ~bSubplot
        hold off;
    end
       
end % end of function