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

%% Check for the validity of example feasible point and return error if its not
checkFeasiblePoint(constraintArray, feasiblePoint);

%% Utilizes latin hypercube sampling with prescribed #samples and dimensionality
sampleFactor = 10;
X = lhsdesign(sampleFactor*n_results,dimensionality,'smooth','off');

%% Satisfies the constraints and check for accept/reject
acceptedVectors = 0;
acceptedIdx = 0; 
sampleIdx = 1; 
while acceptedVectors< n_results-1   
    sampleVector = X(sampleIdx,:)';
    [cumulativeCounter] = constraintExpressions(constraintArray, sampleVector);
    acceptedVectors = acceptedVectors + cumulativeCounter;
    if cumulativeCounter
       acceptedIdx = [acceptedIdx; sampleIdx]; 
    end
    
    sampleIdx = sampleIdx + 1;
end

%% Save samples to specified text file with space delimiters
dlmwrite(outputFilePath,[feasiblePoint; X(acceptedIdx(2:end),:)], 'delimiter', '\t');

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