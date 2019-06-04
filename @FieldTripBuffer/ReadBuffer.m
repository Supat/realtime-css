function obj = ReadBuffer(obj)
%ReadBuffer This function read data from exteranl sensor.
%   This function read data from exteranl sensor using specific
%   implementation according to its mode of acquisition.

disp('Reading data from FieldTrip Buffer...')
try
    bufferHeader = ft_read_header(strcat('buffer://', obj.Address, ':' , obj.Port));
    bufferData = ft_read_data(strcat('buffer://', obj.Address, ':' , obj.Port), 'begsample', obj.PreviousSamples, 'endsample', inf);
    obj.PreviousSamples = bufferHeader.nSamples;
    ReadBufferEventData = BufferData(bufferData, bufferHeader.Fs, bufferHeader.nChans, bufferHeader.label);
    notify(obj, 'InputBufferDataAvailable', ReadBufferEventData);
catch
    notify(obj, 'InputBufferDataUnavailable');
end
end

