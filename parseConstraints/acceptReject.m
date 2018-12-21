function [cumulativeCounter]= acceptReject(constraintArray, sampleVector)

nConstraints = length(constraintArray);
cumulativeCounter = 1;
x= sampleVector;

for idx= 1:nConstraints
% Checks if this specific constraint satisfies with provided sample
    acceptRejectCounter = eval(char(constraintArray(idx,1)));
    cumulativeCounter = cumulativeCounter*acceptRejectCounter;
end

end