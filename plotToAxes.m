function plotToAxes(axes, data, labels, freq, len, scale, displayLen, ymode)
%plotToAxes This function plot any input signal onto specified axes.
%
%   This function plot any multi-channal signal onto specified axes. All
%   input parameters is mendatory.
%
%   Input parameters:
%   axes - axes object
%   data - data for ploting
%   labels - each data channel's label
%   freq - frequency of the data
%   len - length of the data
%   scale - ploting graph magnifying index
%   displayLen - length of the graph to be display (in the same unit as len)

paddingFactor = mean(range(data, 2));
plottingData = data';
[~, numOfChannel] = size(plottingData);
if ymode == 1
    yTickPosition = zeros(numOfChannel, 1);
    for i=1:numOfChannel
        plottingData(:, i) = plottingData(:, i) - mean(plottingData(:,i));
        plottingData(:, i) = plottingData(:, i) - (i * paddingFactor / scale);
        yTickPosition(i) = mean(plottingData(:, i));
    end
    topMargin = range(data(yTickPosition==max(yTickPosition), :)) / 2;
    bottomMargin = range(data(yTickPosition==min(yTickPosition), :)) / 2;
    [yTickPosition, yTickSortIndex] = sort(yTickPosition);
elseif ymode == 2
    yTickPosition = zeros(numOfChannel, 1);
    for i=1:numOfChannel
        plottingData(:, i) = plottingData(:, i) + pow2(10, i - 1);
        %plottingData(:, i) = plottingData(:, i) * pow2(100, scale - 1);
        yTickPosition(i) = median(plottingData(:, i));
    end
    [yTickPosition, yTickSortIndex] = sort(yTickPosition);
%     topMargin = yTickPosition(1) - mean(data(1, :));
%     bottomMargin = yTickPosition(end) + mean(data(end, :));
    zoomFactor = 20;
    %topMargin = yTickPosition(1) + pow2(10, zoomFactor);
    %bottomMargin = yTickPosition(1) - pow2(10, zoomFactor);
    topMargin = mean(yTickPosition) + pow2(10, zoomFactor - scale);
    bottomMargin = mean(yTickPosition) - pow2(10, zoomFactor - scale);
else
    yTickPosition = zeros(numOfChannel, 1);
    for i=1:numOfChannel
        plottingData(:, i) = plottingData(:, i) - mean(plottingData(:,i));
        plottingData(:, i) = plottingData(:, i) - (i * paddingFactor / scale);
        yTickPosition(i) = mean(plottingData(:, i));
    end
    topMargin = range(data(yTickPosition==max(yTickPosition), :)) / 2;
    bottomMargin = range(data(yTickPosition==min(yTickPosition), :)) / 2;
    [yTickPosition, yTickSortIndex] = sort(yTickPosition);
end

plotingLabels = labels(yTickSortIndex);

plot(axes, plottingData);

if length(data) < freq
    axes.XLimMode = 'manual';
    axes.XLim = [1 + ((len - displayLen) * freq), (freq * len)];
    axes.XTick = (0:0.05:len) * freq;
    axes.XTickLabel = fliplr(0:0.05:len);
else
    axes.XLimMode = 'manual';
    axes.XLim = [1 + ((len - displayLen) * freq), (freq * len)];
    axes.XTick = (0:0.5:len) * freq;
    axes.XTickLabel = fliplr(0:0.5:len);
end

axes.YLimMode = 'manual';
if ymode == 1
    axes.YLim = [min(yTickPosition) - bottomMargin - 1, max(yTickPosition) + topMargin + 1];
elseif ymode == 2
    if topMargin > bottomMargin
        axes.YLim = [bottomMargin, topMargin];
    end
else
    axes.YLim = [min(yTickPosition) - bottomMargin - 1, max(yTickPosition) + topMargin + 1];
end
axes.YTick = transpose(yTickPosition);
axes.YTickLabel = transpose(plotingLabels);
end

