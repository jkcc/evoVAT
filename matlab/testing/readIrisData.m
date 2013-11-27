function [mData, vClass] = readIrisData(sFilename)
%
% Reads in the Iris data.
%
% sFilename -   Filename of the Iris data.
%
% @author: Jeffrey Chan, 2013
%

    fIris = fopen(sFilename);
    cData = textscan(fIris,'%f,%f,%f,%f,%s',152);
    
    mData = cat(2,cData{1}, cData{2}, cData{3}, cData{4});
    vClass = cData{5};

    fclose(fIris);
end % end of function