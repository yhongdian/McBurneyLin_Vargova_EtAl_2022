function [spkVars] = getSpikeRate(spikeRaster, premature)
%define windows 
sampleRate = 2000;
cueEvoked = [0.8 1.10];
cueBase = [0.3 0.799];
baseline = [1.5 2.50];
stimBase = [2.0 2.499];
stimEvoked = [2.5 2.6]; %change 2.8 to 2.6 10/20/21 JML

%get spikes
cueSpikes = spikeRaster(:,cueEvoked(1)*sampleRate:cueEvoked(2)*sampleRate);
cueBaseSpikes = spikeRaster(:,cueBase(1)*sampleRate:cueBase(2)*sampleRate);
baselineSpikes = spikeRaster(:,baseline(1)*sampleRate:baseline(2)*sampleRate);
stimSpikes = spikeRaster(:,stimEvoked(1)*sampleRate:stimEvoked(2)*sampleRate);
stimBaseSpikes = spikeRaster(:,stimBase(1)*sampleRate:stimBase(2)*sampleRate);
baselineSpikes(premature == 1,:) = nan;
stimSpikes (premature == 1,:) = nan;
cueSpikes (premature == 1,:) = nan;

        
%calculate spike rate
cueBaseRate = sum(cueBaseSpikes,2)/diff(cueBase);
cueSpkRate = sum(cueSpikes,2)/diff(cueEvoked);
cueSpkRate = cueSpkRate - cueBaseRate;
baseSpkRate = sum(baselineSpikes,2)/diff(baseline);
stimBaseRate = sum(stimBaseSpikes,2)/diff(cueBase);
stimSpkRate = sum(stimSpikes,2)/diff(stimEvoked);
stimSpkRate = stimSpkRate - stimBaseRate;


spkVars.cueSpkRate = cueSpkRate;
spkVars.baseSpkRate = baseSpkRate;
spkVars.stimSpkRate = stimSpkRate;

end