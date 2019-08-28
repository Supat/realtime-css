function [EEGSignals, TriggerSignals, EEGLabels, TriggerLabels] = ExtractTriggerSignal(obj, rawSignals, labels)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

EEGSignals = rawSignals(1:end - 1, :);
TriggerSignals = rawSignals(end, :);
EEGLabels = labels(1:end - 1);
TriggerLabels = labels(end);

end

