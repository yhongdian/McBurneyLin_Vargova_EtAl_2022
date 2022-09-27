% LC flexibility - Figure 3

clear all; close all

%% Figure 3 c-i

testM1 = 1009:1018; testM2 = 1052:1061; testM3 = 1152:1161; testM4 = 1873:1882;
testPairs = {testM1; testM2; testM3; testM4};

% conM1 = 1260:1269; conM2 = 1303:1312; conM3 =1687:1696; 
% conPairs = {conM1; conM2; conM3};

pairs = testPairs; %% switch to testPairs/conPairs for left or right panels for figure 3d-i
test = 0; %% 1 for testPairs, 0 for conPairs

% ----
switchP = nan(length(pairs),10);
switchHR = nan(length(pairs),10);
switchCR = nan(length(pairs),10);
dPrime = nan(length(pairs),10);
switchCrit = nan(length(pairs),10);
frac  = nan(length(pairs),10);
x = 1;

for pp = 1:length(pairs)
    y = 1;
    for zz = pairs{pp}
    %---------- load file
        [path, mouse, date, cutoff] = LC_Flexibility_sessionIdx(zz);
        intan_folder = [path mouse '\' date];
        cd(intan_folder);
        ws_info = dir('*spkAndBehaviorVars.mat') ;
        filename = ws_info(1).name;
        load(filename);
        
        behVars = combVars.behVars;
        blockPerf = behVars.blockPerf;
        switchP(x,y) = blockPerf(2); %get second block performance
        
        movCrit = behVars.movCrit;
        switchCrit(x,y) = movCrit(2);
        
        blockHR = behVars.blockHR;
        switchHR(x,y) = blockHR(2);
        
        blockCR = behVars.blockCR;
        switchCR(x,y) = blockCR(2);


        
        y = y + 1;
    end
    x = x + 1;
end


% ---------fig 3c 
meanPerf = mean(switchP,1);
stdPerf = nanstd(switchP,1)/sqrt(size(switchP,1));

figure; hold on;
scatter([-5:-1 1:5], meanPerf, 'filled', 'k');
x = [-5:-1 1:5];
for i = 1:10
pos = x(i);
errorbar(pos, meanPerf(i), stdPerf(i), 'k');
end
ylim([0.3 0.9]); hold off;


%----------fig 3f
prePerf = switchP(:,1:5); prePerfHat = reshape(prePerf,[size(prePerf,1)*size(prePerf,2) 1]);
postPerf = switchP(:,6:10);postPerfHat = reshape(postPerf,[size(postPerf,1)*size(postPerf,2) 1]);
[p1, h1, stats1] = ranksum(prePerfHat, postPerfHat);
plotScatFig([prePerfHat postPerfHat],{'Base.','Stim.'},{'Switch performance'},p1, 0, 0, 0, 0);

%----------- fig 3g
preCrit= switchCrit(:,1:5); preCrit = reshape(preCrit,[size(preCrit,1)*size(preCrit,2) 1]);
postCrit = switchCrit(:,6:10);postCrit = reshape(postCrit,[size(postCrit,1)*size(postCrit,2) 1]);
[p2, h2, stats2] = ranksum(preCrit, postCrit);
plotScatFig([preCrit postCrit],{'Base.','Stim.'},{'Switch point'},p2, 0, 0, 0, 0);

%-----------fig 3h
preHR = switchHR(:,1:5); preHR = reshape(preHR,[size(preHR,1)*size(preHR,2) 1]);
postHR = switchHR(:,6:10);postHR = reshape(postHR,[size(postHR,1)*size(postHR,2) 1]);
[p3, h3, stats3] = ranksum(preHR, postHR);
plotScatFig([preHR postHR],{'Base.','Stim.'},{'Switch HR'},p3, 0, 0, 0, 0);

%----------fig 3i
preCR = switchCR(:,1:5); preCR = reshape(preCR,[size(preCR,1)*size(preCR,2) 1]);
postCR = switchCR(:,6:10);postCR = reshape(postCR,[size(postCR,1)*size(postCR,2) 1]);
[p4, h4, stats4] = ranksum(preCR, postCR);
plotScatFig([preCR postCR],{'Base.','Stim.'},{'Switch CR'},p4, 0, 0, 0, 0);



%----------fig 3d
if test == 1
meanPre = mean(prePerf,2);
meanPost = mean(postPerf,2);
x = 0; 
figure; hold on;
for i = 1:size(prePerf,1)
    [p,h,stats] = ranksum(prePerf(i,:), postPerf(i,:));
    bar(x+1, meanPre(i), 'k');
    scatter(ones(5,1)*(x+1),prePerf(i,:),'b', 'filled');
    bar(x+2, meanPost(i), 'c');
    scatter(ones(5,1)*(x+2),postPerf(i,:),'b', 'filled');
    sigstar([x+1,x+2], p);
    x = x+2;
end
xlim([0 x+1]); ylim([0 1]); 
xticks([1.5 3.5 5.5 7.5]);
xticklabels({'#1','#2','#3', '#4'})
ylabel('Switch performance');
hold off;
else
%----------fig 3e
meanPre = mean(prePerf,2);
meanPost = mean(postPerf,2);
x = 0; 
figure; hold on;
for i = 1:size(prePerf,1)
    [p,h,stats] = ranksum(prePerf(i,:), postPerf(i,:));
    bar(x+1, meanPre(i), 'k');
    scatter(ones(5,1)*(x+1),prePerf(i,:),'b', 'filled');
    bar(x+2, meanPost(i), 'c');
    scatter(ones(5,1)*(x+2),postPerf(i,:),'b', 'filled');
    sigstar([x+1,x+2], p);
    x = x+2;
end
xlim([0 x+1]); ylim([0 1]); 
xticks([1.5 3.5 5.5]);
xticklabels({'#5','#6','#7'})
ylabel('Switch performance');
hold off;

end
