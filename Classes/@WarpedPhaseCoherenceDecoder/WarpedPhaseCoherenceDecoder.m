classdef WarpedPhaseCoherenceDecoder < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Alpha = 0;
        AverageRelativePhaseRemovalFlag = 0;
        AmplitudeFluctuationsRemovalFlag = 0;
        Rescaling = 1;
    end
    
    events
        PhaseLockingValueAvailable
        PhaseLockingValueUnavailable
    end
    
    methods
        % Constructor
        function obj = WarpedPhaseCoherenceDecoder()
            
        end
        
        function set.Alpha(obj, alpha)
            disp('Set new alpha');
            obj.Alpha = alpha;
        end
        
        function set.AverageRelativePhaseRemovalFlag(obj, flag)
            disp('Set new flag 1');
            obj.AverageRelativePhaseRemovalFlag = flag;
        end
        
        function set.AmplitudeFluctuationsRemovalFlag(obj, flag)
            disp('Set new flag 2');
            obj.AmplitudeFluctuationsRemovalFlag = flag;
        end
        
        function set.Rescaling(obj, rescaling)
            disp('Set new rescaling');
            obj.Rescaling = rescaling;
        end
    end
end

