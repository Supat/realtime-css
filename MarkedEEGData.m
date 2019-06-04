classdef (ConstructOnLoad) MarkedEEGData < event.EventData
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        RawData
        Header
    end
    
    methods
        % Constructor
        function obj = MarkedEEGData(EEGData, triggerData, freq, nChans, EEGLabel, TrigLabel)
            if nargin >= 2
                obj.Header.Fs = freq;
                obj.Header.nChans = nChans;
                obj.Header.EEGLabel = EEGLabel;
                obj.Header.TriggerLabel = TrigLabel;
                obj.RawData.EEG = EEGData;
                obj.RawData.Trigger = triggerData;
            end
        end
    end
    
end

