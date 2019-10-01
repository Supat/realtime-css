classdef RECInputBuffer < handle
    %RECInputBuffer This is an abstract class defining an interface for
    %sensor data reading.
    %
    %   This class is an abstract class (an empty class without any
    %   implementation, just the prototype of the class is provided)
    %
    %   This class define the interface for reading data from sensor into
    %   the program. Any handle class that implement sensor data reading
    %   functionality must inherit this class to be able to interface with
    %   the rest of the program.
    %
    %   This class has 3 abstract methods that must be implemented in the
    %   descendant of this class.
    %   1. 'StartReadBuffer' - this method must establish connection with
    %   external sensor and set up a timer to call 'ReadBuffer' method
    %   periodically. If everything is successfully executed, it must
    %   notify 'StartReadingInputBuffer' event.
    %   2. 'ReadBuffer' - this method must retrieve a chunk of data from
    %   external sensor. If it is successful, it must notify
    %   'InputBufferDataAvailable' event, otherwise it must notify
    %   'InputBufferDataUnavailable' event.
    %   3. 'StopReadBuffer' - this method must stop the running timer and
    %   disconnect the external sensor. If it is successful, it must notify
    %   'StopReadingInputBuffer' event.
   
    properties (Abstract)
        Name
    end
    
    methods (Abstract)
       StartReadBuffer(obj)
       ReadBuffer(obj)
       StopReadBuffer(obj)
   end
   
   events
       InputBufferDataAvailable
       InputBufferDataUnavailable
       StartReadingInputBuffer
       StopReadingInputBuffer
   end
end 