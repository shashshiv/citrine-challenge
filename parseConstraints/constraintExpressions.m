function [cumulativeCounter]= constraintExpressions(constraintArray, sampleVector)
% Converts constraints into array of char type which is later converted to
% matlab format mathematical expressions 

nConstraints = length(constraintArray);
cumulativeCounter = 1;
x= sampleVector;

for idx= 1:nConstraints
    % Correcting indexes since array indices in matlab start with 1
    idxConstraint = constraintArray{idx,1};
    findBraketIdx= find(idxConstraint == '[');
    findBraketIdx = findBraketIdx+1;
    idxConstraint(findBraketIdx) = idxConstraint(findBraketIdx)+1;
    
    % Correcting brackets for array indexing from '[' to '('
    idxConstraint = strrep(idxConstraint,'[','(');
    idxConstraint = strrep(idxConstraint,']',')');
    
    % Checks if this specific constraint satisfies with provided sample
    acceptRejectCounter = eval(idxConstraint);
    cumulativeCounter = cumulativeCounter*acceptRejectCounter;
end

end
