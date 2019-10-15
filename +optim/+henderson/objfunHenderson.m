function f = objfunHenderson(x)
%display(x)

x = [x(6), x(1), x(2), x(3), x(4), 98.27,243.69];

settings = lib.rwexperimentset('ExperimentName', 'henderson_up', 'NumberTrials',...
    100, 'NumberStates', [38, 10, 10, 10, 10], 'WalkRate', [267 * x(5), 207 * x(5),60 * x(5), 30 * x(5), 20],...
    'ModelParams', x, 'EventDrivenChangeFcn', @HendersonAdjustFcn,...
    'FitnessFcn', @lib.hendersonMaxLik, 'NumberSubjects', 1,...
    'InitializeRandomWalkParameters', @HendersonCreateRandomWalkParams,...
    'plotFcn', @vis.plot_henderson_mean);

f = ucm(settings);

end

function f = objfunHenderson(x)
    WalkRate   = x(2:6);

    WalkParams_exp2 = x(7:end);
    %WalkParams_exp2 = [x((1 + n_rate_params + n_adj_params + 1):(end - n_stage_params)), x(end-1:end)];    
    nWalk = x(1);
    if mod(x(1),1) ~= 0
        
        x(1) = floor(nWalk);        
        settings_exp2_low = lib.rwexperimentset('ExperimentName', 'visionresearch',...
            'humanDataPath', '_data/h_fixdur_exp2.mat', 'NumberTrials', 1500,...
            'NumberStates', round([x(1), repmat(round(x(1)), 1,4)]), 'WalkRate', WalkRate,...
            'ModelParams', WalkParams_exp2,...
            'EventDrivenChangeFcn', @projects.vision_research.VisionResearchParameterAdjustFcn, 'FitnessFcn',...
            @lib.VRMaxLik_adaptation, 'NumberSubjects', 1, 'InitializeRandomWalkParameters',...
            @projects.vision_research.VRcreateRandomWalkParams);

        x(1) = ceil(nWalk);
        settings_exp2_high = lib.rwexperimentset('ExperimentName', 'visionresearch',...
            'humanDataPath', '_data/h_fixdur_exp2.mat', 'NumberTrials', 1500,...
            'NumberStates', round([x(1), repmat(round(x(1)), 1,4)]), 'WalkRate', WalkRate,...
            'ModelParams', WalkParams_exp2,...
            'EventDrivenChangeFcn', @projects.vision_research.VisionResearchParameterAdjustFcn, 'FitnessFcn',...
            @lib.VRMaxLik_adaptation, 'NumberSubjects', 1, 'InitializeRandomWalkParameters',...
            @projects.vision_research.VRcreateRandomWalkParams);

        f_low  = ucm(settings_exp2_low);
        f_high = ucm(settings_exp2_high);    
        f      = mean([f_low, f_high]);
    else      
        settings_exp2 = lib.rwexperimentset('ExperimentName', 'visionresearch',...
            'humanDataPath', '_data/h_fixdur_exp2.mat', 'NumberTrials', 1500,...
            'NumberStates', round([x(1), repmat(round(x(1)), 1,4)]), 'WalkRate', WalkRate,...
            'ModelParams', WalkParams_exp2,...
            'EventDrivenChangeFcn', @projects.vision_research.VisionResearchParameterAdjustFcn, 'FitnessFcn',...
            @lib.VRMaxLik_adaptation, 'NumberSubjects', 1, 'InitializeRandomWalkParameters',...
            @projects.vision_research.VRcreateRandomWalkParams);
        f = ucm(settings_exp2);        
    end
end