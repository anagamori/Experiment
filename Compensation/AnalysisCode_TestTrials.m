%--------------------------------------------------------------------------
% Author: Akira Nagamori
% Last update: 11/20/2018
% Descriptions: 
%   Analysis test trials
%       
%--------------------------------------------------------------------------

close all
clear all
clc

%--------------------------------------------------------------------------
dataFolder = '/Users/akiranagamori/Documents/GitHub/Experiment/Compensation/Data_Akira_Nov20';
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
for i = 1:5
    
    fileName1 = ['noFB_' num2str(i) '.mat'];
    fileName2 = ['continuousFB_' num2str(i) '.mat'];
    fileName3 = ['compensation_' num2str(i) '_' num2str(i) '.mat'];
    fileName4 = ['compensation_reverse_' num2str(i) '_' num2str(i) '.mat'];
    
    cd (dataFolder)
    load (fileName1)
       
    Force_RawVoltage_1 = data.values(8:13,:)'-data.offset';
    Force_Newton_1 = Force_RawVoltage_1*CalibrationMatrix;
    Force_1 = abs(Force_Newton_1(:,3))./MVC*100;
    for j = 5001:length(Force_1)
        mean_Force_1 = mean(Force_1(j-5*Fs:j));
        SD_Force_1 = std(Force_1(j-5*Fs:j));
        CoV_Force_1(j-5000) = SD_Force_1/mean_Force_1*100;      
    end
    [CoV_1(i),loc] = min(CoV_Force_1);
    Force_1_segment = Force_1(loc:5*Fs+loc);
    Force_1_segment_Newton = abs(Force_Newton_1(loc:5*Fs+loc,3));
    [pxx_1_temp,freq] = pwelch(Force_1_segment_Newton-mean(Force_1_segment_Newton),[],[],0:0.1:30,Fs,'power');
    clear CoV_Force_1
    
    load (fileName2)
    Force_RawVoltage_2 = data.values(8:13,:)'-data.offset';
    Force_Newton_2 = Force_RawVoltage_2*CalibrationMatrix;
    Force_2 = abs(Force_Newton_2(:,3))./MVC*100;
    for j = 5001:length(Force_2)
        mean_Force_2 = mean(Force_2(j-5*Fs:j));
        SD_Force_2 = std(Force_2(j-5*Fs:j));
        CoV_Force_2(j-5000) = SD_Force_2/mean_Force_2*100;      
    end
    [CoV_2(i),loc] = min(CoV_Force_2);
    Force_2_segment = Force_2(loc:5*Fs+loc);
    Force_2_segment_Newton = abs(Force_Newton_2(loc:5*Fs+loc,3));
    [pxx_2_temp,~] = pwelch(Force_2_segment_Newton-mean(Force_2_segment_Newton),[],[],0:0.1:30,Fs,'power');
    clear CoV_Force_2
    
    
    load (fileName3)
    Force_RawVoltage_3 = data.values(8:13,:)'-data.offset';
    Force_Newton_3 = Force_RawVoltage_3*CalibrationMatrix;
    Force_3 = abs(Force_Newton_3(:,3))./MVC*100;
    for j = 5001:length(Force_3)
        mean_Force_3 = mean(Force_3(j-5*Fs:j));
        SD_Force_3 = std(Force_3(j-5*Fs:j));
        CoV_Force_3(j-5000) = SD_Force_3/mean_Force_3*100;
    end
    [CoV_3(i),loc] = min(CoV_Force_3);
    Force_3_segment_Newton = abs(Force_Newton_3(loc:5*Fs+loc,3));
    [pxx_3_temp,~] = pwelch(Force_3_segment_Newton-mean(Force_3_segment_Newton),[],[],0:0.1:30,Fs,'power');
    clear CoV_Force_3
%     
    load (fileName4)
    Force_RawVoltage_4 = data.values(8:13,:)'-data.offset';
    Force_Newton_4 = Force_RawVoltage_4*CalibrationMatrix;
    Force_4 = abs(Force_Newton_4(:,3))./MVC*100;
    for j = 5001:length(Force_4)
        mean_Force_4 = mean(Force_4(j-5*Fs:j));
        SD_Force_4 = std(Force_4(j-5*Fs:j));
        CoV_Force_4(j-5000) = SD_Force_4/mean_Force_4*100;
    end
    [CoV_4(i),loc] = min(CoV_Force_4);
    Force_4_segment_Newton = abs(Force_Newton_4(loc:5*Fs+loc,3));
    [pxx_4_temp,~] = pwelch(Force_4_segment_Newton-mean(Force_4_segment_Newton),[],[],0:0.1:30,Fs,'power');
    clear CoV_Force_4
       
    cd (codeFolder)
       
    pxx_1(i,:) = pxx_1_temp;
    pxx_2(i,:) = pxx_2_temp;
    pxx_3(i,:) = pxx_3_temp;
    pxx_4(i,:) = pxx_4_temp;
   
    
    pxx_norm_1(i,:) = pxx_1_temp./sum(pxx_1_temp);
    pxx_norm_2(i,:) = pxx_2_temp./sum(pxx_2_temp);
    pxx_norm_3(i,:) = pxx_3_temp./sum(pxx_3_temp);
    pxx_norm_4(i,:) = pxx_4_temp./sum(pxx_4_temp);
   
    
end

for f = 1:length(freq)
    [h,p(f)] = ttest(pxx_1(:,f),pxx_2(:,f));
    if p(f) > 0.2
        p(f) = 0.2;
    end
end

CoV_All = [CoV_1',CoV_2',CoV_3',CoV_4'];
% pxx_All = [mean(pxx_5);mean(pxx_6);mean(pxx_3);mean(pxx_4);mean(pxx_1);mean(pxx_2)];
% pxx_norm_All = [mean(pxx_norm_5);mean(pxx_norm_6);mean(pxx_norm_3);mean(pxx_norm_4);mean(pxx_norm_1);mean(pxx_norm_2)];
% %CoV_All = [CoV_5',CoV_6'];
% cd (subjectFolder)
% save([subjectID '_CoV'],'CoV_All')
% save([subjectID '_pxx'],'pxx_All')
% save([subjectID '_pxx_norm'],'pxx_norm_All')
% cd (codeFolder)

figure(1)
boxplot(CoV_All)
% figure(1)
% bar([min(CoV_1*100),min(CoV_2*100),min(CoV_3*100),min(CoV_4*100),min(CoV_5*100),min(CoV_6*100)])
% 
% figure(2)
% bar([mean(MAD_1),mean(MAD_2),mean(MAD_3),mean(MAD_4),mean(MAD_5),mean(MAD_6)])
% 

% figure(1)
% ksdensity(CoV_1)
% hold on
% ksdensity(CoV_2)
% legend('Low Gain','High Gain')
% %
% % figure(2)
% % histogram(CoV_1)
% % hold on
% % histogram(CoV_2)
% % legend('Low Gain','High Gain')
% %

figure(3)
plot(freq,mean(pxx_1),'LineWidth',2)
hold on 
plot(freq,mean(pxx_2),'LineWidth',2)
hold on 
plot(freq,mean(pxx_3),'LineWidth',2)
plot(freq,mean(pxx_4),'LineWidth',2)
legend('Discrete FB','Continuous FB','Incongruent Comensation','Congruent Comensation')

figure(4)
plot(freq,mean(pxx_norm_1),'LineWidth',2)
hold on 
plot(freq,mean(pxx_norm_2),'LineWidth',2)
hold on 
plot(freq,mean(pxx_norm_3),'LineWidth',2)
plot(freq,mean(pxx_norm_4),'LineWidth',2)
legend('Discrete FB','Continuous FB','Incongruent Comensation','Congruent Comensation')

figure(5)
subplot(2,1,1)
plot(freq,mean(pxx_1),'LineWidth',2)
hold on 
plot(freq,mean(pxx_2),'LineWidth',2)
subplot(2,1,2)
plot(freq,p,'LineWidth',2)

