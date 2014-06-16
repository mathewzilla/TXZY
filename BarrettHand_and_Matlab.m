    close all
clear all
clc

LoadYarp;
import yarp.BufferedPortBottle
import yarp.Port
import yarp.Bottle
import yarp.Network
import yarp.Vector
import yarp.*

if true
  
    clear

%    path = '..';
    name = 'realtime_simulation';
%    name = 'data_200113_50';
%    path = [path filesep name];
    path = [name];

    % load state from expt
    load([path filesep 'expt.mat'], 'expt');
    expt.rootpath = '';
    expt.path = path;

    % some variables
    ncs = length(expt.classes);
    nxydws = length(expt.xs)*length(expt.ys)*length(expt.ds)*length(expt.ws);
    nwhisks = expt.nwhisks;
    disp(['Classes: ' num2str(ncs) '; Subclasses: ' num2str(nxydws) '; Taps per class: ' num2str(nwhisks)]);
    
    % only test with last Nwhisks
    Nwhisks = nwhisks;

    % parameters
    state.cond = expt;
    %   state.logth_xydw = 0.5;
    %   state.logth_c = 0.5;
    state.ix_des = 11;
    state.iy_des = 1;
    state.id_des = 1;
    state.iw_des = 1;

    % figure and text output
    state.nofig = true;
    state.notext = true;

    % is data stored?
    expt.store = true;

    % load classifier from pclass
    run_classifier(expt, Nwhisks, '_finger_train');
    load([expt.path '/pclass_finger_train.mat'], 'p', 'd')

    disp([expt.path '/pclass_ifinger_train.mat']);

    state.classifier.p = p;
    state.classifier.d = d;

    disp('training data (p and d parameters) ready!');

end


% start communication with Matlab

remoteWritePort = '/matlab/write/taxels/o:';
remoteReadPort = '/matlab/read/decision/i:';
localWritePort = '/matlab/write/decision/o:';
localReadPort = '/matlab/read/taxels/i:';

%remoteAbortPort = '/matlab/write/abort/o:';
%localAbortPort = '/matlab/read/abort/i:';


%inputPort = Port;
inputPort = BufferedPortBottle;
inputAbortPort = BufferedPortBottle;
outputPort = Port;
inputBottle = Bottle;
%inputAbortBottle = Bottle;
outputBottle = Bottle;
inputPort.close;
outputPort.close;

inputPort.open(localReadPort);
outputPort.open(localWritePort);
%inputAbortPort.open(localAbortPort);

Network.connect(remoteWritePort, localReadPort);
Network.connect(localWritePort, remoteReadPort);
%Network.connect(remoteAbortPort, localAbortPort);

% initialise parameters
output_all = {};
% threshold classes
logths_c = log(0.8);
nths_c = length(logths_c);
% threshold subclasses
logths_xydw = log(0.8);
nths_xydw = length(logths_xydw);

ic = 1;
limitExplorationTaps = 1000; %1000
output.ic_likelihood_histogram = cell(1,length(limitExplorationTaps));
output.ixydw_likelihood_histogram = cell(1,length(limitExplorationTaps));

for i = 1:limitExplorationTaps

% set thresholds (state)
state.logth_xydw = logths_xydw(1);
state.logth_c = logths_c(1);

% initialize outputs
output.ic = [];
output.ixydw = [];
output.e_c = cell(ncs, nxydws);
output.e_xydw = cell(ncs, nxydws);

firstTap = true;
ixydw = state.ix_des;
counter = 0;

if( firstTap )
    % set state
    state.ic = ic;
    state.ixydw_init = ixydw;
    firstTap = false;
end

% initialize position history
ixydw_history = [];

% start up machine
machine = machine_actSA(state);

% Information from machine
result.ixydw = state.ixydw_init;
result.continue = 1;
result.whereCondition = 0;

x_classes = 1:1:72;
x_subclasses = 1:1:20;
hf1 = figure(1);
bar(x_classes, machine.p_c_history(:,1));
hf2 = figure(2);
bar(x_subclasses, machine.p_xydw_history(:,1));


    while result.continue
        % position history
        ixydw_history(end+1) = result.ixydw;

        % starts reading tactile data from C++
        outputBottle.addString('startTask');
        outputPort.write(outputBottle);
        outputBottle.clear();
        
        % waiting for tactile data
        inputBottle = inputPort.read(true);
        inputBottle.get(0).asString();

            tactileData = zeros(101,12);
        while( strcmp(inputBottle.get(0).asString(),'fullBottle') )
            text = inputBottle.get(0).asString();
            row = inputBottle.get(1).asInt();
            col = inputBottle.get(2).asInt();
            value = inputBottle.get(3).asDouble();
            tactileData(row, col) = value;
                
            outputBottle.addString('continueTask');
            outputPort.write(outputBottle);
            outputBottle.clear();
            
            counter = counter + 1;
            inputBottle = inputPort.read(true);
        end
                        
        if( counter == 0 )
            tactileData = zeros(101,12);
        else
            counter = 0;
        end
        % get tactile data from new tap
        
        % step machine
        disp(['Information for STEP-MACHINE: class = ' num2str(ic) ' , ixydw = ' num2str(ixydw)]);
        result = step(machine, tactileData);
        
        if( result.whereCondition == 1 )
                ixydw = result.ixydw;
                shiftPosition = result.shift_ixydw; 
                result.whereCondition = 0;
        else
                ixydw = result.ixydw_est;
%                ixydw = result.ixydw_est + (randi([-5 5],1,1)/10.0);
                shiftPosition = 0;
        end
        
        ic = result.ic_est;
        
        if( result.continue )
            % here is the code for position movemen
            outputBottle.addString('positionMovement');
            outputBottle.addDouble(ic-1);
            outputBottle.addDouble(ixydw-1);
            outputBottle.addDouble(shiftPosition);
            outputPort.write(outputBottle);
            outputBottle.clear();
        else
            disp('##### Decision takeen :) #####');
        end
                
        clf(hf1);
        hf1 = figure(1);
        bar(x_classes, machine.p_c_history(:,end));
        clf(hf2);
        hf2 =figure(2);
        bar(x_subclasses, machine.p_xydw_history(:,end));

        disp(['New class: ' num2str(ic-1) ', new subclass: ' num2str(ixydw-1)]);
        
        % abort signal
        %inputAbortBottle = inputAbortPort.read(false);
        %if( inputAbortBottle.size() > 1 )
        %    if( strcmp(inputAbortBottle.get(0).asString(),'abort') )
        %        i = limitExplorationTaps+1;
        %        result.continue = 0;
        %    end
        %end

    end
    
    % here is the code for angle movement
    outputBottle.addString('angleMovement');
    outputBottle.addDouble(ic-1);
    outputBottle.addDouble(ixydw-1);
    outputBottle.addDouble(shiftPosition);
    outputPort.write(outputBottle);
    outputBottle.clear();
    
    
    % output data
    output.ic(end+1) = ic;
    output.ixydw{end+1} = ixydw_history;
    output.e_xydw{ic, ixydw}(end+1) = result.ixydw - result.ixydw_est;

    % differen error cases
    if( ( result.ic_est >= ic ) && (result.ic_est <= (ic+36) ) )
       output.e_c{ic, ixydw}(end+1) = abs(ic-result.ic_est);
    elseif( ( result.ic_est < ic ) )
        output.e_c{ic, ixydw}(end+1) = result.ic_est-ic;
    elseif( result.ic_est > (ic+36) )
        output.e_c{ic, ixydw}(end+1) = -(ic-(result.ic_est-ncs));
    end

    output.ic_likelihood_histogram{1,i} = machine.p_c_history;
    output.ixydw_likelihood_histogram{1,i} = machine.p_xydw_history;

    save('circle1', 'output');
%    disp(['Limit exploration taps: ' num2str(limitExplorationTaps)]);
end

output_all = output;
save('real_line_20_deg', 'output_all', 'expt', 'logths_c', 'logths_xydw')

% terminate task
outputBottle.addString('endTask');
outputPort.write(outputBottle);
outputBottle.clear();

Network.disconnect(remoteWritePort, localReadPort);
Network.disconnect(localWritePort, remoteReadPort);

inputPort.close;
outputPort.close;

Network.unregisterName(localReadPort);
Network.unregisterName(localWritePort);



% outputBottle.addString('ready');
% outputPort.write(outputBottle);
% outputBottle.clear();
% 
% disp('waiting for values...');
% inputBottle = inputPort.read(true);
% inputBottle.get(0).asString()
% %inputPort.read(inputBottle, true);
% while( strcmp(inputBottle.get(0).asString(),'sending') )
%     text = inputBottle.get(0).asString();
%     row = inputBottle.get(1).asInt();
%     col = inputBottle.get(2).asInt();
%     value = inputBottle.get(3).asDouble();
% 
%     %disp([text ' - (' num2str(row) ',' num2str(col) '): ' num2str(value)]);
%     
%     matrixData(row, col) = value;
% 
% 
%     outputBottle.addString('ready');
%     outputPort.write(outputBottle);
%     outputBottle.clear();
%     
%     inputBottle = inputPort.read(true);
% end
% 
% outputBottle.addString('end');
% outputPort.write(outputBottle);
% outputBottle.clear();
% 
% inputBottle.toString_c()
% inputBottle.toString()
%     
% Network.disconnect(remoteWritePort, localReadPort);
% Network.disconnect(localWritePort, remoteReadPort);
% 
% inputPort.close;
% outputPort.close;
% 
% Network.unregisterName(localReadPort);
% Network.unregisterName(localWritePort);

