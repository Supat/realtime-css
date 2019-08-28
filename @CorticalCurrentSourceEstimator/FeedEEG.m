function obj = FeedEEG(obj, EEGData)
%FeedEEG This function feed EEG signal to the CCS estimator
%   
%   This function estimates current source from the EEG data 'EEGData'
%   using 'vb_current_calc'. If it is successful, it notifies
%   'CurrentSourceAvailable' event with a 'CurrentSource' object, otherwise
%   it notify 'CurrentSourceUnavailable' event.

try
    currentSource = vb_current_calc(EEGData, ...
        obj.CurrentProfile.Filter, ...
        obj.CurrentProfile.PosteriorSensorCovarianceMatrix, ...
        obj.CurrentProfile.ModelEntropy, ...
        obj.CurrentProfile.ObservationNoiseVariance);
    CurrentSourceData = CurrentSource(currentSource);
    notify(obj, 'CurrentSourceAvailable', CurrentSourceData);
catch
    disp('Error occurs while trying to execute VBMEG command')
    notify(obj, 'CurrentSourceUnavailable');
end
end
