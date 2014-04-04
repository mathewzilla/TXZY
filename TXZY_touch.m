% Script for loading data from the TXZY robot, looking at the data and,
% eventually, classifying the data


% BOX 1

cd box_1;
for i = 1:5;
    for j = 1:3;
        filename = (['box_sample_' num2str(i) '_f' num2str(j) '.txt']);
        lseval load num2str(filename)
        
    end
end