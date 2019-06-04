function obj = ReadBuffer(obj)
%ReadBuffer This function read data from exteranl sensor.
%   This function read data from exteranl sensor using specific
%   implementation according to its mode of acquisition.

disp('Reading data from Actiview Buffer...')
try
    [rawData, count, msg] = fread(obj.Socket,[3 obj.Words],'uint8');
    
    assert(count == 3 * obj.Words, msg);
    
    normaldata = rawData(3,:)*(256^3) + rawData(2,:) * (256^2) + rawData(1,:) * 256 + 0;
%     j = 1 + (0 * obj.Frequency) : obj.Frequency + (0 * obj.Frequency);
    i = 0 : obj.ChannelCount : obj.Words - 1;
    data_struct2 = zeros(obj.Frequency, obj.ChannelCount);
    for d = 1 : obj.ChannelCount
%         data_struct(j, d) = typecast(uint32(normaldata(i + d)), 'int32'); %puts the data directly into the display buffer at the correct place
        data_struct2(1:obj.Frequency, d) = typecast(uint32(normaldata(i + d)), 'int32'); %create a data struct where each channel has a seperate column
    end
    
    %assert(isempty(data_struct2), 'Error retrieving data from Actiview socket.');
    
    obj.BufferIteration = obj.BufferIteration + 1;
    
    bufferChannelLabel = obj.ChannelLabel;
    
    if obj.UsingTriggerChannel == 0
        ReadBufferEventData = BufferData(data_struct2', obj.Frequency, obj.ChannelCount, bufferChannelLabel);
    else
        [EEG, Trig, EEGLabel, TrigLabel] = obj.ExtractTriggerSignal(data_struct2', bufferChannelLabel);
        ReadBufferEventData = MarkedEEGData(EEG, Trig, obj.Frequency, obj.ChannelCount, EEGLabel, TrigLabel);
    end
    notify(obj, 'InputBufferDataAvailable', ReadBufferEventData);
catch
    disp(msg)
    notify(obj, 'InputBufferDataUnavailable');
end
end

