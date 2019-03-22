function SQE = VRSQE_adaptation(settings, eventKeys, experimentData, humanData)
%% fitVal = MaxLik(settings, eventKeys, humanData)
% Description: This function will give the log-likelihood of the model
% given the data that human data. The aim is to search for model parameters
% that maximize the log-likelihood.
   

% Format Data %
events         = vertcat(experimentData{:});

if isempty(events)
    NLL = 10000;
    return;
end
event_objects  = events(:,1);
%

% Extract Fixation Durations %
fix_dur_idx  = cellfun(@(x) any(x(1) == [eventKeys.NOCHANGE_DUR,eventKeys.UP_DUR,eventKeys.DOWN_DUR]), event_objects);

simulationData = vertcat(event_objects{fix_dur_idx});
% 

UPkey       = eventKeys.UP_DUR;
DOWNkey     = eventKeys.DOWN_DUR;
NOCHANGEkey = eventKeys.NOCHANGE_DUR;

h_data_nochange = humanData.human_data(humanData.human_data(:,1) == 1,2);
h_data_up       = humanData.human_data(humanData.human_data(:,1) == 2,2);
h_data_down     = humanData.human_data(humanData.human_data(:,1) == 3,2);

simulationData = cell2mat(experimentData);

if isempty(simulationData)
    SQE = 10000;
    return;
end

dataDOWN       = simulationData(simulationData(1:end,2) == DOWNkey);
dataUP         = simulationData(simulationData(1:end,2) == UPkey);
dataNOCHANGE   = simulationData(simulationData(1:end,2) == NOCHANGEkey);

edges = 0:30:1200;

dataNOCHANGE_bin  = histc(dataNOCHANGE, edges) + 1;
dataNOCHANGE_bin  = dataNOCHANGE_bin(1:(end-1));
dataNOCHANGE_P    = dataNOCHANGE_bin/sum(dataNOCHANGE_bin);

dataUP_bin = histc(dataUP, edges) + 1;
dataUP_bin = dataUP_bin(1:(end - 1));
dataUP_P   = dataUP_bin/sum(dataUP_bin);

dataDOWN_bin = histc(dataDOWN, edges) + 1;
dataDOWN_bin = dataDOWN_bin(1:(end-1));
dataDOWN_P   = dataDOWN_bin/sum(dataDOWN_bin);
   
%SQE = -sum(h_data_down .* log(dataDOWN_P + min_p_const)) + ...
%    -sum(h_data_nochange .* log(dataNOCHANGE_P + min_p_const)) + ...
%    -sum(h_data_up .* log(dataUP_P + min_p_const));
SQE = sum(((dataUP_P - h_data_up).^2)) + ...
    sum(((dataDOWN_P - h_data_down).^2));
end