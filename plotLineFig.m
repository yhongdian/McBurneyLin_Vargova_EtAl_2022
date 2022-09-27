function plotLineFig(yVals, xLabels, yLabel, pval, save, path, figname)
    figure; 
    numVars = length(xLabels);
    
    if numVars == 2
        y1 = yVals(:,1);
        y2 = yVals(:,2);
        x1Label = xLabels{1};
        x2Label = xLabels{2};
        
        for i = 1:length(y1)
           plot([1 2], [y1(i) y2(i)], 'k'); hold on;           
        end
        scatter([1 2], [nanmean(y1) nanmean(y2)], 'b', 'filled'); hold off;
        xlim([0 3]); xticks([1 2]); xticklabels({x1Label, x2Label});
        ylabel(yLabel);
        if ~isempty(pval)
            sigstar([1,2], pval);
        end
    elseif numVars == 3
        y1 = yVals(:,1);
        y2 = yVals(:,2);
        y3 = yVals(:,3);
        x1Label = xLabels{1};
        x2Label = xLabels{2};
        x3Label = xLabels{3};
        
        for i = 1:length(y1)
           plot([1 2 3], [y1(i) y2(i) y3(i)], 'k'); hold on;           
        end
        scatter([1 2 3], [nanmean(y1) nanmean(y2) nanmean(y3)], 'b', 'filled'); hold off;
        xlim([0 4]); xticks([1 2 3]); xticklabels({x1Label, x2Label, x3Label});
        ylabel(yLabel);
        if ~isempty(pval)
            sigstar([1,2], pval(1));
            sigstar([2,3], pval(2));
        end
    else
        disp('!! Too Many Variables !!');
    end
    
    prompt = 'Upper y Lim? ';
        y2 = input(prompt)
        prompt = 'Lower y Lim? ';
        y1 = input(prompt)
        ylim([y1 y2]);
        
    if save
        savename = [path '\fig\' figname '.fig'];
        if ~exist([path '\fig'])
            mkdir([path '\fig'])
        end
        saveas(gcf,savename);
        savename = [path '\svg\' figname '.svg'];
        if ~exist([path '\svg'])
            mkdir([path '\svg'])
        end
        saveas(gcf,savename);
        
    end
end