function [tAve,tStd] = streamDataVatNoIncre(sDataOption, windowSize,a)
%
% INPUT:
% sDataOption       - Option for the data stream input.
%
% OUTPUT:
%
    dataset = {'X1.mat','X2.mat','X3.mat','X4.mat','X5.mat','X6.mat','X7.mat','X8.mat','X9.mat','X10.mat'};
    tRep = 10;
    tMean = [];
    for index=1:10
    
   cmData = getData(sDataOption,dataset{index});
   

    % construct distance matrix
    mDis = squareform(pdist(cmData{1}(:,1:2), 'euclidean'));
    % construct original MST
    [mDis, ~, ~, ~, mMst] = Vat(mDis, false);
    %[mDis] = iVat(mDis);
    mExist = ones(size(mDis,1),size(mDis,2));
    tic;
    % feed in data, one slice at a time
    for t  = 2 : length(cmData)
        visualise = false;
        
        if t <= windowSize
            mCurrDis = squareform(pdist(cmData{t}(:,1:2),'euclidean'));
            origVert = [];
            for i = 1:(t-1)
                origVert = cat(1,origVert,cmData{i});
            end
            mNewDis = pdist2(origVert(:,1:2),cmData{t}(:,1:2),'euclidean');
            mNewPtsDis = cat(1,mNewDis,mCurrDis);
            mDis = [mDis mNewDis];
            mDis = [mDis;[mNewDis' mCurrDis]];
            [~, ~, ~, ~, mMst] = Vat(mDis, visualise);
            
            %[mDis, mMst, ~, vNewRoot, mExist] = incVat(a,mDis, mExist, mMst, mNewPtsDis, visualise);
            
            %[mDis, mMst, mExist] = incVatRebuit(mDis, mExist, mNewPtsDis,visualise);
          
        % remove points that fall outside the window
        else
            if windowSize == 1
                mDis = squareform(pdist(cmData{t}(:,1:2), 'euclidean'));
                [mDis, vRearrangedVert, ~, ~, mMst] = Vat(mDis, visualise);  
            else
                % delete points that were in cmData{t-windowSize}
                %vPointsToDel = 1 : length(cmData{t-windowSize});
                vPointsToDel = 1 : size(cmData{t-windowSize},1);
            
                % remove from MST
                %[mDis,vRearrangedVert,mMst,mExist,vNewRoot] = deincVat(mDis,mMst,mExist,vPointsToDel,false);
                [mDis,vRearrangedVert,mMst,mExist,vNewRoot] = deincVatNoMst(mDis,mMst,mExist,vPointsToDel,false);
                %[mDis,mExist] = deincVatNoMst(mDis,mExist,vPointsToDel);
                
                % compute new distances
               mCurrDis = squareform(pdist(cmData{t}(:,1:2), 'euclidean'));
                origVert = [];
                for i = (t-windowSize+1):(t-1)
                    origVert = cat(1,origVert,cmData{i});
                end
                mNewDis = pdist2(origVert(:,1:2),cmData{t}(:,1:2),'euclidean');
                mNewPtsDis = cat(1,mNewDis,mCurrDis);
                
                mDis = [mDis mNewDis];
                mDis = [mDis;[mNewDis' mCurrDis]];
                [~, ~, ~, ~, mMst] = Vat(mDis, visualise);
                
                %[mDis, mMst, mExist] = incVatRebuit(mDis, mExist, mNewPtsDis,visualise);
         
                %[mDis, mMst, vRearrangedVert, vNewRoot, mExist] = incVat(a,mDis, mExist, mMst, mNewPtsDis, visualise);
               
            end % end of if windowSize == 1
        end % end of if t <= windowSize
    end % end of for loop
    total = toc;
    tMean = [tMean total / tRep];
    end
    tAve = mean(tMean);
    tStd = std(tMean);
end % end of function