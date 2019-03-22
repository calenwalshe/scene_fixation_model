% Run bads

%params = [20 [300 100 100 30 20], [1,1,1,1,1,1,1,1] 100,300];

%LB       = [10, 300, [10  10  30 20], [.1, 1, .1, .1], [.1, 1, .1, .1],  50,  150];
%UB       = [50, 300, [200 200 30 20], [1,  3,  1, 1],  [1,  3,  1, 1],  100, 300];

%Fit Baseline
baseline_fits_exp1 = [];
for i = 1:1
    timer_x0  = randi([100,400]);
    labile_x0 = randi([50, timer_x0]);
    params    = [10 [timer_x0 labile_x0 80 30 20], [1,1,1,1] 1,1];

    LB        = [5, [100, 50  80  30 20], [1 1 1 1], 1,  1];
    UB        = [20, [400, 300 80 30 20], [1 1 1 1], 1, 1];
    [X_baseline_exp1,FVAL] = bads(@optim.vision_research.objVR_exp1_baseline,params,LB,UB);
    baseline_fits_exp1 = [baseline_fits_exp1; [X_baseline_exp1, FVAL]];
end

[Y, I]        = min(baseline_fits_exp1(:,end));
best_baseline_exp1 = baseline_fits_exp1(I,1:end-1); % minimum -LL

% Visualize Fit
%Experiment 1
WalkRate   = best_baseline_exp1(2:6);
WalkParams_exp1 = best_baseline_exp1(7:end);
settings_exp1 = lib.rwexperimentset('ExperimentName', 'visionresearch_exp1',...
    'humanDataPath', '_data/h_fixdur_exp1.mat', 'NumberTrials', 10000,...
    'NumberStates', round([best_baseline_exp1(1), repmat(round(best_baseline_exp1(1)), 1,4)]), 'WalkRate', WalkRate,...
    'ModelParams', WalkParams_exp1,...
    'EventDrivenChangeFcn', @projects.vision_research.VisionResearchParameterAdjustFcn, 'FitnessFcn',...
    @lib.VRMaxLik_baseline, 'NumberSubjects', 1, 'InitializeRandomWalkParameters',...
    @projects.vision_research.VRcreateRandomWalkParams, 'PlotFcn', @vis.save_plot);

f_exp1 = ucm(settings_exp1);

%Fit Adaptation
adaptation_fits_exp1 = [];
for i = 1:1
    %params   = [10 [best_baseline_exp1(2:6)], [.1 + .9 * rand,1 + rand, .1 + .9 * rand, .1 + .9 * rand], 40, 10000];
    %LB        = [10, best_baseline_exp1(2:6), [.1, 1, .1, .1], 40,  10000];
    %UB        = [10, best_baseline_exp1(2:6), [1, 2, 1, 1], 40, 10000];
    params   = [10, [best_baseline_exp1(2:6)], [.1 + .9 * rand,1, .1 + .9 * rand, .1 + .9 * rand], 100, 400];
    LB        = [5, [100, 50  70  30 20], [.1, 1, .1, .1], 40,  200];
    UB        = [20, [400, 300 90 30 20], [1, 1, 1, 1], 200, 2000];    
    [X_adaptation_exp1,FVAL] = bads(@optim.vision_research.objVR_exp1_adaptation,params,LB,UB);
    adaptation_fits_exp1     = [adaptation_fits_exp1; [X_adaptation_exp1, FVAL]];
end

[Y, I]        = min(adaptation_fits_exp1(:,end));
best_adaptation_exp1 = adaptation_fits_exp1(I,1:end-1); % minimum -LL
% Visualize Fit
%Experiment 1
WalkRate   = best_adaptation_exp1(2:6);        
WalkParams_exp1 = best_adaptation_exp1(7:end);
settings_exp1 = lib.rwexperimentset('ExperimentName', 'visionresearch_exp1',...
    'humanDataPath', '_data/h_fixdur_exp1.mat', 'NumberTrials', 10000,...
    'NumberStates', round([best_adaptation_exp1(1), repmat(round(best_adaptation_exp1(1)), 1,4)]), 'WalkRate', WalkRate,...
    'ModelParams', WalkParams_exp1,...
    'EventDrivenChangeFcn', @projects.vision_research.VisionResearchParameterAdjustFcn, 'FitnessFcn',...
    @lib.VRMaxLik_adaptation, 'NumberSubjects', 1, 'InitializeRandomWalkParameters',...
    @projects.vision_research.VRcreateRandomWalkParams, 'ExportFcn', @lib.export_all);

f_exp1 = ucm(settings_exp1);

