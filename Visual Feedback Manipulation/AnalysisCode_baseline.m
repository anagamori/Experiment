%--------------------------------------------------------------------------
% Author: Akira Nagamori
% Last update: 11/20/2018
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
Fs = 1000;
CalibrationMatrix = [12.6690 0.2290 0.1050 0 0 0; 0.1600 13.2370 -0.3870  0 0 0; 1.084 0.6050 27.0920  0 0 0; ...
    0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0];

%--------------------------------------------------------------------------
cd (dataFolder)
load('MVC')
cd (codeFolder)

time = [1:15*Fs]/Fs;

[b_low,a_low] = butter(4,30/(Fs/2),'low');
[b,a] = butter(4,0.5/(Fs/2),'high');

Frequency = 100;

time_segment = 0:1/Fs:5;
%
for i = 1:5
    
    fileName = ['baseline_' num2str(i) '.mat'];
    
    cd (dataFolder)
    load (fileName)
    cd (codeFolder)  
    
    %----------------------------------------------------------------------
    % Analyze force
    Force_RawVoltage = data.values(8:13,:)'-data.offset';
    Force_Newton = Force_RawVoltage*CalibrationMatrix;
    Force = abs(Force_Newton(:,3))./MVC*100;
    Force = filtfilt(b_low,a_low,Force);
    
    Force_segment = Force(5*Fs:10*Fs);
    mean_Force = mean(Force_segment);
    Force_detrend = detrend(Force_segment);
    Force_filt = filtfilt(b,a,Force_segment);
    CoV(i) = std(Force_segment)/mean_Force;
    CoV_detrend(i) = std(Force_detrend)/mean_Force;
    CoV_filt(i) = std(Force_filt)/mean_Force;
    [pxx_temp,freq] = pwelch(Force_segment-mean(Force_segment),[],[],0:0.1:30,Fs,'power');
          
    pxx(i,:) = pxx_temp;    
    pxx_norm(i,:) = pxx_temp./sum(pxx_temp);
    
    figure(1)
    plot(time,Force(1:length(time)))
    hold on
   
    figure(2)
    plot(Force_segment-mean_Force)
    hold on 
    plot(Force_detrend)
    hold on 
    plot(Force_filt)      
    %----------------------------------------------------------------------
    % Analyze EMG
    EMG = PreProcessing(data.values(4:7,:)',Frequency);
    EMG_1 = zscore(EMG(:,1));
    EMG_1 = conv(EMG_1,hann(0.2*Fs));
    EMG_1 = EMG_1(1:length(Force));
    EMG_1_segment = EMG_1(5*Fs:10*Fs);
    EMG_2 = zscore(EMG(:,2));
    EMG_2 = conv(EMG_2,hann(0.2*Fs));
    EMG_2 = EMG_2(1:length(Force));
    EMG_2_segment = EMG_2(5*Fs:10*Fs);
       
    figure(3)
    plot(time,EMG_1(1:length(time)))
    hold on 
    
end

% figure(1)
% legend('Trial 1','Trial 2','Trial 3','Trial 4','Trial 5')

figure(2)
legend('Raw','Detrend','High-pass')

% 
figure(4)
plotyy(time_segment,Force_segment,time_segment,EMG_1(5*Fs:10*Fs))

figure(5)
[corr,lags] = xcorr(Force_segment-mean(Force_segment),EMG_1_segment-mean(EMG_1_segment),'coeff');
plot(lags,corr)
hold on
[corr,lags] = xcorr(Force_detrend,EMG_1_segment-mean(EMG_1_segment),'coeff');
plot(lags,corr)
hold on
[corr,lags] = xcorr(Force_filt,EMG_1_segment-mean(EMG_1_segment),'coeff');
plot(lags,corr)
legend('Raw','Detrend','High-pass')