% Script to load data from the TXZY robot and place into matrices for ML
% classification. Task option defines whether the code preprocesses data
% from raw, or sorts into contacts.

if ~exist('task');
    task = input('Press 1 to re-load data from raw files, Press 2 to divide into contacts: \n ');
end

if ~exist('TXZY_data');
    load TXZY_data.mat
end

%% BALL and CYLINDER dataset_10_04_2014
if task == 1;
    clear all
    objects = {'ball_1','ball_2','ball_3','cylinder_1','cylinder_2','cylinder_3'};
    datatype = {'position','pressure','pressure','pressure'};
    finger = {'f1','f1','f2','f3'};
    TXZY_data = cell(6,4,3); % 6 objects, 4 types (one position, 3 finger pressures), 3 samples. All files are X by variable length
    for i = 1:6; % objects
        for j = 1:4 % datatype
            for k = 1:3 %sample
                eval ([' load dataset_10_04_2014/' objects{i} '/' objects{i} '_' datatype{j} '_sample_' num2str(k) '_' finger{j} '.txt;']);
                eval ([' X = ' objects{i} '_' datatype{j} '_sample_' num2str(k) '_' finger{j} ';']);
                eval ([' clear ' objects{i} '_' datatype{j} '_sample_' num2str(k) '_' finger{j} ';']);
                TXZY_data{i,j,k} = X;
            end
        end
    end
    save TXZY_data.mat TXZY_data
end



if task == 2;
    
    TXZY_dataI = cell(6,4,3,6); % individual contacts, all of the same length
    for i = 1:6;
        for j = 1:4;
            for k = 1:3;
                
                X = TXZY_data{i,2,k};
                contacts = [];
                for n = 1:length(X);
                    if X(n,1) < -10;
                        contacts = [contacts;n];
                    end;
                end;
                
                c = contacts;
                
                for m = 1:6;
                    TXZY_dataI{i,j,k,m} = TXZY_data{i,j,k}(c(m)-155 : c(m)-5);
                end
                
                
            end
        end
    end
    
    save TXZY_dataI.mat TXZY_dataI
    
end
