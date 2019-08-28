function obj = StartReadBuffer(obj)
%StartReadBuffer This function start the data reading from external sensor.
%   This function establishes a connection with external sensor according to
%   the mode of acquisition it is implementing. Then it sets up a timer to
%   periodincally call 'ReadBuffer' method to continuously read the sensor
%   data.

try
    obj = obj.OpenSocket();
    notify(obj, 'StartReadingInputBuffer');

    obj.ReadBufferTimer = timer('ExecutionMode', 'fixedSpacing', ...
        'TimerFcn', @(~,~)obj.ReadBuffer, ...
        'Period', 0.5);
    obj.BufferIteration = 0;
    disp('Start reading from Actiview buffer')
    start(obj.ReadBufferTimer);
catch
    disp('Actiview error occurs')
    msgbox('Unable to connect to Actiview', 'Actiview Error', 'error');
end
end

