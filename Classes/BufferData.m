classdef (ConstructOnLoad) BufferData < event.EventData 
    %BufferData This class is a container for data read from input buffer
    %   This class encapsulates raw data read from input buffer
    %   in order to pass the encapsulated data to input buffer
    %   listeners.
    %
    %   This class has 2 properties:
    %   1. RawData - raw signal read from sensor
    %   2. Header - metadata of the signal (frequency, channel count,
    %       channel label)
    %
    %   This class has no method because it is a wrapper class.
    %
    %   This class constructor requires signal data, frequency, channel
    %   count, and channel label as the input.
    %
    %   This class inherit 'event.EventData' class because in order to pass
    %   this class's object to callback function via Matlab 'Event and
    %   Listener' mechanism, this object must conform to 'event.EventData'
    %   interface.
    
    properties
        RawData
        Header
    end
    
    methods
        % Constructor
        function data = BufferData(bufferData, freq, nChans, label)
            if nargin >= 2
                data.Header.Fs = freq;
                data.Header.nChans = nChans;
                data.Header.label = label;
                data.RawData = bufferData;
            end
        end
    end
    
end

