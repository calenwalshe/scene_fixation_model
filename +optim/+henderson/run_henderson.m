% Run bads

%params = [20 [300 100 100 30 20], [1,1,1,1,1,1,1,1] 100,300];

%LB       = [10, 300, [10  10  30 20], [.1, 1, .1, .1], [.1, 1, .1, .1],  50,  150];
%UB       = [50, 300, [200 200 30 20], [1,  3,  1, 1],  [1,  3,  1, 1],  100, 300];

%Fit Baseline
baseline_fits_exp2 = [];
for i = 1:5
    timer_x0  = randi([100,400]);
    labile_x0 = randi([50, timer_x0]);
    params    = [10 [timer_x0 labile_x0 80 30 20], [1,1,1,1] 1,1];

    LB        = [5, [100, 50  80  30 20], [1 1 1 1], 1, 1];
    UB        = [20, [400, 400 80 30 20], [1 1 1 1], 1, 1];
    [X_baseline_exp2,FVAL] = bads(@optim.henderson.objfunHenderson,params,LB,UB);
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