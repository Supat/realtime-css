classdef (ConstructOnLoad) CurrentSource < event.EventData
    %CurrentSource This class contain estimated current source data
    %   This class encapsulates current source data estimated by
    %   'CorticalCurrentSourceEstimator' object in order to pass current
    %   source data the listeners.
    %
    %   This class has 1 property:
    %   1. Current - estimated cortical current source data
    %
    %   This class has no method because it is a wrapper class.
    %
    %   This class constructor requires raw current source data as the sole
    %   input.
    %
    %   This class inherit 'event.EventData' class because in order to pass
    %   this class's object to callback function via Matlab 'Event and
    %   Listener' mechanism, this object must conform to 'event.EventData'
    %   interface.
    
    properties
        Current;
    end
    
    methods
        % Constructor
        function obj = CurrentSource(rawCurrent)
            obj.Current = rawCurrent;
        end
    end
    
end

