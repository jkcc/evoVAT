%visualise vat in different k
row = 0;
for i=0.5:0.5:3 % k
    for j=1:12 % visualise a vat in number of j
        subplot(6,12,(12*row)+j), streamDataVatSubplot('mahsaSyn',2,i,j);
    end
    row = row + 1;
end



    