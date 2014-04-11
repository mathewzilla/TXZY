% This code runs the Naive Bayes (Maximum likelihood) classifier on data
% from the TXZY robot
% Puts all of the outputs in an array for easy copying into the paper.

%% BALL and CYLINDER dataset_10_04_2014
% 6 objects, 4 types (1 position, 3 finger pressures), 3 trials, 6 contacts
if ~exist('TXZY_dataI');
    clear all;
    load TXZY_dataI.mat
end

%% MAP

data = TXZY_dataI;
smoo = 1; deriv = 1;
fprintf('classifier prep for Naive Bayes classifier... \n')
clear class t_train t_test;
[data_train_c,data_test,indObject] = TXZY_class_prep(data,smoo,deriv);

% TRAIN AND TEST CLASSIFIER
fprintf('Running Naive Bayes classifier ')
[class,t_train,t_test] = TXZY_run_SNB(data_train_c,data_test);

% COMPUTE RESULTS
score = 100 * (sum (class(1:108) == indObject(1:108)))./108
errorO = class - indObject(1:108);
mean(abs(errorO))
std(abs(errorO))

