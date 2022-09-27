function [spikeRaster, channels, trialTime, sampleRate] = genTrialRaster(prepath,mouseNum,session)
intan_folder = [prepath mouseNum '\' session];
cd(intan_folder);
ws_info = dir('*_CollatedData.mat') ;
filename = ws_info(1).name;

%load file
loadname = [prepath mouseNum '\' session '\' filename];
load(loadname);

% import variables
timeTrace = CollatedData.WStimeAlignedForAll;
channels = CollatedData.channel_info;
sampleRate = CollatedData.sampleRate;
photoDiode = CollatedData.photoDiode;
pupilInterp = CollatedData.pupilInterp;
trialSeq = CollatedData.trialNumTimeSeq;
raster = CollatedData.ScaledITraster;

%get trial lengths for all trials
for i = 1:max(trialSeq)
minTrialTime(i) = timeTrace(find((trialSeq == i),1,'last'))- timeTrace(find((trialSeq == i),1,'first'));
end

%get minimum trial length
minTrialTime = min(minTrialTime);

%set up #rows and #columns for spike raster matrix
% trialNum = #rows; trialBin = #columns
trialNum = 1:max(trialSeq);
trialBin = round(minTrialTime*sampleRate);


for k = 1:size(trialNum,2)
    first = find((trialSeq == k),1,'first');
    last = find((trialSeq == k),1,'first')+trialBin;
    spikeRaster(k,:) = zeros(1,last-first+1);
spikeRaster(k,:) = raster(first:last);
trialTime(k,:) = first:last;
end





field1 = 'spikeRaster'; field2 = 'channels'; field3 = 'trialTime';

% spikeData = struct(field1, spikeRaster, field2, channels, field3, trialTime);
% spikeData = struct(field1, spikeRaster);
% 
% filename = strrep(filename, '_CollatedData.mat', '');
% savename = [intan_folder, '\' filename '_spikeData.mat'];
% save(savename,'spikeData', '-v7.3');

end