function obj = ReadBuffer(obj)
%ReadBuffer This function read data from exteranl sensor.
%   This function read data from exteranl sensor using specific
%   implementation according to its mode of acquisition.

disp('Reading data from LSL Buffer...')

try
    bufferData = [];
    while (isempty(bufferData))
        [bufferData, ~] = obj.Inlet.pull_chunk();
    end
catch
	bufferData = obj.Inlet.pull_chunk();
	disp('Timestamps data are omitted due to unidentified problem')
end

try    
    obj.ResolveStreamFrequency;
    bufferFrequency = obj.Frequency;
    obj.ResolveChannelCount;
    bufferChannelCount = obj.ChannelCount;
    obj.ResolveChannelLabel;
    bufferChannelLabel = obj.ChannelLabel;
    
    if any(strcmp(bufferChannelLabel, 'Trig1'))
    	[EEG, Trig, EEGLabel, TrigLabel] = obj.ExtractTriggerSignal(bufferData, obj.ChannelLabel);
        ReadBufferEventData = MarkedEEGData(EEG, Trig, obj.Frequency, obj.ChannelCount, EEGLabel, TrigLabel);
    else
    	ReadBufferEventData = BufferData(bufferData, bufferFrequency, bufferChannelCount, bufferChannelLabel);
    end
    notify(obj, 'InputBufferDataAvailable', ReadBufferEventData);
catch
    notify(obj, 'InputBufferDataUnavailable');
end

end

