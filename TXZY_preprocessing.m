% Script to load data from the TXZY robot and place into matrices for ML
% classification.

%% BALL and CYLINDER dataset_10_04_2014
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

while(0);
%dataset_10_04_2014/ball_1/
ball_1_position_sample_1_f1.txt
ball_1_position_sample_2_f1.txt
ball_1_position_sample_3_f1.txt
ball_1_pressure_sample_1_f1.txt
ball_1_pressure_sample_1_f2.txt
ball_1_pressure_sample_1_f3.txt
ball_1_pressure_sample_2_f1.txt
ball_1_pressure_sample_2_f2.txt
ball_1_pressure_sample_2_f3.txt
ball_1_pressure_sample_3_f1.txt
ball_1_pressure_sample_3_f2.txt
ball_1_pressure_sample_3_f3.txt

%dataset_10_04_2014/ball_2/
ball_2_position_sample_1_f1.txt
ball_2_position_sample_2_f1.txt
ball_2_position_sample_3_f1.txt
ball_2_pressure_sample_1_f1.txt
ball_2_pressure_sample_1_f2.txt
ball_2_pressure_sample_1_f3.txt
ball_2_pressure_sample_2_f1.txt
ball_2_pressure_sample_2_f2.txt
ball_2_pressure_sample_2_f3.txt
ball_2_pressure_sample_3_f1.txt
ball_2_pressure_sample_3_f2.txt
ball_2_pressure_sample_3_f3.txt


%dataset_10_04_2014/ball_3/
ball_3_position_sample_1_f1.txt
ball_3_position_sample_2_f1.txt
ball_3_position_sample_3_f1.txt
ball_3_pressure_sample_1_f1.txt
ball_3_pressure_sample_1_f2.txt
ball_3_pressure_sample_1_f3.txt
ball_3_pressure_sample_2_f1.txt
ball_3_pressure_sample_2_f2.txt
ball_3_pressure_sample_2_f3.txt
ball_3_pressure_sample_3_f1.txt
ball_3_pressure_sample_3_f2.txt
ball_3_pressure_sample_3_f3.txt

%dataset_10_04_2014/cylinder_1/
cylinder_1_position_sample_1_f1.txt
cylinder_1_position_sample_2_f1.txt
cylinder_1_position_sample_3_f1.txt
cylinder_1_pressure_sample_1_f1.txt
cylinder_1_pressure_sample_1_f2.txt
cylinder_1_pressure_sample_1_f3.txt
cylinder_1_pressure_sample_2_f1.txt
cylinder_1_pressure_sample_2_f2.txt
cylinder_1_pressure_sample_2_f3.txt
cylinder_1_pressure_sample_3_f1.txt
cylinder_1_pressure_sample_3_f2.txt
cylinder_1_pressure_sample_3_f3.txt

%dataset_10_04_2014/cylinder_2/
cylinder_2_position_sample_1_f1.txt
cylinder_2_position_sample_2_f1.txt
cylinder_2_position_sample_3_f1.txt
cylinder_2_pressure_sample_1_f1.txt
cylinder_2_pressure_sample_1_f2.txt
cylinder_2_pressure_sample_1_f3.txt
cylinder_2_pressure_sample_2_f1.txt
cylinder_2_pressure_sample_2_f2.txt
cylinder_2_pressure_sample_2_f3.txt
cylinder_2_pressure_sample_3_f1.txt
cylinder_2_pressure_sample_3_f2.txt
cylinder_2_pressure_sample_3_f3.txt

%dataset_10_04_2014/cylinder_3/
cylinder_3_position_sample_1_f1.txt
cylinder_3_position_sample_2_f1.txt
cylinder_3_position_sample_3_f1.txt
cylinder_3_pressure_sample_1_f1.txt
cylinder_3_pressure_sample_1_f2.txt
cylinder_3_pressure_sample_1_f3.txt
cylinder_3_pressure_sample_2_f1.txt
cylinder_3_pressure_sample_2_f2.txt
cylinder_3_pressure_sample_2_f3.txt
cylinder_3_pressure_sample_3_f1.txt
cylinder_3_pressure_sample_3_f2.txt
cylinder_3_pressure_sample_3_f3.txt
end