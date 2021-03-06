 % Script for loading data from the TXZY robot, looking at the data and,
% eventually, classifying the data


%% BOX and GLASS 10.04.14

while(0);
% Load data for inspection
load dataset_box_and_glass/test_box_1/test_position_sample_1_f1.txt
X1 = test_position_sample_1_f1;

load dataset_box_and_glass/test_box_1/test_pressure_sample_1_f1.txt
X2 = test_pressure_sample_1_f1;

load dataset_box_and_glass/test_box_2/test_position_sample_1_f1.txt
Y1 = test_position_sample_1_f1;

load dataset_box_and_glass/test_box_2/test_pressure_sample_1_f1.txt
Y2 = test_pressure_sample_1_f1;

load dataset_box_and_glass/test_glass_1/test_position_sample_1_f1.txt
Z1 = test_position_sample_1_f1;

load dataset_box_and_glass/test_glass_1/test_pressure_sample_1_f1.txt
Z2 = test_pressure_sample_1_f1;

load dataset_box_and_glass/test_glass_2/test_position_sample_1_f1.txt;
Q1 = test_position_sample_1_f1;

load dataset_box_and_glass/test_glass_2/test_pressure_sample_1_f1.txt;
Q2 = test_pressure_sample_1_f1;

% Plot data
figure(1);
subplot(2,4,1); plot(X1);
title('box 1');
subplot(2,4,5); plot(X2);

subplot(2,4,2); plot(Y1);
title('box 2');
subplot(2,4,6); plot(Y2);

subplot(2,4,3); plot(Z1);
title('glass 1');
subplot(2,4,7); plot(Z2);

subplot(2,4,4); plot(Q1);
title('glass 2');
subplot(2,4,8); plot(Q2);

% Plot histograms
figure(2);
subplot(2,4,1); hist(X1);
title('box 1');
subplot(2,4,5); hist(X2);

subplot(2,4,2); hist(Y1);
title('box 2');
subplot(2,4,6); hist(Y2);

subplot(2,4,3); hist(Z1);
title('glass 1');
subplot(2,4,7); hist(Z2);

subplot(2,4,4); hist(Q1);
title('glass 2');
subplot(2,4,8); hist(Q2);

% Plot histograms together
figure(3); clf;
subplot(1,2,1); x = hist(Q1); bar(x,'y'); hold all
subplot(1,2,2); x = hist(Q2); bar(x,'y'); hold all

subplot(1,2,1); x = hist(X1); bar(x,'r'); hold all
title('Position');
subplot(1,2,2); x = hist(X2); bar(x,'r'); hold all
title('Pressure');

subplot(1,2,1); x = hist(Y1); bar(x,'b');
subplot(1,2,2); x = hist(Y2); bar(x,'b');


subplot(1,2,1); x = hist(Z1); bar(x,'g');
subplot(1,2,2); x = hist(Z2); bar(x,'g');
end

%% BOX 1 04.04.14
while(0);
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
end