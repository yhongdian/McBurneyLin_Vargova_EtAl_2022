% LC flexibility - Figure 3b

clear all; clc; close all

% import intan and pupil


% --------   TEST
data(1).intan_folder = 'E:\JML_Tetrode\JIMBi028\0204_ISO';    % Test 3
data(2).intan_folder = 'E:\JML_Tetrode\JIMBi030\0310';   
data(3).intan_folder = 'F:\JML_Tetrode\JIMBi042\pupillometry\1101'; % Test 4  

% ----- CONTROL
% data(1).intan_folder = 'E:\JML_Tetrode\JIMBi031\0510'; 
% data(2). intan_folder = 'F:\JML_Tetrode\JIMBi040\pupillometry\1014'; 


%% load intan files
alldata = [];
for jj = 1:length(data)
    
    
cd(data(jj).intan_folder);
intan_info = dir('*.rhd');
num_intanfiles = size(intan_info,1);

timeIT =  cell(1,num_intanfiles);
slidIT =  cell(1,num_intanfiles);
frameIT =  cell(1,num_intanfiles);
optoIT =  cell(1,num_intanfiles);
%-----------load data-------------
for i = 1:num_intanfiles
                
                
                Intanfilename = intan_info(i).name;
                fprintf('\n'); disp(i); disp(Intanfilename);
                
                s = Intan.Sweep(Intanfilename);
                
                timeIT{1,i} = s.timeRawSignal;
                slidIT{1,i} = s.boardADCRawSignal(1,:);
                
                frameIT{1,i} = s.boardADCRawSignal(2,:);
                optoIT{1,i} = s.boardADCRawSignal(3,:);
                
            end
            
            samprateIT = s.sampleRate;
            
            timeIT = cell2mat(timeIT);
            slidIT = cell2mat(slidIT);
            frameIT = cell2mat(frameIT);
            optoIT = cell2mat(optoIT);


disp('load Intan file...');
% s = Intan.Sweep(intan_path);
% timeIT = s.timeRawSignal;
% slidIT = s.boardADCRawSignal(1,:);
% frameIT = s.boardADCRawSignal(2,:);
frameIT = medfilt1(frameIT);
% optoIT = s.boardADCRawSignal(3,:);
sampRateIT = s.sampleRate;
sampRateDLC = 20; %change if necessary

disp('Done!');



%% import DLC csv

%----------path info---------------
pupil_info = dir('*.csv');
Pupilfilename = pupil_info(1).name;
%-----------load data-------------
disp('load pupil tracking file...');

csv = csvread(Pupilfilename, 3, 0);
[pupily, pval, pupilAxisLabel] = findPupilAxis(csv);
pval = pval > 0.6 ;

pupily = medfilt1(pupily,10,'truncate');


disp('Done!');

%% align csv to intan

%---------intan frame pulse times -----------
filt_frameIT = frameIT < 2;
frame_pulses = diff(filt_frameIT);
frameON = frame_pulses == -1;
frameOFF = frame_pulses == 1;

%-------- opto stim times ----------
filt_optoIT = optoIT > 1;
opto_pulses = diff(filt_optoIT);
optoOFF = opto_pulses<-0.5;
optoON = opto_pulses>0.5;
opto_times = find(optoON == 1);
h = diff(opto_times);
optoTrain = [opto_times(1) opto_times(find(h>50000)+1)];


%------------ plot frame pulse overlay ----------------
% plot(frameIT);

%--------DLC frames ------------------

x = find(frameON == 1);

disp(['Intan pulses:' num2str(length(x)) ',' ' ''Video frames:' num2str(length(pupily))]);

if abs(length(x) - length(pupily)) > 150
    disp('!! frame length mismatch !!'); return;
end

pupily_zs = zscore(pupily);
x = x(1:length(pupily_zs));


%% plot PSTH
windowSize = [-5 5]; %window size in seconds

windowIT = windowSize * sampRateIT;
%----------random stim times for control ---------

randTrain = randsample(x(1)+windowIT(2):x(end)+windowIT(1), 200);
pupilResp = zeros(1,200);

for i = [1:length(optoTrain)]
    optoWindow = optoTrain(i) + windowIT;
    xPos = find(x>= optoWindow(1) & x<= optoWindow(2));
    if length(xPos)<200
       xPos = [xPos (xPos(end)+1)];
    else
    xPos = xPos(1:200);
    end
    pupilResp(i,:) = pupily_zs(xPos)';
    
end

%pupil baseline adjust
pupilBase = mean(pupilResp(:,60:100),2); %get mean baseline -2:0 s
pupilResp = pupilResp - pupilBase; %subtract baseline from pupil

%exclusion
preWindow_pupilResp = pupilResp(:, 1:100);
duringWindow = pupilResp(:, 120:180);
idx = ~any(abs(preWindow_pupilResp)>0.75,2);

goodtrials = pupilResp(idx,:);

randpupilResp = zeros(1,200);
for i = 1:length(randTrain)
    randWindow = randTrain(i) + windowIT;
    xPos = [find(x>= randWindow(1) & x<= randWindow(2))];
    if length(xPos)<200
       xPos = [xPos (xPos(end)+1)];
    end
    xPos = xPos(1:200);
    
    randpupilResp(i,:) = pupily(xPos)';
end
randpupilResp = zscore(randpupilResp,1,2);



stimTrials = [1:size(goodtrials,1)]; 

val = 1 ;

pupilRespfilt = pupilResp;
pupilRespfilt = goodtrials;
mean_pupilResp = median(pupilRespfilt,1);

mean_randpupilResp = median(randpupilResp,1);

base_adj = nanmean(mean_pupilResp(1,length(randpupilResp)/2-40:length(randpupilResp)/2));
adj_pupilResp = mean_pupilResp - base_adj;
adj_pupilResp = smooth(adj_pupilResp)';


alldata = cat(1,alldata,adj_pupilResp);

end % sessions


%% plot average pupil
adjStd = smooth((nanstd(alldata)/size(alldata,1)))';
plot([-5:0.05:4.95], mean(alldata), 'r'); hold on;
plot([-5:0.05:4.95],mean(alldata) + adjStd, 'r--');
plot([-5:0.05:4.95], mean(alldata) - adjStd, 'r--');
title('Control vs Test');
xlabel('Time(s)');





