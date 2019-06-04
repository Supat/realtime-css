function obj = StartReadBuffer(obj)
%StartReadBuffer This function start the data reading from external sensor.
%   This function establishes a connection with external sensor according to
%   the mode of acquisition it is implementing. Then it sets up a timer to
%   periodincally call 'ReadBuffer' method to continuously read the sensor
%   data.

try
    obj = obj.OpenInletType('EEG');
    
    notify(obj, 'StartReadingInputBuffer');

    obj.ReadBufferTimer = timer('ExecutionMode', 'fixedSpacing', ...
        'TimerFcn', @(~,~)obj.ReadBuffer, ...
        'Period', 0.5);

    disp('Start reading from LSL buffer')

    start(obj.ReadBufferTimer);
catch
    disp('LSL error occurs')
    msgbox('Unable to open LSL stream', 'LSL Error', 'error');
end

end

