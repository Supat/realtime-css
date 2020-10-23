% Add path of 'Classes' directory to make the implementation available for
% in this script
addpath(strcat(pwd, '/Classes'));

%% Global variable declaration
%   To read calculate current source in realtime, we need
%   1. 'inputBuffer' - this buffer interacts directly with the data stream
%   from acquisition device.
%   2. 'signalBuffer' - in realtime system, the live data stream does not
%   always guarantee consistant flow of data, therefore we do not interact
%   directly with the live data stream, but the buffered data.
%   3. 'estimator' - this object responsible for current source related
%   calculation.
global inputBuffer;
global signalBuffer;
global estimator;

%% Object variable initiation
inputBuffer = LSLInputBuffer();
signalBuffer = EEGSignalBuffer(10); % initiate signal buffer of 10 seconds length
estimator = CorticalCurrentSourceEstimator();

%% Add listener callback function to the input buffer and the estimator
inputBufferDataAvailableListener = addlistener(inputBuffer, 'InputBufferDataAvailable', @(src, event)inputBufferDataAvailableListener_Callback(src, event));
currentSourceAvailableListener = addlistener(estimator, 'CurrentSourceAvailable', @(src, event)currentSourceAvailableListener_Callback(src, event));

%% Set parameter related to signal processing
%   Object of type 'EEGSignalBuffer' has built-in function for bandpass
%   filter and re-referencing.
signalBuffer.HighPassband = 30;
signalBuffer.LowPassband = 1;
signalBuffer.ReferenceChannels = 65:66;

%   Load inverse matrix for current source estimation.
profileVariable = load(strcat(pwd, '/Sample Profiles/profile_high_left_flexion.mat'), 'profile');
estimatorProfile = EstimatorProfile('Profile Name', profileVariable.profile);
estimator = estimator.AddProfile(estimatorProfile);

%% Commencing data acquisition
%   After the 'StartReadBuffer' is called, whenever the new data is
%   available, 'inputBufferDataAvailableListener_Callback' function
%   will be called.
inputBuffer.StartReadBuffer();

%% Callback functions
function inputBufferDataAvailableListener_Callback(src, event)

global signalBuffer;
global estimator;

% Append new data into signal buffer along with their metadata.
signalBuffer = signalBuffer.AppendDataWithFrequency(event.RawData, event.Header.Fs);
signalBuffer.DataLabels = event.Header.label;

% At this point, the most recent data in 10 seconds window is available in
% 'signalBuffer'. Since 'signalBuffer' has built-in re-referencing and
% filtering, by calling 'DataForFilterInput', the 'signalBuffer' will
% return re-referenced and filtered signal, ready for current source
% estimation. Accessing raw data for different type of processing is also
% possible.
data = signalBuffer.DataForFilterInput(1:64);

% Feed EEG data to current source estimator
% When the EEG data is input into the estimator, the estimator will
% estimated the current source, then call the
% 'currentSourceAvailableListener_Callback' function.
estimator.FeedEEG(data);

end


function currentSourceAvailableListener_Callback(src, event)

% Resulting current source is available here.
currentSourceData = event.Current(1:2,:);

end