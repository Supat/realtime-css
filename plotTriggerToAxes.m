function plotTriggerToAxes(axes, xCoordinates, xLabels)
%plotTriggerToAxes This function superimposes trigger marker onto EEG plot
%   Detailed explanation goes here

[newXticks, xTickSortIndex] = sort([axes.XTick, xCoordinates]);
xlabels = char(axes.XTickLabel, num2str(xLabels'));
newXticklabels = xlabels(xTickSortIndex,:,:);
axes.XTick = newXticks;
axes.XTickLabel = newXticklabels;
for i=1:length(xCoordinates)
    line(axes, [xCoordinates(i) xCoordinates(i)], axes.YLim, 'LineStyle' ,'--', 'Color', 'Red');
end
end

