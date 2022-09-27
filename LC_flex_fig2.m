% LC flexibility - Figure 2

clear all; close all



%% Figure 2e

pairs = [399 403 901 908 909 910 1661]; %all paired sessions

allBadPreRast = cell(length(pairs),1);
allBadCueRast = cell(length(pairs),1);
allGoodPreRast = cell(length(pairs),1);
allGoodCueRast = cell(length(pairs),1);
x = 1;

for zz = pairs
    %---------- load file
        [path, mouse, date, cutoff] = LC_Flexibility_sessionIdx(zz);
        intan_folder = [path mouse '\' date];
        cd(intan_folder);
        ws_info = dir('*spkAndBehaviorVars.mat') ;
        filename = ws_info(1).name;
        load(filename);

        [spikeRaster, channels, trialTime, sampleRate] = ...
        genTrialRaster(path,mouse,date);
    
    behVars = combVars.behVars;
    goodSwitches = behVars.goodSwitches;
    
    if zz == 399 %%session has two good switches, first switch is best
        goodSwitches(2) = 0; %eliminate second good switch for paired comparison
    end
    
    badSwitches = behVars.badSwitches;
    Cswitch = behVars.Cswitch;
    CswitchHat = Cswitch(2:end);
    cuestop = behVars.cuestop;
    cuestopHat = cuestop(2:end);
    badIdx = CswitchHat(badSwitches);
    badCuestop = cuestopHat(badSwitches);
    goodIdx = CswitchHat(goodSwitches);
    goodCuestop = cuestopHat(goodSwitches);
    
    badTrials = [badIdx-20:badIdx-1 badIdx:badIdx+20];
    goodTrials = [goodIdx-20:goodIdx-1 goodIdx:goodIdx+20];
    
    badRast = spikeRaster(badTrials,1:11000);
    goodRast = spikeRaster(goodTrials,1:11000);
    
    
    allBadPreRast{x,1} = badRast(1:20,:);
    allBadCueRast{x,1} = badRast(21:40,:);
    allGoodPreRast{x,1} = goodRast(1:20,:);
    allGoodCueRast{x,1} = goodRast(21:40,:);
    
    x = x+1;
end

allBadPreRast = cell2mat(allBadPreRast);
allBadCueRast = cell2mat(allBadCueRast);
allGoodPreRast = cell2mat(allGoodPreRast);
allGoodCueRast = cell2mat(allGoodCueRast);

sampRate = 2000;
windowSize = 300;
timeFrac = windowSize/sampRate;

smGoodPreRast = movsum(allGoodPreRast,[windowSize 0],2,'Endpoints', 'fill')/timeFrac;
smGoodCueRast = movsum(allGoodCueRast,[windowSize 0],2,'Endpoints', 'fill')/timeFrac;

smBadPreRast = movsum(allBadPreRast,[windowSize 0],2,'Endpoints', 'fill')/timeFrac;
smBadCueRast = movsum(allBadCueRast,[windowSize 0],2,'Endpoints', 'fill')/timeFrac;


%---mean and SEM 

meanBadPreRast = mean(smBadPreRast,1);
meanBadPreRast = fillmissing(meanBadPreRast,'linear'); 
stdBadPreRast = std(smBadPreRast,1)/sqrt(size(smBadPreRast,1));
stdBadPreRast = fillmissing(stdBadPreRast,'linear'); 
meanBadCueRast = mean(smBadCueRast,1);
meanBadCueRast = fillmissing(meanBadCueRast,'linear'); 
stdBadCueRast = std(smBadCueRast,1)/sqrt(size(smBadCueRast,1));
stdBadCueRast = fillmissing(stdBadCueRast,'linear'); 

meanGoodPreRast = mean(smGoodPreRast,1);
meanGoodPreRast = fillmissing(meanGoodPreRast,'linear'); 
stdGoodPreRast = std(smGoodPreRast,1)/sqrt(size(smGoodPreRast,1));
stdGoodPreRast = fillmissing(stdGoodPreRast,'linear'); 
meanGoodCueRast = mean(smGoodCueRast,1);
meanGoodCueRast = fillmissing(meanGoodCueRast,'linear'); 
stdGoodCueRast = std(smGoodCueRast,1)/sqrt(size(smGoodCueRast,1));
stdGoodCueRast = fillmissing(stdGoodCueRast,'linear'); 

plotWindow = 1:11000;
x = linspace(0,5.5,plotWindow(end));
x = x';

figure;
hold on;

fill([x;flipud(x)],[movmean(meanGoodPreRast(plotWindow)'-stdGoodPreRast(plotWindow)',windowSize);flipud(movmean(meanGoodPreRast(plotWindow)'+stdGoodPreRast(plotWindow)',windowSize))],'k','linestyle','none', 'FaceAlpha', 0.25);hold on
plot(x,movmean(meanGoodPreRast(plotWindow), windowSize, 'omitnan'),'k');
fill([x;flipud(x)],[movmean(meanGoodCueRast(plotWindow)'-stdGoodCueRast(plotWindow)',windowSize);flipud(movmean(meanGoodCueRast(plotWindow)'+stdGoodCueRast(plotWindow)',windowSize))],'b','linestyle','none', 'FaceAlpha', 0.25);
plot(x,movmean(meanGoodCueRast(plotWindow), windowSize, 'omitnan'),'b')

hold off;
ylabel('Firing Rate (Spk/s)')
xlabel('Time (s)')
title('Good Switches')

figure;
hold on
fill([x;flipud(x)],[movmean(meanBadPreRast(plotWindow)'-stdBadPreRast(plotWindow)',windowSize);flipud(movmean(meanBadPreRast(plotWindow)'+stdBadPreRast(plotWindow)',windowSize))],'k','linestyle','none', 'FaceAlpha', 0.25);hold on
plot(x,movmean(meanBadPreRast(plotWindow), windowSize, 'omitnan'),'k');

fill([x;flipud(x)],[movmean(meanBadCueRast(plotWindow)'-stdBadCueRast(plotWindow)',windowSize);flipud(movmean(meanBadCueRast(plotWindow)'+stdBadCueRast(plotWindow)',windowSize))],'b','linestyle','none', 'FaceAlpha', 0.25);
plot(x,movmean(meanBadCueRast(plotWindow), windowSize, 'omitnan'),'r')

hold off;
ylabel('Firing Rate (Spk/s)')
xlabel('Time (s)')
title('Bad Switches')


%% Figure 2f

clear; close all;

pairs = [399 403 901 908 909 910 1661]; %all paired sessions

goodRate = cell(length(pairs),1);
badRate = cell(length(pairs),1);
x = 1;
for zz = pairs
    %---------- load file
        [path, mouse, date, cutoff] = LC_Flexibility_sessionIdx(zz);
        intan_folder = [path mouse '\' date];
        cd(intan_folder);
        ws_info = dir('*spkAndBehaviorVars.mat') ;
        filename = ws_info(1).name;
        load(filename);
        
        behVars = combVars.behVars;
        spkVars = combVars.spkVars;
        
        baseSpkRate = spkVars.baseSpkRate';
        goodSwitches = behVars.goodSwitches;
        if zz == 399 %%session has two good switches, first switch is best
            goodSwitches(2) = 0; %eliminate second good switch for paired comparison
        end
        badSwitches = behVars.badSwitches;
        Cswitch = behVars.Cswitch;
        CswitchHat = Cswitch(2:end);
        cuestop = behVars.cuestop;
        cuestopHat = cuestop(2:end);
        badIdx = CswitchHat(badSwitches);
        badCuestop = cuestopHat(badSwitches);
        goodIdx = CswitchHat(goodSwitches);
        goodCuestop = cuestopHat(goodSwitches);
    
        badTrials = [badIdx-50:badIdx-1 badIdx:badIdx+49];
        goodTrials = [goodIdx-50:goodIdx-1 goodIdx:goodIdx+49];
        
        
        
        goodRate{x,1} = baseSpkRate(goodTrials);
        badRate{x,1} = baseSpkRate(badTrials);

        
        x = x + 1;
end

smWin = 10; %10-trial smoothing window
goodRate = cell2mat(goodRate);
smGoodRate = smoothdata(goodRate, 2, 'movmean', smWin);
badRate = cell2mat(badRate);
smBadRate = smoothdata(badRate, 2, 'movmean', smWin);


meanGood = nanmean(smGoodRate,1);
stdGood = std(smGoodRate,1)/sqrt(size(smGoodRate,1));
stdGood = fillmissing(stdGood,'linear'); 


meanBad = nanmean(smBadRate,1);
stdBad = std(smBadRate,1)/sqrt(size(smBadRate,1));
stdBad = fillmissing(stdBad,'linear'); 

plotWindow = 1:100;
x = linspace(0,100,plotWindow(end));
x = x';

figure;
hold on;


fill([x;flipud(x)],[meanGood(plotWindow)'-stdGood(plotWindow)';flipud(meanGood(plotWindow)'+stdGood(plotWindow)')],'b','linestyle','none', 'FaceAlpha', 0.25);hold on
plot(x,smooth(meanGood(plotWindow)),'b');

fill([x;flipud(x)],[meanBad(plotWindow)'-stdBad(plotWindow)';flipud(meanBad(plotWindow)'+stdBad(plotWindow)')],'r','linestyle','none', 'FaceAlpha', 0.25);hold on
plot(x,smooth(meanBad(plotWindow)),'r');

hold off;
ylabel('Firing Rate (Spk/s)')
xlabel('Time (s)')
title('Bad Switches')

%% Figure 2g-h

clear; close all;

pairs = [399 403 901 908 909 910 1661];

goodBeforeRate = nan(length(pairs),1);
goodAfterRate = nan(length(pairs),1);
badBeforeRate = nan(length(pairs),1);
badAfterRate = nan(length(pairs),1);

x = 1;
for zz = pairs
    %---------- load file
        [path, mouse, date, cutoff] = LC_Flexibility_sessionIdx(zz);
        intan_folder = [path mouse '\' date];
        cd(intan_folder);
        ws_info = dir('*spkAndBehaviorVars.mat') ;
        filename = ws_info(1).name;
        load(filename);
        
        behVars = combVars.behVars;
        spkVars = combVars.spkVars;
        
        baseSpkRate = spkVars.baseSpkRate';
        goodSwitches = behVars.goodSwitches;
        if zz == 399 %%session has two good switches, first switch is best
            goodSwitches(2) = 0; %eliminate second good switch for paired comparison
        end
        badSwitches = behVars.badSwitches;
        Cswitch = behVars.Cswitch;
        CswitchHat = Cswitch(2:end);
        cuestop = behVars.cuestop;
        cuestopHat = cuestop(2:end);
        badIdx = CswitchHat(badSwitches);
        badCuestop = cuestopHat(badSwitches);
        goodIdx = CswitchHat(goodSwitches);
        goodCuestop = cuestopHat(goodSwitches);
    
        badBeforeTrials = badIdx-20:badIdx-1;
        badAfterTrials = badIdx:badIdx+19;
        goodBeforeTrials = goodIdx-20:goodIdx-1;
        goodAfterTrials = goodIdx:goodIdx+19;
        
        goodBeforeRate(x,1) = nanmean(baseSpkRate(goodBeforeTrials));
        goodAfterRate(x,1) = nanmean(baseSpkRate(goodAfterTrials));
        badBeforeRate(x,1) = nanmean(baseSpkRate(badBeforeTrials));
        badAfterRate(x,1) = nanmean(baseSpkRate(badAfterTrials));
        
        x = x + 1;
        
end

goodDelta = goodAfterRate - goodBeforeRate;
badDelta = badAfterRate - badBeforeRate;

[p1, h1, stats1] = signrank(goodBeforeRate, goodAfterRate);
[p2, h2, stats2] = signrank(badBeforeRate, badAfterRate);
[p3, h3, stats3] = signrank(goodDelta, badDelta);

pvals = [p1 p2 p3]';
sig = [h1 h2 h3]';
SR = [stats1.signedrank stats2.signedrank stats3.signedrank]';
labels = {'Flexible (After vs Before)';'Inflexible (After vs Before)';'Flexible vs Inflexible (After - Before)'};

statSum = table(labels, pvals, sig, SR);

plotLineFig([goodBeforeRate goodAfterRate],{'Before',' After'},{'Firing Rate'}, p1, 0, 0, 0);
title('Flexible Switches');

plotLineFig([badBeforeRate badAfterRate],{'Before',' After'},{'Firing Rate'}, p2, 0, 0, 0);
title('Inflexible Switches');

plotLineFig([goodDelta badDelta],{'Flex.',' Inflex.'},{'Delta Firing Rate'}, p3, 0, 0, 0);
title('Flex. vs. Inflex. Switches');