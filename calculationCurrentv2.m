function [calculationCurrent, status] = calculationCurrent(dataSet, status,currentMin, currentMax, calculationTime, calculationDuration)
% calculationCurrent
% Author: Adrien Dorise
% Date: March 2020
% This fonction simulate the current consumption when a device is
% calculating or a software is running.
% Inputs: dataSet: Data set to modify
%          currentMin: Current mininmum possible
%          currentMax: Current maximum possible
%          calculationTime: Time to begin the calculation
%          duration: duration of the calculation
% Outputs: calculationCurrent: New consumption current with calculation
%          status : Matrix indicating what is happening in the signal

calculationCurrent = dataSet;
if calculationTime + calculationDuration > length(calculationCurrent)
    calculationDuration = length(calculationCurrent) - calculationTime;
end
if calculationTime < 1
    calculationTime = 1
end
calculationCurrent(calculationTime:calculationTime+calculationDuration-1) = (currentMax - currentMin).*rand(calculationDuration,1) + currentMin;
status(calculationTime:calculationTime+calculationDuration-1,[1 2]) = 1;
status(calculationTime:calculationTime+calculationDuration-1,12) = status(calculationTime:calculationTime+calculationDuration-1,12) + 1;

end

