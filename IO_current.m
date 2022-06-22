function [IO_data ,status] = IO_current(dataSet, status, currentMin, currentMax, IO_timeLow, IO_timeHigh, durationLow, durationHigh)
% outputCurrent
% Author: Adrien Dorise
% Date: March 2020
% This fonction simulate the current consumption when an extern component
% is connected to the main device. It translate as a jump in the
% consumption current
% Inputs: dataSet: Data set to modify
%          currentMin: Current jump mininmum possible
%          currentMax: Current jump maximum possible
%          calculationTime: Time to begin the current jump
%          duration: duration of the current jump
% Outputs: outputCurrent: New consumption current
%          status : Matrix indicating what is happening in the signal


IO_data = dataSet;
IO_time = randi(round([IO_timeLow IO_timeHigh]));
IO_duration = randi(round([durationLow durationHigh]));
if IO_time + IO_duration > length(IO_data)
    IO_duration = length(IO_data) - IO_time;
end
currentValue = (currentMax - currentMin).*rand(IO_duration,1) + currentMin;
if IO_time < 1
    IO_time = 1;
end   
IO_data(IO_time:IO_time+IO_duration-1) = IO_data(IO_time:IO_time+IO_duration-1) + currentValue;
status(IO_time:IO_time+IO_duration-1,[1 3]) = 2;
status(IO_time:IO_time+IO_duration-1,13) = status(IO_time:IO_time+IO_duration-1,13) + 1;




end



