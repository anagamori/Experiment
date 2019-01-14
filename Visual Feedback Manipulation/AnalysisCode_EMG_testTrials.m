%--------------------------------------------------------------------------
% Author: Akira Nagamori
% Last update: 12/04/2018
% Descriptions: 
%   Extract 5-sec EMG signals from each trial
%--------------------------------------------------------------------------

close all
clear all
clc

%--------------------------------------------------------------------------
dataFolder = '/Users/akira/Documents/GitHub/Experiment/Visual Feedback Manipulation/Akira Test 1-11';
codeFolder = '/Users/akira/Documents/GitHub/Experiment/Visual Feedback Manipulation';

%--------------------------------------------------------------------------
Fs = 1000;
CalibrationMatrix = [12.6690 0.2290 0.1050 0 0 0; 0.1600 13.2370 -0.3870  0 0 0; 1.084 0.6050 27.0920  0 0 0; ...
    0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0];

%--------------------------------------------------------------------------
cd (dataFolder)
load('MVC')
cd (codeFolder)

Frequency = 100;
[b,a] = butter(4,10/(Fs/2),'low');
%
for i = 1:5
    
    fileName1 = ['discrete_' num2str(i) '.mat'];
    fileName2 = ['playback_' num2str(i) '.mat'];
    fileName3 = ['continuous_' num2str(i) '.mat'];
    
    cd (dataFolder)
    load (fileName1)
    cd (codeFolder)
    Force_RawVoltage_1 = data.values(8:13,:)'-data.offset';
    Force_Newton_1 = Force_RawVoltage_1*CalibrationMatrix;
    Force_1 = abs(Force_Newton_1(:,3))./MVC*100;
    for j = 5001:length(Force_1)
        mean_Force_1 = mean(Force_1(j-5*Fs:j));
        SD_Force_1 = std(Force_1(j-5*Fs:j));
        CoV_Force_1(j-5000) = SD_Force_1/mean_Force_1*100;      
    end
    [~,loc] = min(CoV_Force_1);
    Force_1_segment = Force_1(loc:5*Fs+loc);
    EMG_1_temp = data.values(4:7,:)'; 
    EMG_1_processed = PreProcessing(EMG_1_temp,Frequency);
    EMG_FCR_1 = filtfilt(b,a,EMG_1_processed(loc:5*Fs+loc,1));
    mean_EMG_FCR_1(i) = mean(EMG_FCR_1);
    clear CoV_Force_1
    
    cd (dataFolder)
    load (fileName2)
    cd (codeFolder)
    Force_RawVoltage_2 = data.values(8:13,:)'-data.offset';
    Force_Newton_2 = Force_RawVoltage_2*CalibrationMatrix;
    Force_2 = abs(Force_Newton_2(:,3))./MVC*100;
    for j = 5001:length(Force_2)
        mean_Force_2 = mean(Force_2(j-5*Fs:j));
        SD_Force_2 = std(Force_2(j-5*Fs:j));
        CoV_Force_2(j-5000) = SD_Force_2/mean_Force_2*100;      
    end
    [~,loc] = min(CoV_Force_2);
    Force_2_segment = Force_2(loc:5*Fs+loc);
    EMG_2_temp = data.values(4:7,:)'; 
    EMG_2_processed = PreProcessing(EMG_2_temp,Frequency);
    EMG_FCR_2 = filtfilt(b,a,EMG_2_processed(loc:5*Fs+loc,1));
    mean_EMG_FCR_2(i) = mean(EMG_FCR_2);
    clear CoV_Force_2
    
    cd (dataFolder)
    load (fileName3)
    cd (codeFolder)
    Force_RawVoltage_3 = data.values(8:13,:)'-data.offset';
    Force_Newton_3 = Force_RawVoltage_3*CalibrationMatrix;
    Force_3 = abs(Force_Newton_3(:,3))./MVC*100;
    for j = 5001:length(Force_3)
        mean_Force_3 = mean(Force_3(j-5*Fs:j));
        SD_Force_3 = std(Force_3(j-5*Fs:j));
        CoV_Force_3(j-5000) = SD_Force_3/mean_Force_3*100;
    end
    [~,loc] = min(CoV_Force_3);
    Force_3_segment = Force_3(loc:5*Fs+loc);
    EMG_3_temp = data.values(4:7,:)'; 
    EMG_3_processed = PreProcessing(EMG_3_temp,Frequency);
    EMG_FCR_3 = filtfilt(b,a,EMG_3_processed(loc:5*Fs+loc,1));
    mean_EMG_FCR_3(i) = mean(EMG_FCR_3);
    
    clear CoV_Force_3
       
    cd (codeFolder)
           
end

EMG_amp_All = [mean_EMG_FCR_1',mean_EMG_FCR_2',mean_EMG_FCR_3'];
figure(1)
boxplot(EMG_amp_All)
set(gca,'xtick',1:3, 'xticklabel',{'Discrete FB','Comensation','Continuous FB'})



