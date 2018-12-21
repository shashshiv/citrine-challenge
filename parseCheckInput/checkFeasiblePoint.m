function [] = checkFeasiblePoint(constraintArray, feasiblePoint)

    % Returns flag based on constraint satisfaction
    [cumulativeCounter]= acceptReject(constraintArray, feasiblePoint);
    
    % Return error if constraints not satisfied
    if ~cumulativeCounter
        error('Example Feasible point doesnot satisfy constraint. Program Terminated.\n');
    end
end