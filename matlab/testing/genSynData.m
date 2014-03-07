function [cmData, vClusLabels] = genSynData(sOption)
% Generate synthetic data for incVAT paper.
%
% @author: Jeffrey Chan, 2013
%


    % generate cluster for time one
    mSigma = [2,0; 0,2];
    vClusSize = [50, 50, 50];
    
    % generate first time step
    [mData, vClusLabels] = genOneTimeStep({[10,10], [25,10], [25,25]}, mSigma, vClusSize, 1);
    cmData = {mData};
        
    % visualisation properties
    cColourTime = {'b', 'r', 'g', 'c', 'y', 'm'};
    cShapeTime = {'o', 's', 'x', 'd', '+', 'h'};
    
    figure;
    hold on;
    scatter(mData(:,1), mData(:,2), 30, cShapeTime{1}, cColourTime{1});


    switch sOption
        case 'nomovement'
            % no movement
            [mData2, vClusLabels2] = genOneTimeStep({[10,10], [25,10], [25,25]}, mSigma, vClusSize, length(vClusSize) + 1);
            cmData = cat(1, cmData, mData2);
            vClusLabels = cat(2, vClusLabels, vClusLabels2);

            scatter(mData2(:,1), mData2(:,2), 30, cShapeTime{2}, cColourTime{2});  
            
        case 'onemovement'
            % third cluster move
            [mData2, vClusLabels2] = genOneTimeStep({[10,10], [25,10], [20,25]}, mSigma, vClusSize, length(vClusSize) + 1);
            cmData = cat(1, cmData, mData2);
            vClusLabels = cat(2, vClusLabels, vClusLabels2);

            scatter(mData2(:,1), mData2(:,2), 30, cShapeTime{2}, cColourTime{2});            
            
        case 'merge'
            % first and third cluster merge
            mSigma2 = [3,1.5; 1.5,3];
     
            [mData2, vClusLabels2] = genOneTimeStep({[16,20], [25,10]}, mSigma2, [100, vClusSize(2)], length(vClusSize) + 1);
            cmData = cat(1, cmData, mData2);
            vClusLabels = cat(2, vClusLabels, vClusLabels2);

            scatter(mData2(:,1), mData2(:,2), 30, cShapeTime{2}, cColourTime{2});                        
            
        case 'split'
            % second clustser split
            [mData2, vClusLabels2] = genOneTimeStep({[10,10], [20,10],[25,15], [25,25]}, mSigma, [vClusSize(1), 50,50, vClusSize(3)], length(vClusSize) + 1);
            cmData = cat(1, cmData, mData2);
            vClusLabels = cat(2, vClusLabels, vClusLabels2);

            scatter(mData2(:,1), mData2(:,2), 30, cShapeTime{2}, cColourTime{2});                
            
        case 'twomovement'
            % second and third move
            [mData2, vClusLabels2] = genOneTimeStep({[10,10],[25,5],[25,30]}, mSigma, vClusSize, length(vClusSize) + 1);
            cmData = cat(1, cmData, mData2);
            vClusLabels = cat(2, vClusLabels, vClusLabels2);

            scatter(mData2(:,1), mData2(:,2), 30, cShapeTime{2}, cColourTime{2});        
        case 'nomovement5time'
            % no movement for 5 time steps
            for t = 2 : 5
                [mData2, vClusLabels2] = genOneTimeStep({[10,10], [25,10], [25,25]}, mSigma, vClusSize, (t-1) * length(vClusSize) + 1);
                cmData = cat(1, cmData, mData2);
                vClusLabels = cat(2, vClusLabels, vClusLabels2);

                scatter(mData2(:,1), mData2(:,2), 30, cShapeTime{t}, cColourTime{t});              
            end
        otherwise
            error('%s is a unknown option.', sOption);
    end % end of case

    hold off;

end % end of function


function [mData, vClusLabels] = genOneTimeStep(cvClusMean, mSigma, vClusSize, startClusLabel)

    assert(length(cvClusMean) == length(vClusSize));
    
    % initialisation
    startIndex = 1;
    vClusLabels = zeros(1, sum(vClusSize));
    mData = [];
    
    for c = 1 : length(vClusSize)
        mDataClus = mvnrnd(cvClusMean{c}, mSigma, vClusSize(c));
        mData = cat(1, mData, mDataClus);
        
        vClusLabels(startIndex : startIndex + vClusSize(c) - 1) = startClusLabel + c - 1;
        startIndex = startIndex + vClusSize(c);         
    end
         
end % end of function