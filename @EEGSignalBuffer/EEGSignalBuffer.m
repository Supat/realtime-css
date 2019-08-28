classdef EEGSignalBuffer
    %EEGSignalBuffer This class is a container for EEG signal
    %   
    %   This class is a buffer for storing incoming EEG signal with length
    %   of 'BufferLength'. The raw EEG data is store in 'Data' property.
    %
    %   This buffer also provides functionality for applying band pass
    %   filter and referencing when reading the data from this buffer.
    
    properties (SetAccess = private)
        Data
        TriggerSignals
        BufferLength
        
        PotentialCache
        PotentialCacheLength
    end
    
    properties
        DataLabels
        TriggerLabels
        Frequency
        ReferenceChannels
        LowPassband
        HighPassband
        
        TriggerPositions
        TriggerValues
        TriggerCount
    end
    
    methods
        % Constructor
        function buffer = EEGSignalBuffer(bufferLength)
            buffer.BufferLength = bufferLength;
            buffer.Frequency = 1;
            buffer.ReferenceChannels = [];
            buffer.LowPassband = 0.5;
            buffer.HighPassband = 40;
            buffer.DataLabels = {''};
            buffer.TriggerLabels = {''};
            
            buffer.TriggerPositions = [];
            buffer.TriggerValues = [];
            buffer.PotentialCacheLength = 3;
            buffer.TriggerCount = 0;
        end
        
        function obj = set.Frequency(obj, frequency)
            if (frequency > 0)
                obj.Frequency = frequency;
            else
                error('Frequency must be positive')
            end
        end
        
        function obj = set.HighPassband(obj, band)
            disp('Set new high pass band');
            obj.HighPassband = band;
        end
        
        function obj = set.LowPassband(obj, band)
            disp('Set new low pass band');
            obj.LowPassband = band;
        end
        
        function data = DataForFilterInput(obj, numberOfChannel)
            try
                if isempty(obj.ReferenceChannels)
                    data = eegfiltfft(obj.Data(1:numberOfChannel,:), obj.Frequency, obj.LowPassband, obj.HighPassband);
                else
                    ref_channel = eegfiltfft(obj.Data(obj.ReferenceChannels,:), obj.Frequency, obj.LowPassband, obj.HighPassband);
                    data = eegfiltfft(obj.Data(1:numberOfChannel,:) - mean2(ref_channel), obj.Frequency, obj.LowPassband, obj.HighPassband);
                end
            catch
                data = [];
            end
        end
        
        function data = FilteredData(obj, index)
            if nargin ==0
                try
                    data = eegfiltfft(obj.Data, obj.Frequency, obj.LowPassband, obj.HighPassband);
                catch
                    disp('Cannot get filtered eeg data');
                    data = [];
                end
            else
                try
                    data = eegfiltfft(obj.Data(index, :), obj.Frequency, obj.LowPassband, obj.HighPassband);
                catch
                    disp('Cannot get filtered eeg data');
                    data = [];
                end
            end
        end
        
        function obj = AppendDataWithFrequency(obj, newData, frequency)
            obj.Frequency = frequency;
            if (obj.Frequency <= 0)
                error('Frequency must be positive, set proper buffer frequency before first AppendData call')
            end
            
            % assign or append new data to Data property
            if size(obj.Data, 2) == 0
                obj.Data = newData;
            else
                obj.Data = [obj.Data, newData];
            end
            
            % trim the Data property size to defined length
            if size(obj.Data, 2) > obj.BufferLength * obj.Frequency
                obj.Data = obj.Data(:, size(obj.Data, 2) + 1 - (obj.BufferLength * obj.Frequency):end);
            end
        end
        
        function obj = AppendTriggerSignals(obj, newTriggerSignals)
            % assign or append new trigger signals to TriggerSignals property
            if size(obj.TriggerSignals, 2) == 0
                obj.TriggerSignals = newTriggerSignals;
            else
                obj.TriggerSignals = [obj.TriggerSignals, newTriggerSignals];
            end
            
            % trim the Data property size to defined length
            if size(obj.TriggerSignals, 2) > obj.BufferLength * obj.Frequency
                obj.TriggerSignals = obj.TriggerSignals(:, size(obj.TriggerSignals, 2) + 1 - (obj.BufferLength * obj.Frequency):end);
            end
        end
        
        function obj = UpdateCurrentTriggerState(obj, xCor, values)
            obj.TriggerPositions = xCor;
            obj.TriggerValues = values;
        end
        
        function obj = PushEEGChannelsToPotentialCacheForTrigger(obj, triggerValue)
            disp(obj.TriggerCount);
            
            detectionPeriod = [length(obj.Data) - (obj.Frequency * obj.PotentialCacheLength), length(obj.Data) - (obj.Frequency * (obj.PotentialCacheLength - 1))];
            
            EEGData = obj.Data;
            
            if ~isempty(obj.TriggerPositions) && ~isempty(obj.TriggerValues)
                for i=1:length(obj.TriggerPositions)
                
                    if obj.TriggerPositions(i) >= detectionPeriod(1) && obj.TriggerPositions(i) < detectionPeriod(2)
                    
                        if obj.TriggerValues(i) == triggerValue
                        
                            obj.TriggerCount = obj.TriggerCount + 1;
                            
                            EEGSegment = EEGData(:, obj.TriggerPositions(i) - (1 * obj.Frequency):obj.TriggerPositions(i) + ((obj.PotentialCacheLength - 1) * obj.Frequency) - 1);
                            
                            if obj.TriggerCount == 1
                                obj.PotentialCache = EEGSegment;
                            else
                            	% Calculate running average
                                obj.PotentialCache = obj.PotentialCache * (obj.TriggerCount / (obj.TriggerCount + 1)) + EEGSegment  / (obj.TriggerCount + 1);
                            end
                        end
                        
                    end
                    
                end
            end
        end
        
        function EEGSegment = AverageEEGPotentialSegment(obj, index)
            EEGSegment = obj.PotentialCache(index, :);
        end
        
        function referencedEEGSegment = ReferencedAverageEEGPotentialSegment(obj)
            try
                if isempty(obj.ReferenceChannels)
                    referencedEEGSegment = obj.PotentialCache(index, :);
                else
                    ref = obj.Data(obj.ReferenceChannels,:);
                    referencedEEGSegment = obj.PotentialCache(index, :) - mean2(ref);
                end
            catch
                referencedEEGSegment = [];
            end
        end
        
        function filteredEEGSegment = FilteredAverageEEGPotentialSegment(obj)
            try
                filteredEEGSegment = eegfiltfft(obj.PotentialCache(index, :), obj.Frequency, obj.LowPassband, obj.HighPassband);
            catch
                filteredEEGSegment = [];
            end
        end
        
        function FilteredReferencedEEGSegment = FilteredReferencedAverageEEGPotentialSegment(obj)
            try
                if isempty(obj.ReferenceChannels)
                    FilteredReferencedEEGSegment = eegfiltfft(obj.PotentialCache(index, :), obj.Frequency, obj.LowPassband, obj.HighPassband);
                else
                    ref = eegfiltfft(obj.Data(obj.ReferenceChannels,:), obj.Frequency, obj.LowPassband, obj.HighPassband);
                    FilteredReferencedEEGSegment = eegfiltfft(obj.PotentialCache(index, :) - mean2(ref), obj.Frequency, obj.LowPassband, obj.HighPassband);
                end
            catch
                FilteredReferencedEEGSegment = [];
            end
        end
        
        function obj = ClearPotentialCache(obj)
            obj.PotentialCache = [];
            obj.TriggerCount = 0;
        end
        
        function nChannel = NumberOfDataChannels(obj)
            nChannel = size(obj.Data, 1);
        end
        
        function nChannel = NumberOfTriggerChannels(obj)
            nChannel = size(obj.TriggerSignals, 1);
        end
    end
    
end

