function [dimensionality,feasiblePoint,constraintArray]= parseInput(fileName)
% This function reads the input values from the text file and converts them
% to data structures


if exist(fileName)
     fileID = fopen(fileName,'r');
else
     warningMessage = sprintf('Warning: file does not exist:\n%s', fileName);
     uiwait(msgbox(warningMessage));
end

dimensionality = str2num(fgetl(fileID)); % first line is dimensionality
feasiblePoint = str2num(fgetl(fileID)); % second line gives the feasible point
checkComment = fgetl(fileID); % this checks for comment lines and skips them
constraintArray = {};

% Skips the comment lines and stores the constraints
while ~feof(fileID)
    if strcmp(checkComment(1),'#')
        checkComment = fgetl(fileID);
    else
        constraintArray = [constraintArray; checkComment];
        checkComment = fgetl(fileID);
    end
end
constraintArray = [constraintArray; checkComment];

fclose(fileID);
end