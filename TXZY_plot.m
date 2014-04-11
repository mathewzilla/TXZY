% Script to plot data from the TXZY robot for inspection

if ~exist('plotting');
    task = input('Press 1 to plot data from raw whole trials, Press 2 plot individual contacts: \n ');
end

% Plotting
if plotting == 1;
    if ~exist('TXZY_data');
        clear all;
        load TXZY_data.mat
    end
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
end

if plotting == 2;
    if ~exist('TXZY_dataI');
        clear all;
        load TXZY_dataI.mat
    end
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
end