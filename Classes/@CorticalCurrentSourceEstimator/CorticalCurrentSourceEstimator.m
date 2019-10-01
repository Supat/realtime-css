classdef CorticalCurrentSourceEstimator < handle
    %CorticalCurrentSourceEstimator A class modeled for cortical current
    %source estimation
    %
    %   This class manages functionalities related to cortical current
    %   source estimation.
    
    properties (SetAccess = private)
        ProfileList
        CurrentProfile
    end
    
    events
        NewProfileAdded
        CurrentProfileSet
        CurrentSourceAvailable
        CurrentSourceUnavailable
    end
    
    methods
        % Constructor
        function obj = CorticalCurrentSourceEstimator()
            obj.ProfileList = [];
        end
    end
end

