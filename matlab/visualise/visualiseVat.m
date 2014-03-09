function visualiseVat(mDis, vRearrangedVert, sHeading, fIntensityMap, varargin)
%
% Visualise the VAT image.
%
% @author: Jeffrey Chan, 2013
%

    inParser = inputParser;
    % default values
    defaultCMap = hsv;
    
    addOptional(inParser, 'cmap', defaultCMap);
    addOptional(inParser, 'backgroundColour',[1,1,1]); 
    addOptional(inParser, 'visualiseLabels', false);
    addOptional(inParser, 'genFigure', true);
    addOptional(inParser, 'ageData', []);
    
    parse(inParser, varargin{:});
    
    cmap = inParser.Results.cmap;
    vBackColour = inParser.Results.backgroundColour;
    bGenFigure = inParser.Results.genFigure;
    bVisualiseLabels = inParser.Results.visualiseLabels;
    mAge = inParser.Results.ageData;

    if bGenFigure
        figure;
        hold on;
    end
    
    % have age data so use it for alpha values
    if ~isempty(mAge)
        colourAlphaImagesc(mDis(vRearrangedVert, vRearrangedVert), mAge(vRearrangedVert, vRearrangedVert), cmap, fIntensityMap, vBackColour);
    else   
        imagesc(mDis(vRearrangedVert, vRearrangedVert));
        colormap(cmap);

    end
    
    xlim([0,length(vRearrangedVert)]);
    ylim([0,length(vRearrangedVert)]);
    title(sHeading);
    
    % see if we want to visualise the labels 
    if bVisualiseLabels
        set(gca,'XTickLabel', vRearrangedVert);
        set(gca,'YTickLabel', vRearrangedVert);
        set(gca,'XTick', 1:length(vRearrangedVert));
        set(gca,'YTick', 1:length(vRearrangedVert));
    end
    
    if bGenFigure
        hold off;
    end
       
end % end of function