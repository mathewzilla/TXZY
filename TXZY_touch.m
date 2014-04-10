 % Script for loading data from the TXZY robot, looking at the data and,
% eventually, classifying the data


% BOX 1

cd box_1;
for i = 1:5;
    for j = 1:3;
        filename = (['box_sample_' num2str(i) '_f' num2str(j) '.txt']);
        eval load num2str(filename)
        
    end
end


load box_1/box_sample_1_f1.txt
X = box_sample_1_f1;

clear box_sample_1_f1

load box_2/box_sample_1_f1.txt
Y = box_sample_1_f1;

subplot(2,2,1); plot(X/max(max(X)));
subplot(2,2,2); hist(X/max(max(X)));
subplot(2,2,3); plot(Y/max(max(Y)));
subplot(2,2,4); hist(Y/max(max(Y)));