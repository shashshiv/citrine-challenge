function flagTimeOut = checkTimeOut(constraintArray, dimensionality)
% Calculetes acceptance ratio for generating 1 feasible vector

flagTimeOut = 0;
maxSamplingFactor = 100;% this is maximum possible number of samples rejetion sampling will run on
X = lhsdesign(maxSamplingFactor*1,dimensionality,'criterion','maximin'); % performs Latin hypercube sampling

%% Satisfies the constraints and check for accept/reject
acceptedVectors = 0;

for iAccept = 1:maxSamplingFactor
    sampleVector = X(iAccept,:)';
    [cumulativeCounter]= acceptReject(constraintArray, sampleVector);
    acceptedVectors = acceptedVectors + cumulativeCounter;
end

% if acceptance ratio is less than 10% then shift to method 2
flagTimeOut(acceptedVectors/(maxSamplingFactor)< 0.1) = 1;

%% Display that method 1 might timeout so shifting to method 2
if flagTimeOut
    disp('NOTE: Based on acceptance ratio Method 1 might timeout so shifting to Method 2!');
end

end