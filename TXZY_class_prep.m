function [data_train_c,data_test,indObject] = TXZY_class_prep(data,smoo,deriv)
% Preparation of datasets into appropriate training and test sets.

%% TXZY BALL and CYLINDER dataset_10_04_2014
% 6 objects, 4 types (1 position, 3 finger pressures), 3 trials, 6 contacts
    [nc1,nc2,ni] = size(data);     % [nt(1),nn] = size(data{1,1}); % 3,3,8 | 2001,2
    
    ri = 1:ni;         % 1 to 6 contacts
    rc1 = 1:1:nc1;     % 1 to 6 objects
    rc2 = 1:1:nc2;     % 1 to 4 data types
    
    nc = nc1*nc2;      % total sample number per set - 9
    rc = 1:nc;         % 1 to 9
    subs = 1:7;        % subset for training set. Trial 1 will be left out
    st = 1000;         % length of peak-aligned segment
    
    [nt(2),nn] = size(data{1,2});
    [nt(3),nn] = size(data{1,3});
    for c1 = rc1
        for c2 = rc2
            for i = ri
                t(c1,c2,i) = min(find(data{c1,c2,i}(:,1)>0.4))-100;
                
                %% OPTION: Take derivatives
                if deriv == 1;
                    data{c1,c2,i} = diff(data{c1,c2,i});
                    data{c1,c2,i}(nt(1)-1,:) = data{c1,c2,i}(nt(1)-2,:);% Fill in missing end value
                    data{c1,c2,i}(nt(1),:) = data{c1,c2,i}(nt(1)-1,:);
                end
                
                if deriv == 2;
                    data{c1,c2,i} = diff(diff(data{c1,c2,i}));
                    data{c1,c2,i}(nt(1)-2,:) = data{c1,c2,i}(nt(1)-3,:);% Fill in missing end value
                    data{c1,c2,i}(nt(1)-1,:) = data{c1,c2,i}(nt(1)-2,:);
                    data{c1,c2,i}(nt(1),:) = data{c1,c2,i}(nt(1)-1,:);
                end
                
                %% OPTION: Smooth
                if smoo == 1;
                    g = @(n,si) exp(-(-n:n).^2/(2*si^2))/sum( exp((-n:n).^2/(2*si^2)) );
                    data{c1,c2,i} = filter(g(50,15)/sum(g(50,15)),1,data{c1,c2,i});
                end
                
            end
        end
    end
    

    %% Concatenated files, if classifier needs it
    
    c = 0;
    for c1 = rc1
        for c2 = rc2
            c = c + 1; data_train_c{c} = [];
            for k = subs
                rt = t(c1,c2,k+1)+(1:st);
                data_train_c{c} = [data_train_c{c};data{c1,c2,k+1}(rt,1)]; % was (rt,1)
                
            end
        end
    end
    
    %% Test data: truncate
    c = 0;
    for c1 = rc1
        for c2 = rc2
            c = c + 1; data_test{c} = [];
            for l = 1
                rt = t(c1,c2,l)+(1:st);
                data_test{c} = [data_test{c};data{c1,c2,l}(rt,1)]; % was (rt,1)
                test(c) = c;
            end
        end
    end
    
end



