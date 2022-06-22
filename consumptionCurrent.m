function [normalCurrent] = consumptionCurrent(lowCurrent,highCurrent,size)
% consumptionCurrent
% Author: Adrien Dorise
% Date: March 2020
% Creation of a random normal behavior
% Inputs: lowCurrent: Lowest value the current can take
%          highCurrent: Highest value the current can take
%          size: Number of value for the sample
% Output: normalCurrent: Normal behavior inside a matrix
%rng(0,'twister'); %Allow repeatability of scenario (comment for random initialisation)

normalCurrent = (highCurrent - lowCurrent).*rand(size,1) + lowCurrent;
end

