function obj = FeedEEG(obj, EEGData)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

data = EEGData';

try
    %% Preprocess EEG here
    fprintf('Data size : %d\n', length(data))
    tic
    ChannelsAverage = zeros(size(data, 2), 1);
    for i = 1:size(data, 2)
        s = data(:, i);
        s = hilbert(s - mean(s));
        ChannelsAverage(i) = mean(abs(s));
        data(:, i) = s;
    end
    data = data / mean(ChannelsAverage);
    
    %% Calculate PhaseLockingValue
    fprintf('Alpha: %f, AverageFlag: %d, AmplitudeFlag: %d, Rescaling: %d\n', ...
        obj.Alpha, ...
        obj.AverageRelativePhaseRemovalFlag, ...
        obj.AmplitudeFluctuationsRemovalFlag, ...
        obj.Rescaling);
    synchronizationMatrix = obj.calc_plv_hat(data, obj.Alpha, ...
                                obj.AverageRelativePhaseRemovalFlag, ...
                                obj.AmplitudeFluctuationsRemovalFlag, ...
                                obj.Rescaling);
    
    %% Package and broadcast results to responder function 
    toc
    synchronizationMatrixData = WPCSynchronizationMatrix(synchronizationMatrix);
    notify(obj, 'PhaseLockingValueAvailable', synchronizationMatrixData);
catch
    disp('Error occurs while trying to execute calc_plv_hat')
    notify(obj, 'PhaseLockingValueUnavailable');
end

end
