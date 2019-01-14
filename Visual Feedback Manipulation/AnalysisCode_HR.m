%--------------------------------------------------------------------------
% Author: Akira Nagamori
% Last update: 1/11/2019
% Descriptions: 
%   Analysis test trials
%--------------------------------------------------------------------------

close all
clear all
clc

%--------------------------------------------------------------------------
dataFolder = '/Users/akiranagamori/Documents/GitHub/Experiment/Visual Feedback Manipulation/Akira Test 1-11';
codeFolder = '/Users/akiranagamori/Documents/GitHub/Experiment/Visual Feedback Manipulation';

%--------------------------------------------------------------------------
Fs_HR = 100;
CalibrationMatrix = [12.6690 0.2290 0.1050 0 0 0; 0.1600 13.2370 -0.3870  0 0 0; 1.084 0.6050 27.0920  0 0 0; ...
    0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0];

%--------------------------------------------------------------------------
cd (dataFolder)
load('MVC')
cd (codeFolder)

for i = 1:5
    
    fileName1 = ['discrete_' num2str(i)];
    fileName2 = ['playback_' num2str(i)];
    fileName3 = ['continuous_' num2str(i)];
    %fileName4 = ['compensation_reverse_' num2str(i) '_' num2str(i) '.mat'];
    
    cd (dataFolder)
    Data_1 =   dlmread(fileName1);
     
    Data_2 =   dlmread(fileName2);
       
    Data_3 =   dlmread(fileName3);       
    cd (codeFolder)
       
    HR_1(i)  = mean(Data_1(:,1));
    HRV_1(i)  = std(Data_1(:,1));
    HR_2(i)  = mean(Data_2(:,1));
    HRV_2(i)  = std(Data_2(:,1));
    HR_3(i)  = mean(Data_3(:,1));
    HRV_3(i)  = std(Data_3(:,1));
    
    time = [1:length(Data_1(:,1))]/Fs_HR;
    figure(1)
    plot(time,Data_1(:,1))
    ylim([60 110])
    hold on
    
    figure(2)
    plot(time,Data_2(:,1))
    ylim([60 110])
    hold on
    
    figure(3)
    plot(time,Data_3(:,1))
    ylim([60 110])
    hold on
    
end

figure(1)
legend('1','2','3','4','5')

figure(2)
legend('1','2','3','4','5')

figure(3)
legend('1','2','3','4','5')

HR_All = [HR_1',HR_2',HR_3'];
HRV_All = [HRV_1',HRV_2',HRV_3'];

figure(4)
boxplot(HR_All)
title('Mean Heart Rate')
set(gca,'xtick',1:3, 'xticklabel',{'Discrete FB','Comensation','Continuous FB'})

figure(5)
boxplot(HRV_All)
title('Heart Rate Variability')
set(gca,'xtick',1:3, 'xticklabel',{'Discrete FB','Comensation','Continuous FB'})
