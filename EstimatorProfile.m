classdef EstimatorProfile
    %EstimatorProfile This class is a container for various information
    %needed by current source estimator.
    %   This class encapsulates various information used by current source
    %   estimator so it can be stored and used by the estimator.
    %
    %   This class has 13 properties. Some properties corresponds to VBMEG
    %   variable as followed:
    %   1. Name - name of the profile
    %   2. Profile - profile file's data structure
    %   3. Filter - KW
    %   4. PosteriorSensorCovarianceMatrix - SB_cov
    %   5. ModelEntropy - Hj
    %   6. ObservationNoiseVariance - sx
    %   7. EEGChannelNumber - EEG signal channel count
    %   8. CCSChannelNumber - current source count
    %   9. EEGChannelName - EEG signal channel label
    %   10. CorticalVertexCoordinates - V
    %   11. CorticalSurfacePatchIndex - F
    %   12. InflatedGyrusColorProfile - inf_C
    %   13. CCSInfo - Jinfo
    
    properties (SetAccess = private)
        Name
        Profile
        Filter
        PosteriorSensorCovarianceMatrix
        ModelEntropy
        ObservationNoiseVariance
        EEGChannelNumber
        CCSChannelNumber
        EEGChannelName
        CorticalVertexCoordinates
        CorticalSurfacePatchIndex
        InflatedGyrusColorProfile
        CCSInfo
    end
    
    methods
        % Constructor
        function obj = EstimatorProfile(name, profile)
            obj.Name = name;
            obj.Profile = profile;
            [CCSChans, EEGChans, ~] = size(profile.filter.KW);
            obj.EEGChannelNumber = EEGChans;
            obj.CCSChannelNumber = CCSChans;
            obj.EEGChannelName = profile.current.Jinfo.channel_name;
            obj.Filter = profile.filter.KW;
            obj.PosteriorSensorCovarianceMatrix = profile.filter.SB_cov;
            obj.ModelEntropy = profile.filter.Hj;
            obj.ObservationNoiseVariance = profile.filter.sx;
            obj.CorticalVertexCoordinates = profile.brain.V;
            obj.CorticalSurfacePatchIndex = profile.brain.F;
            obj.InflatedGyrusColorProfile = profile.brain.inf_C;
            obj.CCSInfo = profile.current.Jinfo;
        end
    end
end

