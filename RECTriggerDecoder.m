classdef RECTriggerDecoder
    %TriggerDecoder This is an abstract class defining an interface for
    %trigger signal decoding.
    %
    %   This class is an abstract class (an empty class without any
    %   implementation, just the prototype of the class is provided).
    %
    %   This class define the interface for decoding trigger signal into
    %   readable value. TriggerDecoder property of any RECTriggerBuffer 
    %   class that is resposible for resolving decoded trigger signal must
    %   inherit this classs.
    %
    %   This class has 1 abstract method that must be implemented in the
    %   descendent of this class.
    %   1. 'Decode' - this method must receive only raw signal as an input
    %   and output coresponding decoded trigger signal.
    
    methods (Abstract)
        [Timepoints, Markers] = Decode(obj, rawSignal)
    end
end

