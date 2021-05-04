% Run bads

%Fit Baseline
baseline_fits_exp2 = [];
for i = 1:5
    timer_x0  = randi([100,300]);
    labile_x0 = randi([50, timer_x0]);
    params    = [10 [timer_x0 labile_x0 80 30 20], [1,1,1,1] 1,1];

    LB        = [10, [100, 100  50  30 20], [1 1 1 1], 1, 1];
    UB        = [30, [300, 250 100 30 20], [1 1 1 1], 1, 1];
    [X_baseline_exp2,FVAL] = bads(@optim.vision_research.objVR_exp2_baseline,params,LB,UB);
    baseline_fits_exp2 = [baseline_fits_exp2; [X_baseline_exp2, FVAL]];
end

[Y, I]        = min(baseline_fits_exp2(:,end));
best_baseline_exp2 = baseline_fits_exp2(I,1:end-1); % minimum -LL

% Visualize Fit
%Experiment 1
WalkRate   = best_baseline_exp2(2:6);
WalkParams_exp2 = best_baseline_exp2(7:end);
settings_exp2 = lib.rwexperimentset('ExperimentName', 'visionresearch_exp2',...
    'humanDataPath', '_data/h_fixdur_exp2.mat', 'NumberTrials', 1500,...
    'NumberStates', round([best_baseline_exp2(1), repmat(round(best_baseline_exp2(1)), 1,4)]), 'WalkRate', WalkRate,...
    'ModelParams', WalkParams_exp2,...
    'EventDrivenChangeFcn', @projects.vision_research.VisionResearchParameterAdjustFcn, 'FitnessFcn',...
    @lib.VRMaxLik_baseline, 'NumberSubjects', 1, 'InitializeRandomWalkParameters',...
    @projects.vision_research.VRcreateRandomWalkParams, 'PlotFcn', @vis.save_plot);

f_exp2 = ucm(settings_exp2);

%Fit Adaptation
adaptation_fits_exp2 = [];
for i = 1:1
    params   = [16, [best_baseline_exp2(2:6)], [.1 + .9 * rand,1, .1 + .9 * rand, .1 + .9 * rand], 50, 300];
    LB        = [16, [best_baseline_exp2(2:6)], [.1, 1, .1, .1], 0,  200];
    UB        = [16, [best_baseline_exp2(2:6)], [1, 1, 1, 1], 100, 400];    
    [X_adaptation_exp2,FVAL] = bads(@optim.vision_research.objVR_exp2_adaptation,params,LB,UB);
    adaptation_fits_exp2     = [adaptation_fits_exp2; [X_adaptation_exp2, FVAL]];
end

[Y, I]        = min(adaptation_fits_exp2(:,end));
best_adaptation_exp2 = adaptation_fits_exp2(I,1:end-1); % minimum -LL
% Visualize Fit
%Experiment 2
WalkRate   = best_adaptation_exp2(2:6);        
WalkParams_exp2 = best_adaptation_exp2(7:end);
settings_exp2 = lib.rwexperimentset('ExperimentName', 'visionresearch_exp2',...
    'humanDataPath', '_data/h_fixdur_exp2.mat', 'NumberTrials', 10000,...
    'NumberStates', round([best_adaptation_exp2(1), repmat(round(best_adaptation_exp2(1)), 1,4)]), 'WalkRate', WalkRate,...
    'ModelParams', WalkParams_exp2,...
    'EventDrivenChangeFcn', @projects.vision_research.VisionResearchParameterAdjustFcn, 'FitnessFcn',...
    @lib.VRMaxLik_adaptation, 'NumberSubjects', 1, 'InitializeRandomWalkParameters',...
    @projects.vision_research.VRcreateRandomWalkParams, 'ExportFcn', @lib.export_all);

f_exp2 = ucm(settings_exp2);

save('~/Dropbox/Calen/Work/ucm/scene_fixation_model/_export/settings_exp2.mat', 'settings_exp2')

% Counterfactuals
% No surprise
settings_exp2_no_surprise = settings_exp2;
settings_exp2_no_surprise.ModelParams([1,3]) = 1; % 
settings_exp2_no_surprise.ExperimentName = 'visionresearch_exp2_nosurprise';

f_exp2 = ucm(settings_exp2_no_surprise);

save('~/Dropbox/Calen/Work/ucm/scene_fixation_model/_export/settings_exp2_no_surprise.mat', 'settings_exp2_no_surprise')

% No encoding
settings_exp2_no_encoding = settings_exp2;
settings_exp2_no_encoding.ModelParams([2,4]) = 1; % 
settings_exp2_no_encoding.ExperimentName = 'visionresearch_exp2_noencoding';
f_exp2 = ucm(settings_exp2_no_encoding);

save('~/Dropbox/Calen/Work/ucm/scene_fixation_model/_export/settings_exp2_no_encoding.mat', 'settings_exp2_no_encoding')
