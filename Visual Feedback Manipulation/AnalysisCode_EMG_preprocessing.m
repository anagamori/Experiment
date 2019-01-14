%--------------------------------------------------------------------------
% Author: Akira Nagamori
% Last update: 11/20/2018
% Descriptions: 
%   EMG preprocessing
%--------------------------------------------------------------------------

close all
clear all
clc

%--------------------------------------------------------------------------
dataFolder = '/Users/akiranagamori/Documents/GitHub/Experiment/Visual Feedback Manipulation/Akira Test 1-11';
codeFolder = '/Users/akiranagamori/Documents/GitHub/Experiment/Visual Feedback Manipulation';

%--------------------------------------------------------------------------
Fs = 1000;
CalibrationMatrix = [12.6690 0.2290 0.1050 0 0 0; 0.1600 13.2370 -0.3870  0 0 0; 1.084 0.6050 27.0920  0 0 0; ...
    0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0];

%--------------------------------------------------------------------------
cd (dataFolder)
load('MVC')
cd (codeFolder)

Frequency = 50;
kernel = gausswin(2*Fs)./sum(gausswin(1*Fs));
EMG_1_all = cell(1,10);
EMG_2_all = cell(1,10);
EMG_3_all = cell(1,10);
%
for i = 1:5
    
    fileName1 = ['discrete_' num2str(i) '.mat'];
    fileName2 = ['compensation_' num2str(i) '.mat'];
    fileName3 = ['continuous_' num2str(i) '.mat'];
    
      
    cd (dataFolder)
    load (fileName1)
    Data_EMG_temp = dlmread([fileName1],'',10,0);  
    cd (codeFolder)      
    EMG_1 = PreProcessing(Data_EMG_temp(:,1:6),Frequency);
    EMG_1_all{i} = EMG_1;
    
    cd (dataFolder)
    Data_EMG_temp = dlmread([fileName2],'',10,0);
    cd (codeFolder)      
    EMG_2 = PreProcessing(Data_EMG_temp(:,1:6),Frequency);
    EMG_2_all{i} = EMG_2;
    
    cd (dataFolder)
    Data_EMG_temp = dlmread([fileName3],'',10,0); 
    cd (codeFolder)      
    EMG_3 = PreProcessing(Data_EMG_temp(:,1:6),Frequency);
    EMG_3_all{i} = EMG_3;
    
    cd (codeFolder)          
    
end

cd (dataFolder)
save('EMG_1','EMG_1_all')
save('EMG_2','EMG_2_all')
save('EMG_3','EMG_3_all')
cd (codeFolder)    
