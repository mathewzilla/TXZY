% Script to plot data from the TXZY robot for inspection

%clear all; load TXZY_data.mat

% Plotting
for i = 1:6;
    for j = 1:3;
        figure(1); plot(TXZY_data{i,1,j})
        figure(2); plot(TXZY_data{i,2,j})
        figure(3); plot(TXZY_data{i,3,j})
        figure(4); plot(TXZY_data{i,4,j})
        drawnow;
        pause (0.5);
    end
end
