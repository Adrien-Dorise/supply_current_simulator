function [resetData, status] = currentReset(normalCurrent, latchCurrent,  status, resetTime, resetDuration)
% currentReset
% Author: Adrien Dorise
% Date: March 2020
% Simulate a rebooting of the device when a latch up is occuring
% Inputs: normalCurrent: Normal behavior of the current without latchup
%          latchCurrent: Ongoing current we want to reset
%          resetTime: Time when we want to do the reset
%          resetDuration: Duration of the reset before going back to
%          normal
% Output: resetCurrent: Current after reset
%          status : Matrix indicating what is happening in the signal


resetData = latchCurrent;
if resetTime < 1
    resetTime = 1;
end
if length(latchCurrent) - resetTime >= resetDuration
    resetData(resetTime:resetTime+resetDuration) = 0;
    resetData(resetTime+resetDuration+1:end) = normalCurrent(resetTime+resetDuration+1:end);
    status(resetTime:resetTime+resetDuration,[1 5]) = 4;
    status(resetTime:resetTime+resetDuration,15) = status(resetTime:resetTime+resetDuration,15) + 1;

else
    resetData(resetTime:end) = 0;
    status(resetTime:end,[1 5]) = 4;
    status(resetTime:end,15) = status(resetTime:end,15) + 1;

end

status(resetTime:end,[6]) = 0;
status(resetTime:end,16) = 0;

end

