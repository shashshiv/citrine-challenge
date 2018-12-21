function [constraintArray]= constraintExpressions(constraintArray)
% Converts constraints into array of char type which is later converted to
% matlab format mathematical expressions 

nConstraints = length(constraintArray);

for idx= 1:nConstraints
    idxConstraint = constraintArray{idx,1};

    % Correcting brackets for array indexing from '(' to ']'
    idxConstraint = strrep(idxConstraint,'(','{');
    idxConstraint = strrep(idxConstraint,')','}');

    % Correcting brackets for array indexing from '[' to '('
    idxConstraint = strrep(idxConstraint,'[','(');
    idxConstraint = strrep(idxConstraint,']',')');
    idxConstraint = strrep(idxConstraint,'{','[');
    idxConstraint = strrep(idxConstraint,'}',']');
    
    % Increments the indices of array by 1 to match matlab format
    openBraceIdx = find(idxConstraint=='(');
    closedBraceIdx = find(idxConstraint==')');
    doubleDigitIdx = find((closedBraceIdx-openBraceIdx-2)==1);
    singleDigitIdx = find(~((closedBraceIdx-openBraceIdx-2)==1));
 
    % For the case of double digit indexes
    doubleIdxValues = openBraceIdx(doubleDigitIdx)+1;
    for dIdx = 1:length(doubleIdxValues)
        idxConstraint(doubleIdxValues:doubleIdxValues+1) = num2str(str2num(idxConstraint(doubleIdxValues:doubleIdxValues+1))+1);
    end
  
    % For the case of single digit indexes
    singleIdxValues = openBraceIdx(singleDigitIdx)+1;
    idxConstraint(singleIdxValues)= idxConstraint(singleIdxValues)+1;

    % For special case of occurance of 9
    idxForNine = find(idxConstraint(singleIdxValues)==':');
    for nIdx= 1:length(idxForNine)    
       idxConstraint= [idxConstraint(1:singleIdxValues(idxForNine(nIdx))-1) '10' idxConstraint(singleIdxValues(idxForNine(nIdx))+1:end)]; 
    end

    constraintArray{idx,1} = idxConstraint;
    
end

end
