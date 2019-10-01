classdef RECTriggerBuffer < handle
    %RECTriggerBuffer This is an abstract class defining an interface for
    %trigger signal decoding.
    %
    %   This class is an abstract class (an empty class without any
    %   implementation, just the prototype of the class is provided).
    %
    %   This class define the interface for decoding trigger signal 
    %   from sensor into the program. Any handle class that implement 
    %   trigger signal reading functionality must inherit this class to be 
    %   able to interface with the rest of the program.
    %
    %   This class has 1 abstract property that must be included in the
    %   descendent of this class.
    %   1. 'TriggerDecoder' - this property must be a descendent of an
    %   abstract class 'TriggerDecoder'.
    
    properties (Abstract)
        TriggerDecoder
    end
    
    methods (Abstract)
        [EEGSignals, TriggerSignals, EEGLabels, TriggerLabels] = ExtractTriggerSignal(obj, rawSignals, labels)
    end
    
end

