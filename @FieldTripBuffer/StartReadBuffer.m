function obj = StartReadBuffer(obj)
%StartReadBuffer This function start the data reading from external sensor.
%   This function establishes a connection with external sensor according to
%   the mode of acquisition it is implementing. Then it sets up a timer to
%   periodincally call 'ReadBuffer' method to continuously read the sensor
%   data.

notify(obj, 'StartReadingInputBuffer');

obj.ReadBufferTimer = timer('ExecutionMode', 'fixedSpacing', ...
    'TimerFcn', @(~,~)obj.ReadBuffer, ...
    'Period', 0.5);
obj.PreviousSamples = 1;
disp('Start reading from FieldTrip buffer')
start(obj.ReadBufferTimer);
end

