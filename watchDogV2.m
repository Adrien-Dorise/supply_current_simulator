% watchDogs
% Author: Adrien Dorise
% Date: March 2020
% This program simulate the behavior of a watch dog. Meaning, for a given
% data set, if a threshold is exceeded, the data set is reset (put to 0)
% for a given amount of time.

clear all
close all

% Loading data set
folderPath = '/media/adrien/Adrien_Dorise_USB/DIAG-RAD/Simulation_Matlab/Datas3';

referenceLatchDataSet = matfile([folderPath '/' 'dataSet.mat']);
referenceLatchDataSet = referenceLatchDataSet.dataSet;
dataSet = matfile([folderPath '/' 'normalCurrent.mat']);
dataSet = dataSet.normalCurrent;
latchDataSet = dataSet;
normalCurrent = dataSet;

% Latch-up parameters
latchQuantity = 1; % Indicates the number of latch desired by user
size = length(dataSet);
lowLatchTime = [size*0.45 size*0.50 size*0.76];
highLatchTime = [size*0.45 size*0.55 size*0.77];
latchTime = [randi([lowLatchTime(1) highLatchTime(1)])...
    randi([lowLatchTime(2) highLatchTime(2)])...
    randi([lowLatchTime(3) highLatchTime(3)])];
lowLatchDuration = [size*0.1 size*0.1 size*0.1];
highLatchDuration = [size*0.11 size*0.11 size*0.11];
untilEnd = [1 1 1];
lowLatch = [10 50 50];
highLatch = [10 70 70];
latchNumber = 1;

% Reset parameters
currentThreshold = 75;
resetDuration = 100;



% Figure
size = length(dataSet);
threshold = currentThreshold*ones(size, 1);
fig1 = figure;
set(gcf, 'Position', get(0, 'Screensize')) % WideScreen figure
% hold on
subplot(2,2,1);
hold on
grid on
xlim([1 size]);
ylim([0 max(referenceLatchDataSet(:))]);
title("Real time watch dog simulation")
xlabel("Sample");
ylabel("Current (mA)");

plot([1:size],threshold);




% Real time loop
for i=1:length(dataSet)
    % We plot data befoe any modification -> We wait to "see" the data
    %before processing it.
    plot(i, dataSet(i),".")
    dataSet(i);
    pause(0.005); 
    
    % Adding latch up
    if length(latchTime) >= latchNumber && latchQuantity >= latchNumber
        if i == latchTime(latchNumber)
            latchDataSet = latchUp(latchDataSet, untilEnd(latchNumber),lowLatch(latchNumber),highLatch(latchNumber),latchTime(latchNumber),latchTime(latchNumber),lowLatchDuration(latchNumber),highLatchDuration(latchNumber));
            dataSet = latchUp(dataSet, untilEnd(latchNumber),lowLatch(latchNumber),highLatch(latchNumber),lowLatchTime(latchNumber),highLatchTime(latchNumber),lowLatchDuration(latchNumber),highLatchDuration(latchNumber));
            latchNumber = latchNumber + 1;
        end
    end
    
    % If threshold value exceeded, we reset
    if dataSet(i) >= currentThreshold
%         resetValue = find(dataSet(i+1:end)<currentThreshold);   
%         dataSet(i+1:resetValue) = normalCurrent(i+1:resetValue);
        dataSet = currentReset(dataSet,dataSet,i+1,resetDuration);
        dataSet(i+1+resetDuration:end) = normalCurrent(i+1+resetDuration:end);
              
    end
end






% fig2 = figure;
% hold on
subplot(2,2,3);
hold on
grid on
title("Watch dog simulation")
xlabel("Sample");
ylabel("Current (mA)");
ylim([0 max(referenceLatchDataSet(:))]);
plot([1:size],threshold,'r');
plot([1:length(dataSet)],dataSet)

% fig3 = figure;
% hold on
subplot(2,2,2);
hold on
grid on
title("Latch data set without reset")
xlabel("Sample");
ylabel("Current (mA)");
ylim([0 max(referenceLatchDataSet(:))]);
plot([1:length(dataSet)],latchDataSet)




