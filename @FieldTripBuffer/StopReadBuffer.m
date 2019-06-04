function obj = StopReadBuffer(obj)
%StopReadBuffer This function stop the reading of external sensor data.
%   This function stops the 'ReadBuffer' timer then cut the connection with 
%   the external sensor 

stop(obj.ReadBufferTimer);
notify(obj, 'StopReadingInputBuffer');
disp('Stop reading from FieldTrip buffer')
end

