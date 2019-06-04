function obj = ReadBuffer(obj)
%ReadBuffer This function read data from exteranl sensor.
%   This function read data from exteranl sensor using specific
%   implementation according to its mode of acquisition.

disp('Reading data from LSL Buffer...')

try
    [bufferData, ~] = obj.Inlet.pull_chunk();
    bufferFrequency = obj.ResolveStreamFrequency;
    bufferChannelCount = obj.ResolveChannelCount;
    bufferChannelLabel = obj.ResolveChannelLabel;
    ReadBufferEventData = BufferData(bufferData, bufferFrequency, bufferChannelCount, bufferChannelLabel);
    notify(obj, 'InputBufferDataAvailable', ReadBufferEventData);
catch
    notify(obj, 'InputBufferDataUnavailable');
end

end

