% dataSetCreation
% Author: Adrien Dorise
% Date: March 2020
% This program creates data set to simulate the comportment of a
% microcontroller subject to space radiation. The 'normal' behavior is a
% random serie of value representing the variation of the consumption
% current. Then, some random pics appeared simulating latch up phenomena.
% Input: nothing
% Outputs: dataSet: a matrix of values containing the scenario with
% latch-up
%          normalData: A matrix of value containing the scenario without
%latch-up
%          xData: Matrix containing a the number of values in the data (for x axis plotting)
%          diagData: matrix contaning all 3 previous matrix
%          StatusData : Gives the time when each function is used as follow
% from colonnes 1 to 6 :
% (["Normal current" "Calculation" "I/O consumption" "Temperature variation" "reset" "Latch up"]
% Then from colonnes 7 to 11 (12 to 16 ins status) :
% [ "Calculation Quantity" "I/O consumption Quantity" "Temperature variation  Quantity" "reset Quantity" "Latch up Quantity"]




clear all
close all

iteration = 1;
'Data generation begins.'
for j=1:iteration
    %%
    clearvars -except j
    close all
    % Parameters
    
    % Folder for datas
    %folderPath = strcat('/media/adrien/Adrien_Dorise_USB/DIAG-RAD/Simulation_Matlab/Datas/datasGenerator/random_with_latch3/datas', int2str(j));
    folderPath = strcat('E:\\DIAG_RAD\\DataSets\\Simulation_Matlab\\datasGenerator\\DataExemple\\Example\\datas', int2str(j));       
    figShown = 0;
    saveData= 0;
    
    % Functions parameters
    
    randomTime = 1;
    
    % Normal behavior
    currentMin = 64;
    currentMax = 68;
    size = 1000;
    
     % Calculation
    calculationQuantity = 3;
    calculationAmplitudeMin = 2;
    calculationAmplitudeMax = 3;
    calculationDurationMin = size*0.06;
    calculationDurationMax = size*0.12;
    calculationTime = size*0.075;
    
    % I/O consumption
    IO_quantity = 25;
    IO_lowValue = 2;
    IO_highValue = 4;
    IO_lowDuration = size*0.005;
    IO_highDuration = size*0.02;
    IO_time = [size*0.25 size*0.3];
    
    % Temperature variation
    % The temperature function is a linear function ax+b
    % (temperatureA*temperatureDuration + temperatureB)
    temperatureQuantity = 0;
    temperatureUntilEnd = 1;
    temperatureAMin = -0.1;
    temperatureAMax = 0.1;
    temperatureB = 0;
    temperatureDurationMin = size*0.06;
    temperatureDurationMax = size*0.1;
    temperatureTime = size*0.5;
    
    % Latch-up
    latchQuantity = 1;
    latchUntilEnd = 1;
    latchValueMin = 5;
    latchValueMax = 10;
    latchDurationMin = size*0.6;
    latchDurationMax = size*0.8;
    latchTimeMin = size*0.6;
    latchTimeMax = size*0.7;
    
    % Reset
    resetQuantity = 0;
    resetOnLatch = 1;
    resetAfterLatch = size*0.075;
    resetDuration = size*0.05;
    resetTime = size*0.8;
    
    
    
 if saveData == 1
        if ~exist(folderPath, 'dir')[folderPath '/' 'dataSet.mat']
            ['Folder creation: ' folderPath]
            mkdir(folderPath);
        end
        save(fullfile(folderPath,'parametres'));
        save('parametresTemp');
        nameParamTemp = (struct2cell(whos).');
        nameParamTemp = nameParamTemp(:,1);
        csvFile = table(nameParamTemp,struct2cell(load('parametresTemp.mat')));
        writetable(csvFile,fullfile(folderPath,'parametres.csv'));
        writetable(csvFile,fullfile(folderPath,'parametres.txt'));
    end
    
    
    %%
    %Initialisation
    
    % Calculation
    calculationAmplitude = randi([calculationAmplitudeMin,calculationAmplitudeMax],1,calculationQuantity);
    calculationMin = (currentMin - calculationAmplitude).*ones(calculationQuantity);
    calculationMax = (currentMax + calculationAmplitude).*ones(calculationQuantity);
    if randomTime == 1
        calculationTime = randi([1,size],1,calculationQuantity);
    end
    calculationDuration = randi([calculationDurationMin,calculationDurationMax],1,calculationQuantity);
    
    % I/O consumption
    IO_lowValue = (IO_highValue - IO_lowValue)*rand(1,IO_quantity) + IO_lowValue;
    IO_highValue = IO_lowValue;
    if randomTime == 1
        IO_lowTime = size*rand(1,IO_quantity);
        IO_highTime = IO_lowTime;
    else
        IO_lowTime = IO_time;
        IO_highTime = IO_lowTime;
    end
    IO_lowDuration = (IO_highDuration - IO_lowDuration)*rand(1,IO_quantity) + IO_lowDuration;
    IO_highDuration = IO_lowDuration;
    
    % Temperature variation
    temperatureA = (temperatureAMax - temperatureAMin)*rand(1,temperatureQuantity) + temperatureAMin;
    temperatureB = temperatureB.*ones(temperatureQuantity);
    if randomTime == 1
        temperatureTimeMin = size*rand(1,temperatureQuantity);
        temperatureTimeMax = temperatureTimeMin;
    else
        temperatureTimeMin = temperatureTime;
        temperatureTimeMax = temperatureTime;
    end
    temperatureDuration = (temperatureDurationMax - temperatureDurationMin)*rand(1,temperatureQuantity) + temperatureDurationMin;
    if temperatureUntilEnd == 1
        temperatureUntilEnd = ones(1,temperatureQuantity);
    else
        temperatureUntilEnd = zeros(1,temperatureQuantity);
    end
    
    % Latch-up
    latchValueMin = (latchValueMax - latchValueMin)*rand(1,latchQuantity) + latchValueMin;
    latchValueMax = latchValueMin;
    if randomTime == 1
        latchTimeMin = (latchTimeMax - latchTimeMin).*rand(1, latchQuantity) + latchTimeMin;
        latchTimeMax = latchTimeMin;
    else
        latchTimeMin = latchTimeMin;
        latchTimeMax = latchTimeMax;
    end
    latchDurationMin = (latchDurationMax - latchDurationMin)*rand(1,latchQuantity) + latchDurationMin;
    latchDurationMax = latchDurationMin;
    if latchUntilEnd == 1
        latchUntilEnd = ones(1,latchQuantity);
    else
        latchUntilEnd = zeros(1,latchQuantity);
    end
    
    % Reset
    if resetOnLatch == 1
        resetTime = round(latchTimeMax(1:resetQuantity) + resetAfterLatch);
    else if randomTime == 1
            resetTime = randi([1,size],1,resetQuantity);
        end
    end
    resetDuration = resetDuration.*ones(resetQuantity);

    %%
    % Program
    
    
    % Creation of the normal behavior
    normalCurrent = (currentMax - currentMin).*rand(size,1) + currentMin;
    
    % Creation of status variable for diagnostic purpose
    statusName = ["Normal current" "Calculation" "I/O consumption" "Temperature variation" "reset" "Latch up"];
    status(1:size,1:6) = 0;
    status(1:size,12:16) = 0;
    
    % Calculation
    for i=1:calculationQuantity
        [normalCurrent, status] = calculationCurrentv2(normalCurrent, status, calculationMin(i), calculationMax(i), calculationTime(i), calculationDuration(i));
        
    end
    
    
    % I/O consumption
    for i=1:IO_quantity
        [normalCurrent, status] = IO_current(normalCurrent, status, IO_lowValue(i), IO_highValue(i), IO_lowTime(i), IO_highTime(i), IO_lowDuration(i), IO_highDuration(i));
    end
    
    
    % Temperature variation
    for i=1:temperatureQuantity
        temperatureVar = [1:1:temperatureDuration(i)];
        temperatureFunction = temperatureA(i)*temperatureVar + temperatureB(i);
        [normalCurrent, status] = temperatureVariationv2(normalCurrent, status, temperatureUntilEnd(i), temperatureFunction, temperatureTimeMin(i), temperatureTimeMax(i));
    end
    
    
    % Reset
    for i=1:resetQuantity
        %     [dataSet,status] = currentReset(normalCurrent, dataSet, status, resetTime(i), resetDuration(i));
        [normalCurrent,status] = currentReset(normalCurrent, normalCurrent, status, resetTime(i), resetDuration(i));
    end
    
    % Latch-up
    dataSet = normalCurrent;
    for i=1:latchQuantity
        [dataSet, status] = latchUpv2(dataSet,status,latchUntilEnd(i),latchValueMin(i),latchValueMax(i),latchTimeMin(i),latchTimeMax(i),latchDurationMin(i),latchDurationMax(i));
        
    end
    
    
    
    
    
    
    % Data set saves
    xData = [1:1:size].';
    diagData(:,1) = xData;
    diagData(:,2) = normalCurrent;
    diagData(:,3) = dataSet;
    statusData = status(:,[1:6 12:16]);
    diagData2 = diagData;
    diagData2(:,4:14) = status(:,[1:6 12:16]);
    
    if saveData == 1
        Header = ["Data Sets simulated by the Matlab function dataSetsGenerator","","";"Time (s)","NoLatchCurrent (mA)","LatchCurrent (mA)"];
        
        save('dataSet.mat', 'dataSet')
        dataSetTxt = [Header(1,1);"LatchCurrent (mA)";dataSet];
        save('dataSetTxt.mat','dataSetTxt')
        
        save('normalCurrent.mat', 'normalCurrent')
        normalCurrentTxt = [Header(1,1);"normalCurrent (mA)";normalCurrent];
        save('normalCurrentTxt.mat','normalCurrentTxt')
       
        save('xData.mat', 'xData')
        xDataTxt = [Header(1,1);"XValue";xData];
        save('xDataTxt.mat','xDataTxt')
        
        save('diagData.mat', 'diagData')
        diagDataTxt = [Header;diagData];
        save('diagDataTxt.mat','diagDataTxt')
        
        save('statusData.mat', 'statusData')
        statusDataTxt = [Header(1,1),"","","","","","","","","","",;
            ["Normal current" "Calculation" "I/O consumption" "Temperature variation" "reset" "Latch up"],[ "Calculation Quantity" "I/O consumption Quantity" "Temperature variation  Quantity" "reset Quantity" "Latch up Quantity"];
            statusData];
        save('statusDataTxt.mat','statusDataTxt')
        
        % Saving in a dedicated folder
        ['Saving datas in: ' folderPath]

        save([folderPath '/' 'dataSet.mat'], 'dataSet')        
        csvFile = load('dataSetTxt.mat');
        csvFile = csvFile.dataSetTxt;
        writematrix(csvFile,fullfile(folderPath,'dataSet.csv'));
        writematrix(csvFile,fullfile(folderPath,'dataSet.txt'));

        save([folderPath '/' 'normalCurrent.mat'], 'normalCurrent')
        csvFile = load('normalCurrentTxt.mat');
        csvFile = csvFile.normalCurrentTxt;
        writematrix(csvFile,fullfile(folderPath,'normalCurrent.csv'));
        writematrix(csvFile,fullfile(folderPath,'normalCurrent.txt'));

        
        save([folderPath '/' 'diagData.mat'], 'diagData')
        csvFile = load('diagDataTxt.mat');
        csvFile = csvFile.diagDataTxt;
        writematrix(csvFile,fullfile(folderPath,'diagData.csv'));
        writematrix(csvFile,fullfile(folderPath,'diagData.txt'));
        
        save([folderPath '/' 'statusData.mat'], 'statusData')
        csvFile = load('statusDataTxt.mat');
        csvFile = csvFile.statusDataTxt;
        writematrix(csvFile,fullfile(folderPath,'statusData.csv'));
        writematrix(csvFile,fullfile(folderPath,'statusData.txt'));
        
        save([folderPath '/' 'xData.mat'], 'xData')
        csvFile = load('xDataTxt.mat');
        csvFile = csvFile.xDataTxt;
        writematrix(csvFile,fullfile(folderPath,'xData.csv'));
        writematrix(csvFile,fullfile(folderPath,'xData.txt'));
        
        save(fullfile(folderPath,'workspace'))
        save('parametresTemp');
        nameParamTemp = (struct2cell(whos).');
        nameParamTemp = nameParamTemp(:,1);
        csvFile = table(nameParamTemp,struct2cell(load('parametresTemp.mat')));
        writetable(csvFile,fullfile(folderPath,'workspace.csv'));
        writetable(csvFile,fullfile(folderPath,'workspace.txt'));
    end
    
    
    % Plots
    % Simulation of a satellite device current without latch-up
    subfig = subplot(2,2,1);
    hold on
    grid on
    title('Simulation of a satellite device current without latch-up')
    xlabel('Temps (s)');
    ylabel('Current (mA)');
    ylim([0 max(dataSet)+5]);
    plot([1:1:size],normalCurrent,'color','b');
    
    % Simulation of a satellite device current with latch-up
    subplot(2,2,2);
    hold on
    grid on
    title('Simulation of a satellite device current with latch-up')
    xlabel('Temps (s)');
    ylabel('Current (mA)');
    ylim([0 max(dataSet)+5]);
    plot([1:1:size],dataSet,'color','b');
    
    % Functions inside the consumption current
    subplot(2,2,3);
    hold on
    grid on
    title('Functions inside the consumption current')
    xlabel('Temps (s)');
    ylabel('founction value');
    ylim([0 7]);
    plot([1:1:size],statusData(:,2),'linewidth',2, 'color','k');
    plot([1:1:size],statusData(:,3),'linewidth',2, 'color','m');
    plot([1:1:size],statusData(:,4),'linewidth',2, 'color','b');
    plot([1:1:size],statusData(:,5),'linewidth',2, 'color','g');
    plot([1:1:size],statusData(:,6),'linewidth',2, 'color','r');
    legend('Calculation','I/O consumption', 'Temperature variation', 'reset', 'latch-up');
    
    % Number of events happening to the consumption current
    subplot(2,2,4);
    hold on
    grid on
    title('Number of events happening to the consumption current')
    xlabel('Temps (s)');
    ylabel('events iteration');
    yticks([0:1:max(max(statusData(:,7:11)))+1]);
    ylim([0 max(max(statusData(:,7:11)))+1]);
    plot([1:1:size],statusData(:,7),'linewidth',2, 'color','k');
    plot([1:1:size],statusData(:,8),'linewidth',2, 'color','m');
    plot([1:1:size],statusData(:,9),'linewidth',2, 'color','b');
    plot([1:1:size],statusData(:,10),'linewidth',2, 'color','g');
    plot([1:1:size],statusData(:,11),'linewidth',2, 'color','r');
    legend('Calculation','I/O consumption', 'Temperature variation', 'reset', 'latch-up');
    
    if figShown == 0
        set(gcf,'visible',0);
    end
    set(gcf, 'Position', get(0, 'Screensize'));
    if saveData == 1
        saveas(subfig,fullfile(folderPath,'figure.png'));
    end
    %%
end
'Datas generation is over'

