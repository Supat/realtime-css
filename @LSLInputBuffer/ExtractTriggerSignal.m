function [EEGSignals, TriggerSignals, EEGLabels, TriggerLabels] = ExtractTriggerSignal(obj, rawSignals, labels)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

idx = find(strcmp('Trig1', labels));

EEGSignals = rawSignals;
EEGSignals(idx, :) = [];

TriggerSignals = rawSignals(idx, :);

EEGLabels = labels;
EEGLabels(idx, :) = [];

TriggerLabels = labels(idx);

end
