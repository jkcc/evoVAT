 
clear;
clc;

CurrentState = 1;
CurrentColor = '.r';
counter = 1;
ElliNum = 0;
Label = [];

for samplenum = 1:10
    X = [];
    StateVector = [];
   
    for counter = 1 : 10 % timestep

        % Call the related function based on CurrentState
        % onset the state changes it refresh the distributions
        
        %x = 18 + (counter-1)*1.7;
        %y = 26 - (counter-1)*0.6;
        
        %randomScalar = (samplenum-1)*rand(1);
        
        x = [18+samplenum 38+samplenum 35+samplenum 20+samplenum 40+samplenum 10+samplenum 45+samplenum 27+samplenum 50+samplenum 25+samplenum];
        y = [26+samplenum 40+samplenum 20+samplenum 50+samplenum 10+samplenum 43+samplenum 30+samplenum 60+samplenum 45+samplenum 35+samplenum];
        
        a = randperm(10);
        
        for m = 1:5
            x(a(m)) = x(a(m)) + 10;
            y(a(m)) = y(a(m)) + 10;
        end
        
        %x = 18;
        %y = 26;
  
            [MatA1 CenterA1]= GenEllipse(1,2,[x(1) y(1)]); % 10 2Dim. ellipse around point [18 26]
            [MatA2 CenterA2]= GenEllipse(1,2,[x(2) y(2)]);
            [MatA3 CenterA3]= GenEllipse(1,2,[x(3) y(3)]);
            [MatA4 CenterA4]= GenEllipse(1,2,[x(4) y(4)]);
            [MatA5 CenterA5]= GenEllipse(1,2,[x(5) y(5)]);
            [MatA6 CenterA6]= GenEllipse(1,2,[x(6) y(6)]);
            [MatA7 CenterA7]= GenEllipse(1,2,[x(7) y(7)]);
            [MatA8 CenterA8]= GenEllipse(1,2,[x(8) y(8)]);
            [MatA9 CenterA9]= GenEllipse(1,2,[x(9) y(9)]);
            [MatA10 CenterA10]= GenEllipse(1,2,[x(10) y(10)]);
            
            MatA = cat(1,MatA1,MatA2,MatA3,MatA4,MatA5,MatA6,MatA7,MatA8,MatA9,MatA10);
            CenterA = [CenterA1;CenterA2;CenterA3;CenterA4;CenterA5;CenterA6;CenterA7;CenterA8;CenterA9;CenterA10];
            ElliNum = 10;
            Label = [1 2 3 4 5 6 7 8 9 10]; % cluster label
        
        count =round(400/length(Label)); % number of points in each cluster
        for i=1:1:length(Label)
        % Generate data from the ellipses by using Mixture of Gaussian Distribution
            MU1 = CenterA(i,:);
            SIGMA1 = inv(squeeze(MatA(i,:,:)));
%             count = round(100+50*rand(1,1));
            X = [X;mvnrnd(MU1,SIGMA1,count) repmat(counter,count,1) repmat(Label(i),count,1)];
            StateVector = [StateVector repmat(CurrentState, 1, count)] ;
            
            Ellipse_Plot(squeeze(MatA(i,:,:)),CenterA(i,:),i);
            hold on;
            
        
        end
    end
    
    plot(X(:,1),X(:,2),CurrentColor);
    hold on;

    save(sprintf('Database/X%d',samplenum),'X');
    save(sprintf('Database/StateVector%d',samplenum),'StateVector');
end
% hold off;
% %
% 
% plot ( StateVector, 'LineWidth',4);
% xlabel('Generated Date');
% ylabel('State');
% title('Transition of States');
% axis([1 length(StateVector) 1 2]);