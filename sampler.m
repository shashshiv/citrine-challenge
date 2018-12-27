function []= sampler(inputFilePath, outputFilePath, n_results)
%--------------------------------------------------------------------------
% sampler - This is the main code which runs all the subroutines
%
% Input arguments required are :
%
%--------------------------------------------------------------------------

%% Initialize variables and Set Path
[inputPath,inputFileName,extInput] = fileparts(inputFilePath);
[outputPath,outputFileName,extOutput] = fileparts(outputFilePath);

rootPath = pwd();
addpath( fullfile( rootPath, 'parseConstraints'));
addpath( fullfile( rootPath, 'parseCheckInput'));
addpath( fullfile( rootPath, 'examplesOutput'));
addpath( fullfile( rootPath, 'examplesInput'),'-end');
addpath(inputPath);
addpath(outputPath);

tic % Start the timer

%% Reads the input from a input text file and converts to data structure
[dimensionality,feasiblePoint,constraintArray]= parseInput(strcat(inputFileName,extInput));

%% Parse and analyse constraints in matlab format
[constraintArray] = constraintExpressions(constraintArray);

%% Check for the validity of example feasible point and return error if its not
checkFeasiblePoint(constraintArray, feasiblePoint);
thresholdDimensions = 5; % if number of dimensions exceed 5 then change to Method 2

%% Timeout check on method 1
flagTimeOut = checkTimeOut(constraintArray,dimensionality);% timeout for method 1 based on acceptance ratio and shift to method 2


%% Suitable for lower dimensional problem: Utilizes latin hypercube sampling with prescribed #samples and dimensionality
if (dimensionality < thresholdDimensions & ~flagTimeOut)
    maxSamplingFactor = 500;% this is maximum possible number of samples rejetion sampling will run on
    X = lhsdesign(maxSamplingFactor*n_results,dimensionality,'criterion','maximin'); % performs Latin hypercube sampling

    %% Satisfies the constraints and check for accept/reject
    acceptedVectors = 0;
    acceptedIdx = 0; 
    sampleIdx = 1;
    
    while acceptedVectors< n_results-1  
        sampleVector = X(sampleIdx,:)';
        [cumulativeCounter]= acceptReject(constraintArray, sampleVector);
        acceptedVectors = acceptedVectors + cumulativeCounter;
        if cumulativeCounter
           acceptedIdx = [acceptedIdx; sampleIdx]; 
        end

        sampleIdx = sampleIdx + 1;
    end

    %% Save samples to specified text file with space delimiters
    dlmwrite(outputFilePath,[feasiblePoint; X(acceptedIdx(2:end),:)], 'delimiter', '\t');

else
    % Method 2 also utilizes the Latin hypercube except now we use the
    % example point and LHS on smaller number of dimensions and keep
    % reducing number of dimensions sampled if rejection is very high
    maxSamplingFactor = 4000;% this is maximum possible number of samples rejetion sampling will run on
    samplePerDimension = ceil(maxSamplingFactor*n_results / dimensionality);% every dimension gets same number of samples for 1-D LHS
    cumulativeX = feasiblePoint; % starting point is the example given
    
    for iDimension = 1:dimensionality
        tmpSamples = lhsdesign(samplePerDimension,1,'criterion','correlation');
        %tmpSamples = lhsnorm(feasiblePoint(iDimension),0.1,samplePerDimension);
        X = repmat(feasiblePoint, samplePerDimension,1);
        X(:,iDimension) = tmpSamples;
        %% Satisfies the constraints and check for accept/reject
        acceptedVectors = 0;
        acceptedIdx = 0; 
        sampleIdx = 1;

        while acceptedVectors< ceil(n_results/dimensionality)  
            sampleVector = X(sampleIdx,:)';
            [cumulativeCounter]= acceptReject(constraintArray, sampleVector);
            acceptedVectors = acceptedVectors + cumulativeCounter;
            if cumulativeCounter
               acceptedIdx = [acceptedIdx; sampleIdx];
            end

            sampleIdx = sampleIdx + 1;
        end
        cumulativeX = [cumulativeX; X(acceptedIdx(2:end),:)];
    end
    %% Save samples to specified text file with space delimiters
    dlmwrite(outputFilePath,cumulativeX(1:n_results,:), 'delimiter', '\t');

end

%% Display the amount of time consumed
disp('Sampling Completed.');
% Stopping the timer and time elapsed is displyed
disp(['Time elasped for simulation is ',num2str(toc),' seconds.']);

%% Clean path
rmpath( fullfile( rootPath, 'parseConstraints'));
rmpath( fullfile( rootPath, 'parseCheckInput'));
rmpath( fullfile( rootPath, 'examplesOutput'));
rmpath( fullfile( rootPath, 'examplesInput'));
rmpath(inputPath);
rmpath(outputPath);

end