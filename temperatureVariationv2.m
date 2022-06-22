function [temperatureVariation, status] = temperatureVariation(dataSet,status,untilEnd,varFunction,lowTime,highTime)
% latchUp
% Author: Adrien Dorise
% Date: March 2020
% Introduce a variation of the consumption current due to a modificatiSon of
% the temperature.
% Inputs: dataSet: We add the temperature variation to this data set
%          varFunction : Matrix containing the value of the function to add
%to the dataset
%          lowTime : Lowest possible time for the variation to happen
%          highTime : Highest possible time for the variation to happen
% Output: normalCurrent: Normal behavior with added temperature variation
%          status : Matrix indicating what is happening in the signal


temperatureVariation = dataSet;
time = randi(round([lowTime highTime]));
if length(varFunction) + time > length(temperatureVariation)
    varFunction(length(temperatureVariation)-time+2:end) = [];
end
if time < 1
    time = 1;
end
temperatureVariation(time:time+length(varFunction)-1) = temperatureVariation(time:time+length(varFunction)-1) + varFunction.';
if untilEnd == 1 
    temperatureVariation(time+length(varFunction):end) = temperatureVariation(time+length(varFunction):end) + varFunction(end);
end
status(time:time+length(varFunction)-1,[1 4]) = 3;
status(time:time+length(varFunction)-1,14) = status(time:time+length(varFunction)-1,14) + 1;

end

