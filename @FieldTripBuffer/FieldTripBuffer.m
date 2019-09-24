classdef FieldTripBuffer < RECInputBuffer
    %FieldTripBuffer This class represent FieldTrip Buffer program.
    %
    %   This class handle data reading from FieldTrip Buffer data
    %   stream. Its properties are parameters related to FieldTrip
    %   connection setting.
    
    properties
        Name = 'FieldTrip'
        
        Address
        Port
        PreviousSamples
    end
    
    properties (SetAccess = protected, GetAccess = protected)
        ReadBufferTimer
    end
    
    methods
        % Constructor
        function obj = FieldTripBuffer(address, port)
            if nargin == 2
                obj.Address = address;
                obj.Port = port;
                obj.PreviousSamples = 0;
            end
        end
    end
    
end

