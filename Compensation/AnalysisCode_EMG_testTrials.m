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
dataFolder = '/Users/akiranagamori/Documents/GitHub/Experiment/Compensation/Akira_Nov26';
codeFolder = '/Users/akiranagamori/Documents/GitHub/Experiment/Compensation';

%--------------------------------------------------------------------------
Fs = 1000;
CalibrationMatrix = [12.6690 0.2290 0.1050 0 0 0; 0.1600 13.2370 -0.3870  0 0 0; 1.084 0.6050 27.0920  0 0 0; ...
    0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0];

%--------------------------------------------------------------------------
cd (dataFolder)
load('MVC')
cd (codeFolder)

kernel = gausswin(2*Fs)./sum(gausswin(1*Fs));
%
for i = 1:10
    
    fileName1 = ['discrete_2_' num2str(i) '.mat'];
    fileName2 = ['compensation_2_' num2str(i) '.mat'];
    fileName3 = ['continuous_' num2str(i) '.mat'];
    
    cd (dataFolder)
    load (fileName1)
    load ('EMG_1')   
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
    EMG_1_temp = EMG_1_all{i};
    Data_1_all = [Force_1_segment EMG_1_temp(loc:5*Fs+loc,:)];
    clear CoV_Force_1
    
    load (fileName2)
    load ('EMG_2')   
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
    EMG_2_temp = EMG_2_all{i};
    Data_2_all = [Force_2_segment EMG_2_temp(loc:5*Fs+loc,:)];
    clear CoV_Force_2
    
    load (fileName3)
    load ('EMG_3')   
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
    EMG_3_temp = EMG_3_all{i};
    Data_3_all = [Force_3_segment EMG_3_temp(loc:5*Fs+loc,:)];;
    clear CoV_Force_3
       
    cd (codeFolder)
           
end

cd (dataFolder)
save('Data_1_all','Data_1_all')
save('Data_2_all','Data_2_all')
save('Data_3_all','Data_3_all')
cd (codeFolder)    