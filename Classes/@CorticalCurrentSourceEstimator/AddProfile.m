function obj = AddProfile(obj, newProfile)
%AddProfile add new estimator profile into CorticalCurrentSourceEstimator
%object.
%   This function receives a new structure contains 'profile' variable
%   and append it to ProfileList property of CorticalCurrentSourceEstimator
%   object, then notify to its listener with 'NewProfileAdded' event.
%
%   newProfile = an object of type EstimatorProfile
%

obj.ProfileList = [obj.ProfileList newProfile];
notify(obj, 'NewProfileAdded');
end

