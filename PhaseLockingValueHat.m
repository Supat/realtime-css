classdef (ConstructOnLoad) PhaseLockingValueHat < event.EventData
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Value
    end
    
    methods
        function obj = PhaseLockingValueHat(plv_hat)
            obj.Value = plv_hat;
        end
    end
end

