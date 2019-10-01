function obj = ApplyCurrentProfile(obj, profileNumber)
%ApplyCurrentProfile Set current inverse filter for CorticalCurrentSource
%object.
%   This function assign an object of type InverseFilter from
%   CorticalCurrentSource object's 'ProfileList' property at the index
%   specified by 'profileNumber' to the CorticalCurrentSource object's
%   'CurrentProfile' property.
%
%   filterNumber = an integer specified the index of desired filter in
%   'ProfileList' property

obj.CurrentProfile = obj.ProfileList(profileNumber);
notify(obj, 'CurrentProfileSet');
end

