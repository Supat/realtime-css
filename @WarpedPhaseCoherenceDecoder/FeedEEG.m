function obj = FeedEEG(obj, EEGData)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

try
    %% Calculation here
    EEGData = hilbert(EEGData - mean(EEGData));
    r = calc_plv_hat(EEGData);
    %% Object-Oriented Thingy
    PhaseLockinValueHatData = PhaseLockingValueHat(r);
    notify(obj, 'PhaseLockingValueAvailable', PhaseLockinValueHatData);
catch
    disp('Error occurs while trying to execute calc_plv_hat')
    notify(obj, 'PhaseLockingValueUnavailable');
end
end

