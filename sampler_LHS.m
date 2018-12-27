function []= sampler_LHS(inputFilePath, outputFilePath, n_results)
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
thresholdDimensions = 2;

%% Suitable for lower dimensional problem: Utilizes latin hypercube sampling with prescribed #samples and dimensionality
if dimensionality < thresholdDimensions
    sampleFactor = 1000;% maximized the sample factor if this fails then Method 2
    X = lhsdesign(sampleFactor*n_results,dimensionality,'criterion','maximin');

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
    % Method 2 also util9izes the Latin hypercube except now we use the
    % example point and LHS on smaller number of dimensions and keep
    % reducing number of dimensions sampled if rejection is very high
    sampleFactor = 5000;% maximized the sample factor if this fails then Method 2
    samplePerDimension = ceil(sampleFactor*n_results / dimensionality);
    cumulativeX = feasiblePoint;
    
    for iDimension = 1:dimensionality
        %tmpSamples = lhsdesign(samplePerDimension,1,'criterion','correlation');
        tmpSamples = lhsnorm(feasiblePoint(iDimension),0.1,samplePerDimension);
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
        iDimension
        acceptedVectors
        cumulativeX = [cumulativeX; X(acceptedIdx(2:end),:)];
    end
    %% Save samples to specified text file with space delimiters
    dlmwrite(outputFilePath,cumulativeX, 'delimiter', '\t');

end

%% Display the amount of time consumed
disp('Sampling Completed.')
toc % Stopping the timer and time elapsed is displyed

%% Clean path
rmpath( fullfile( rootPath, 'parseConstraints'));
rmpath( fullfile( rootPath, 'parseCheckInput'));
rmpath( fullfile( rootPath, 'examplesOutput'));
rmpath( fullfile( rootPath, 'examplesInput'));
rmpath(inputPath);
rmpath(outputPath);

end