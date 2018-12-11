%--------------------------------------------------------------------------
% Author: Akira Nagamori
% Last update: 12/04/2018
% Descriptions: 
%   Compute coherence using spectrum-based method and mscoherece function
%   in matlab
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

C_1_all = [];
C_2_all = [];
C_3_all = [];

C_1_ms_all = [];
C_2_ms_all = [];
C_3_ms_all = [];

window = hann(1*Fs);
overlap = length(window)*0.9;
ncycle = 5;
freqs = 0.5:0.5:50;
%
for i = 1:10
    
   
    cd (dataFolder)
    load ('Data_1_all')   
    cd (codeFolder)
%     temp_1 = conv(Data_1_all(:,2),hann(5*Fs));
%     temp_1 = temp_1(1:5*Fs);
%     temp_2 = conv(Data_1_all(:,3),hann(5*Fs));
%     temp_2 = temp_2(1:5*Fs);
    [C_1_ms,freqs] = mscohere(Data_1_all(:,2)-mean(Data_1_all(:,2)),Data_1_all(:,3)-mean(Data_1_all(:,3)),window,overlap,freqs,Fs);
    [time,freqs,C_1_temp] = waveletCoherence(Data_1_all(:,2)-mean(Data_1_all(:,2)),Data_1_all(:,3)-mean(Data_1_all(:,3)),Fs,freqs,ncycle);
    %[time,freqs,C_1_temp] = waveletCoherence(temp_1-mean(temp_1),temp_2-mean(temp_2),Fs,freqs,ncycle);
    C_1 = mean(C_1_temp,2);
    C_1 = C_1';
    cd (dataFolder)
    load ('Data_2_all')
    cd (codeFolder)
    [C_2_ms,~] = mscohere(Data_2_all(:,2)-mean(Data_2_all(:,2)),Data_2_all(:,3)-mean(Data_2_all(:,3)),window,overlap,freqs,Fs);
    [~,~,C_2_temp] = waveletCoherence(Data_2_all(:,2)-mean(Data_2_all(:,2)),Data_2_all(:,3)-mean(Data_2_all(:,3)),Fs,freqs,ncycle);
    C_2 = mean(C_2_temp,2);
    C_2 = C_2';
    cd (dataFolder)
    load ('Data_3_all')
    cd (codeFolder)
    [C_3_ms,~] = mscohere(Data_3_all(:,2)-mean(Data_3_all(:,2)),Data_3_all(:,3)-mean(Data_3_all(:,3)),window,overlap,freqs,Fs);
    [~,~,C_3_temp] = waveletCoherence(Data_3_all(:,2)-mean(Data_3_all(:,2)),Data_3_all(:,3)-mean(Data_3_all(:,3)),Fs,freqs,ncycle);
    C_3 = mean(C_3_temp,2);
    C_3 = C_3';

           
    C_1_all = [C_1_all;C_1];
    C_2_all = [C_2_all;C_2];
    C_3_all = [C_3_all;C_3];
    
    C_1_ms_all = [C_1_ms_all;C_1_ms];
    C_2_ms_all = [C_2_ms_all;C_2_ms];
    C_3_ms_all = [C_3_ms_all;C_3_ms];
end

%%
figure(1)
plot(freqs,mean(C_1_all),'b','LineWidth',2)
hold on 
plot(freqs,mean(C_2_all),'r','LineWidth',2)
plot(freqs,mean(C_3_all),'g','LineWidth',2)
hold off
title('Spectgram-based coherence Function')
legend('Discrete FB','Comensation','Continuous FB')
xlabel('Frequency (Hz)','FontSize',14)
ylabel('Coherence','FontSize',14)

figure(2)
plot(freqs,mean(C_1_ms_all),'b','LineWidth',2)
hold on 
plot(freqs,mean(C_2_ms_all),'r','LineWidth',2)
plot(freqs,mean(C_3_ms_all),'g','LineWidth',2)
hold off
title('Mscohere Function')
legend('Discrete FB','Comensation','Continuous FB')
xlabel('Frequency (Hz)','FontSize',14)
ylabel('Coherence','FontSize',14)
