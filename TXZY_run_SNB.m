% TXZY_run_SNB script to run the Naive Bayes classifer. Provides class
% predictions and clocked times

function [class,t_train,t_test] = TXZY_run_SNB(data_train_c,data_test);
%% TRAINING


d = linspace(-350,250,1000); d = d(:); % set params for histogram, then rotate
ns = 10;                              % smooth over 10 samples
clear logl;
tic
fprintf(' ... Training ... \n')
for c = 1:length(data_train_c);
    logl{c} = TXZY_train_SNB(data_train_c{c},d,ns);
end
t_train = toc;

%% TESTING

% Old code
clear logp;
tic
fprintf('Testing ... \n')
% RUNNING ON POSITION DATA ONLY

for c = 1:108; %length(data_test);
    for c1 = 1:6; %length(data_train_c);
        logp{c}(c1) = TXZY_test_SNB(data_test{c},d,logl{c1});
    end
    [ig,class(c)] = max(squeeze(logp{c}),[],2);
end
t_test = toc;
