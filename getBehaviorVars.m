function   behVars = getBehaviorVars(all_bev)
%extract behavior variables and calculate trial variables, switch points,
%and good/bad switches. Export as behVars data structure
    behVars = struct;
     Lgo = all_bev.Lgo_trials;
     Rgo = all_bev.Rgo_trials;
     Lstim = all_bev.Lstim_trials;
     Rstim = all_bev.Rstim_trials;
     nostim = all_bev.Nostim_trials;
      LickinWin = all_bev.LickinWin_trials;
      lickTimes = all_bev.lick_timestamps;
      numLicks = zeros(1,length(lickTimes));
      for i = 1:length(lickTimes)
             numLicks(i) = size(lickTimes{1,i},2); 
      end 
       premature = all_bev.premature_trials;
       trialNum = all_bev.TrialNum;
       Cswitch = all_bev.contingency_switch_trial;
       if length(trialNum)-Cswitch(end)>50
              Cswitch = [Cswitch length(trialNum)];
       end
       
        cuestop  = all_bev.cueing_blocks(2,:);
               
        if cuestop ~= 0
              blockstop = [all_bev.cueing_blocks(1,:) length(trialNum)];
         else
               blockstop = [1 find(diff(all_bev.Lgo_trials) ~=0)];
         end
          cueidx = all_bev.cueing_idx;
% 
%                 if isfield(all_bev, 'optoTrials')
%                     optoTrials = nan(trialNum(end),1);
%                     optoTrials(1:length(all_bev.optoTrials)) = all_bev.optoTrials;
%                     optoType = all_bev.optoType;
%                     optoON = all_bev.optoStimON;
%                     optoOFF = all_bev.optoStimOFF;                 
%                 end
            
            if max(Cswitch)>max(cuestop)
                cutoff = [1; max(Cswitch)]; 
                Lgo = all_bev.Lgo_trials(cutoff(1):cutoff(2));
                Rgo = all_bev.Rgo_trials(cutoff(1):cutoff(2));
                Lstim = all_bev.Lstim_trials(cutoff(1):cutoff(2));
                Rstim = all_bev.Rstim_trials(cutoff(1):cutoff(2));
                nostim = all_bev.Nostim_trials(cutoff(1):cutoff(2));
                LickinWin = all_bev.LickinWin_trials(cutoff(1):cutoff(2));
                lickTimes = all_bev.lick_timestamps(cutoff(1):cutoff(2));
                LickinWin = all_bev.LickinWin_trials(cutoff(1):cutoff(2));
                numLicks = zeros(1,length(lickTimes));
                for i = 1:length(lickTimes)
                   numLicks(i) = size(lickTimes{1,i},2); 
                end
                premature = all_bev.premature_trials(cutoff(1):cutoff(2));
                trialNum = all_bev.TrialNum(cutoff(1):cutoff(2));
                if cuestop ~= 0
                    blockstop = [all_bev.cueing_blocks(1,:) length(trialNum)];
                else
                    blockstop = [1 find(diff(all_bev.Lgo_trials) ~=0)];
                end
                cueidx = all_bev.cueing_idx(cutoff(1):cutoff(2));
            end
            
            
            behVars.lickTimes = lickTimes;behVars.numLicks = numLicks; 
            behVars.premature = premature; behVars.trialNum = trialNum;behVars.cuestop = cuestop;
            behVars.cueidx = cueidx; behVars.blockstop = blockstop; behVars.Cswitch = Cswitch;
            
            
%-------------------- calculate trial outcomes            
            goL = zeros(1,length(trialNum));
       go_trials = zeros(1,length(trialNum));
       goR = zeros(1,length(trialNum));
       Lcatch = zeros(1,length(trialNum));
       Rcatch = zeros(1,length(trialNum));
       Lcatchfa = zeros(1,length(trialNum));
       Lcatchcr = zeros(1,length(trialNum));
       Rcatchfa = zeros(1,length(trialNum));
       Rcatchcr = zeros(1,length(trialNum));
       nogoL = zeros(1,length(trialNum));
       nogoR = zeros(1,length(trialNum));
       Lhit = zeros(1,length(trialNum));
       Lmiss = zeros(1,length(trialNum));
       Lfa = zeros(1,length(trialNum));
       Lcr = zeros(1,length(trialNum));
       Rhit = zeros(1,length(trialNum));
       Rmiss = zeros(1,length(trialNum));
       Rfa = zeros(1,length(trialNum));
       Rcr = zeros(1,length(trialNum));
  
       go_trials((Lgo == 1 & Lstim == 1 | Rgo == 1 & Rstim == 1)) = 1; behVars.go_trials = go_trials;
       nogo_trials = zeros(1,length(go_trials)); 
       nogo_trials ((Lgo == 1 & Rstim == 1 | Rgo == 1 & Lstim == 1)) = 1; behVars.nogo_trials = nogo_trials;
       goL((Lgo == 1 & Lstim == 1)) = 1; 
       goR((Rgo == 1 & Rstim == 1)) = 1; 
       Lcatch((Lgo == 1 & nostim == 1)) = 1; 
       Rcatch((Rgo == 1 & nostim == 1)) = 1; 
       Lcatchfa((Lcatch == 1 & LickinWin == 1)) = 1; behVars.Lcatchfa = Lcatchfa;
       Lcatchcr((Lcatch == 1 & LickinWin == 0)) = 1; behVars.Lcatchcr = Lcatchcr;
       Rcatchfa((Rcatch == 1 & LickinWin == 1)) = 1; behVars.Rcatchfa = Rcatchfa;
       Rcatchcr((Rcatch == 1 & LickinWin == 0)) = 1; behVars.Rcatchcr = Rcatchcr;
       nogoL((Lgo == 1 & Rstim == 1)) = 1; 
       nogoR((Rgo == 1 & Lstim == 1)) = 1; 
       
       Lhit((goL == 1 & LickinWin == 1)) = 1; 
       Lmiss((goL == 1 & LickinWin == 0)) = 1;
       Lfa((nogoL == 1 & LickinWin == 1)) = 1;
       Lcr((nogoL == 1 & LickinWin == 0)) = 1;
       Rhit((goR == 1 & LickinWin == 1)) = 1; 
       Rmiss((goR == 1 & LickinWin == 0)) = 1; 
       Rfa((nogoR == 1 & LickinWin == 1)) = 1; 
       Rcr((nogoR == 1 & LickinWin == 0)) = 1; 
       go_hit = Lhit + Rhit; behVars.go_hit = go_hit;
        go_miss = Lmiss + Rmiss;behVars.go_miss = go_miss;
        nogo_cr = Lcr + Rcr;behVars.nogo_cr = nogo_cr;
        nogo_fa = Lfa + Rfa; behVars.nogo_fa = nogo_fa;
        catch_cr = Lcatchcr + Rcatchcr; behVars.catch_cr = catch_cr;
        catch_fa = Lcatchfa + Rcatchfa; behVars.catch_fa = catch_fa;
        
%------------------ get block performances        
        blockPerf = zeros(1,length(cuestop)); %block performance
        blockHR = zeros(1,length(cuestop)); %block hit rate
        blockCR = zeros(1,length(cuestop)); %block correct rejections
        blockCCR = zeros(1,length(cuestop)); %block catch correct rejections
        blockPre = zeros(1,length(cuestop)); %block premature
        blockLength = zeros(1,length(cuestop)); %block size

    for b = 1:length(cuestop)
            blockLen = Cswitch(b+1) - Cswitch(b); %length of each block
            blockTrials = trialNum (Cswitch(b):Cswitch(b+1) - 1); %trialNums for each block
            prematureTrials = sum(premature(blockTrials));
            catchTrials = (sum(Lcatch(blockTrials)) + sum(Rcatch(blockTrials)));
            blockPerf(b) = (sum(go_hit(blockTrials)) + sum(nogo_cr(blockTrials)))/(blockLen - prematureTrials - catchTrials);
            blockHR(b) = sum(go_hit(blockTrials))/sum(go_trials(blockTrials));
            blockCR(b) = sum(nogo_cr(blockTrials))/sum(nogo_trials(blockTrials));
            blockCCR(b) = sum(catch_cr(blockTrials))/ catchTrials;
            blockPre(b) = prematureTrials/ blockLen;
            blockLength(b) = blockLen;
    end


%----------------- get switch point    
    
    pThresh = 0.85;
windowSize = 50;

blockEnd = [Cswitch(2:end)-1 length(trialNum)];
correctTrials = Lhit+Lcr+Rhit+Rcr;
alltrialTypes = goL + nogoL + goR + nogoR;
movCrit = nan(1,size(cuestop,2)-1);

for p = 1:size(cuestop,2)
    start = cuestop(p);
    stop = blockEnd(p);
    blockLen = blockEnd(p)- cuestop(p);
movPerf = movmean(correctTrials(start:stop), [0 windowSize])./movmean(alltrialTypes(start:stop), [0 windowSize]);
tempCrit = find(movPerf>=pThresh,1, 'first');
% if isempty(tempCrit) || ((blockLen - tempCrit) < 5)
if isempty(tempCrit)
%     movCrit(sect,p-1) = nan;
    movCrit(p) = blockLen;
else
    movCrit(p) = tempCrit;

end
end

    if blockLength(end)<50
        blockPerf(end) = [];
        blockHR(end) = [];
        blockCR(end) = [];
        blockCCR(end) = [];
        blockPre(end) = [];
        blockLength(end) = [];
        movCrit(end) = [];
    end

    
    behVars.blockPerf = blockPerf; behVars.blockHR = blockHR; 
    behVars.blockCR = blockCR; behVars.blockCCR = blockCCR; behVars.blockPre = blockPre;
    behVars.blockLength =blockLength;behVars.movCrit = movCrit;
    
    
    
    %---------calculate pre rule switch window performance

    
    prePerf = nan(1,length(cuestop));
    windowSize = 50;
    
    for b = 2:length(cuestop)
            preTrials = trialNum (Cswitch(b)-windowSize:Cswitch(b) - 1); %pretrial nums for each block
            prePerf(b) = nanmean(correctTrials(preTrials))/nanmean(alltrialTypes(preTrials));        
    end

 
    
%-------------- find good and bad switches    

critThresh = 50;
prePerfThresh = 0.65;
tempBP = prePerf(2:end);
goodIdx = tempBP > prePerfThresh;


goodSwitches = goodIdx & (movCrit(2:end)<=critThresh);
badSwitches = goodIdx & (movCrit(2:end)>critThresh);   

behVars.goodSwitches = goodSwitches;
behVars.badSwitches = badSwitches;
    
    
end
           

