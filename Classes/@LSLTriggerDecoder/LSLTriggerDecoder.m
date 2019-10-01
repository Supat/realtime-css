classdef LSLTriggerDecoder < RECTriggerDecoder
    %BioSemiTriggerDecoder This class responsible for decode BioSemi
    %trigger signal.
    %
    %   This class handle BioSemi trigger signal decoding according to
    %   BioSemi signal specification. Its properties are defined by BioSemi
    %   specification. Only property 'TriggerOffset' is an extra property
    %   unrelated to BioSemi implementation.
    %
    %   Extra properties beside BioSemi implementation:
    %   1. 'TriggerOffset' - often, when recording the trigger data, we do
    %   not use all of the 16 channel available for trigger signal. This
    %   property provide the information for the decoding process to know
    %   how many channels are actually used. 
    
    properties
        TriggerOffset = 0;
    end
    
    properties (SetAccess = protected, GetAccess = protected)
        SignalBitLength = 32;
    end
    
    properties (SetAccess = protected)
        TriggerBitLength = 3;
    end
    
    methods
        % Constructor
        function obj = LSLTriggerDecoder()
        end
        
        function [XCoordinates, Values] = ExtractMarkers(obj, signal)
            XCoordinates = zeros(1, length(signal));
            Values = zeros(1, length(signal));
            count = 1;
            oldValue = signal(1);
            for i = 2:length(signal)
                newValue = signal(i);
                if newValue ~= oldValue
                    XCoordinates(count) = i;
                    Values(count) = signal(i);
                    count = count + 1;
                end
                oldValue = newValue;
            end
            XCoordinates = XCoordinates(1:count - 1);
            Values = Values(1:count - 1);
        end
    
    end
end

