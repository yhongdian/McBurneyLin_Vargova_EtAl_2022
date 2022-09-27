% LC flexibility - Figure 1

clear all; close all

%% Figure 1d
pairs1 = 2:27; allPairs{1} = pairs1; 
pairs2 = 30:56; allPairs{2} = pairs2;
pairs3 = 63:88; allPairs{3} = pairs3;  
pairs4 = 106:128; allPairs{4} = pairs4; 
pairs5 = 373:405; allPairs{5} = pairs5;  
pairs6 = 536:554; allPairs{6} = pairs6;
pairs7 = 693:713 ; allPairs{7} = pairs7; 
pairs8 = 894:916; allPairs{8} = pairs8;
pairs9 = 1301:1323; allPairs{9} = pairs9;
pairs10 = 1526:1555; allPairs{10} = pairs10;
pairs11 = 1633:1660; allPairs{11} = pairs11; 

figure; 
perfMat = nan(11,40);
perfMat_smooth = nan(11,40);
x = 1;
for pp = 1:length(allPairs)
    pairs = allPairs{pp};
    y = 1;
for zz = pairs
    %---------- load file
        [path, mouse, date, ~] = LC_Flexibility_sessionIdx(zz);
        intan_folder = [path mouse '\' date];
        cd(intan_folder);
        ws_info = dir('*spkAndBehaviorVars.mat') ;
        filename = ws_info(1).name;
        load(filename);
        behVars = combVars.behVars;
        blockPerf = behVars.blockPerf;
        if length(blockPerf)>1
        perfMat(x,y) = blockPerf(2);  % fraction correct
%         perfMat(x,y) = behVars.blockCCR(2); % catch trials
%         perfMat(x,y) = behVars.blockHR(2);  % hit
%         perfMat(x,y) = behVars.blockCR(2);  % cr

        end 
        y = y + 1;
end
tempPerf = perfMat(x,:);
endIdx = find(isnan(tempPerf),1, 'first');
plot(smooth(tempPerf(1:endIdx))); hold on;

A =  smooth(tempPerf(1:endIdx))';
B = nan(40 - length(smooth(tempPerf(1:endIdx))),1)';
C = [A,B];

perfMat_smooth(pp,:) = C;


x = x + 1;

xlim([0 32]);
ylim([0 1]);

end


%% Figure 1e

clear; close all;

pairs = [403 406 908 911]; 

 for ii = pairs
     %---------- load file
        [path, mouse, date, ~] = LC_Flexibility_sessionIdx(ii);
        intan_folder = [path mouse '\' date];
        cd(intan_folder);
        ws_info = dir('*spkAndBehaviorVars.mat') ;
        filename = ws_info(1).name;
        load(filename);
        
        behVars = combVars.behVars;
        go_hit = behVars.go_hit;
        nogo_cr = behVars.nogo_cr;
        go_trials = behVars.go_trials;
        nogo_trials = behVars.nogo_trials;
        Cswitch = behVars.Cswitch;
        cuestop = behVars.cuestop;


        correctTrials = go_hit+nogo_cr;
        hits = go_hit;
        cRejs = nogo_cr;
        alltrialTypes = go_trials + nogo_trials;
        hitTrialTypes = go_trials;
        CRTrialTypes = nogo_trials;
        
        g = 50; % running average window size
        
        
        run_per_corr = movmean(correctTrials, [0 g]); run_trials = movmean(alltrialTypes, [0 g]);
        run_per_corr = run_per_corr./run_trials;
            
        run_hit_rate = movmean(hits, [0 g]); run_trials = movmean(hitTrialTypes, [0 g]);
        run_hit_rate = run_hit_rate./run_trials;
        run_cr_rate = movmean(cRejs, [0 g]);run_trials = movmean(CRTrialTypes, [0 g]);
        run_cr_rate = run_cr_rate./run_trials;
        
         figure;plot(smooth(run_per_corr), 'b'); hold on; 
        plot(smooth(run_hit_rate), 'g');plot(smooth(run_cr_rate), 'r');
        ylim([0 1]);
        h=vline(Cswitch(2),'r');h=vline(Cswitch(3),'r');
        h=vline(cuestop(2),'r');h=vline(cuestop(3),'r');
        xlabel('Trials'); ylabel('Fraction Correct');
 end





%% Figure 1f-h

clear; close all;

pairs = [27 28 45 46 51 64 65 70 74 75 86:90 129  398:404 407 552:556 706:710 712 901:916 1001:1003 1319 1661:1663];

 
 %------- load required data from all mice in pairs
 allCrit = nan(length(pairs), 4);
 allPerf = nan(length(pairs), 4);
 allGoodSwitches = nan(length(pairs), 4);
 allBadSwitches = nan(length(pairs), 4);

 xx = 1; %row number
 
 for ii = pairs
     %---------- load file
        [path, mouse, date, ~] = LC_Flexibility_sessionIdx(ii);
        intan_folder = [path mouse '\' date];
        cd(intan_folder);
        ws_info = dir('*spkAndBehaviorVars.mat') ;
        filename = ws_info(1).name;
        load(filename);
        
        behVars = combVars.behVars;
        
      %------------ get switch point and block performance
      tempCrit = behVars.movCrit;
      tempPerf = behVars.blockPerf;
      allCrit(xx, 1:length(tempCrit)) = tempCrit;
      allPerf(xx,1:length(tempPerf)) = tempPerf;
        
        
        %--------------- get switch types
        goodSwitches = behVars.goodSwitches;
        badSwitches = behVars.badSwitches;
        allGoodSwitches(xx, 2:length(goodSwitches)+1) = goodSwitches;
        allBadSwitches(xx, 2:length(badSwitches)+1) = badSwitches;
        allGoodSwitches = allGoodSwitches(:,1:4);
        allBadSwitches = allBadSwitches(:,1:4);

        
        
        xx = xx + 1;
 end
 
 %------------------ separate good and bad switch vars
 
 goodCrit = allCrit(allGoodSwitches==1);
 goodPerf = allPerf(allGoodSwitches==1);
 
 badCrit = allCrit(allBadSwitches==1);
 badPerf = allPerf(allBadSwitches==1);
 
 allCritHat = [goodCrit; badCrit];
 allPerfHat = [goodPerf; badPerf];
 
 %------ fig 1f
 
 x = allCritHat; y = allPerfHat;
[fitobj,~]= fit(x, y, 'poly1');
[a, b] = corrcoef(x, y);
figure(1); 
plot(fitobj, x, y);
xlabel('Switch Point (trials)');
ylabel('Switch performance');
 
 
 
 %--------- fig 1g
 figure(2); 
 histogram(allCritHat, 30);
 xlabel('Switch Point (trials)');
ylabel('# of blocks');

 
 %------- fig 1h

 [p,h,stats] = ranksum(goodPerf, badPerf);
 if length(goodPerf)>length(badPerf)
    diffSize = length(goodPerf) - length(badPerf);
     badPerf = [badPerf; nan(diffSize,1)];
 else
     diffSize = length(badPerf) - length(goodPerf);
      goodPerf = [goodPerf; nan(diffSize,1)];
 end
 
plotScatFig([goodPerf badPerf],{'Flex.','Inflex.'},{'Switch performance'},p, 0, 0, 0, 0);