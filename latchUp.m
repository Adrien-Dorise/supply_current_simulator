function [latchCurrent, status] = latchUp(dataSet, status,untilEnd,lowLatch,highLatch,lowTime,highTime,lowLatchDuration,highLatchDuration)
% latchUp
% Author: Adrien Dorise
% Date: March 2020
% Introducing latch-up phenomena inside a normal current behavior
% Inputs: dataSet: We add the latch-up to this data set
%          untilEnd: If value is 1, the latch last until the end of the
%          data set
%          lowTime: Lowest time possibility for the latchup to occur
%          highTime: Highest time possibility for the latch up to occur
%          lowLatchDuration: Lowest duration possible for the latch-up
%          highLatchDuration:Highest duration possible for the latch-up
%          lowLatch: Lowest possible value of latch-up
%          highLatch: Higest possible value of latch-up
% Output: normalCurrent: Normal behavior with added latch up
%          status : Matrix indicating what is happening in the signal


latchCurrent = dataSet;
latchSet = randi(round([lowTime highTime]));
if untilEnd == 1 
    latchDuration = length(dataSet)-latchSet+1;
else
    latchDuration = randi(round([lowLatchDuration highLatchDuration]));
end
latchValue = (highLatch - lowLatch)*rand + lowLatch;

latchCurrent(latchSet:latchSet+latchDuration-1) = latchCurrent(latchSet:latchSet+latchDuration-1) + latchValue;
status(latchSet:latchSet+latchDuration-1,[1 6]) = 6;
status(latchSet:latchSet+latchDuration-1,16) = status(IO_time:IO_time+IO_duration-1,16) + 1;

end