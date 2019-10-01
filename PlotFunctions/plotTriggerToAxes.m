function plotTriggerToAxes(axes, xCoordinates, xLabels)
%plotTriggerToAxes This function superimposes trigger marker onto EEG plot
%   Detailed explanation goes here

[newXticks, xTickSortIndex] = sort([axes.XTick, xCoordinates]);
xlabels = char(axes.XTickLabel, num2str(xLabels'));
newXticklabels = xlabels(xTickSortIndex,:,:);
[~, idx] = unique(newXticks);
duplicate_idx = setdiff(1:length(newXticks), idx);
newXticks(duplicate_idx) = newXticks(duplicate_idx) + 1;
axes.XTick = newXticks;
axes.XTickLabel = newXticklabels;
for i=1:length(xCoordinates)
    line(axes, [xCoordinates(i) xCoordinates(i)], axes.YLim, 'LineStyle' ,'--', 'Color', 'Red');
end
end

