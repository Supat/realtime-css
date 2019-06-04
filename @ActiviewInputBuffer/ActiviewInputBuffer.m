classdef ActiviewInputBuffer < RECInputBuffer & RECTriggerBuffer
    %ActiviewInputBuffer This class represent Actiview acquisition program.
    %
    %   This class handle data reading from BioSemi Actiview data tcp/ip
    %   streaming. Its properties are parameters related to Actiview
    %   program setting.
    
    properties
        Address
        Port
        ChannelCount
        Frequency
        ChannelLabel
        ChannelOption = 1;
        UsingEXChannel = false;
        UsingSensorsChannel = false;
        UsingJazzChannel = false;
        UsingAIBChannel = false;
        UsingTriggerChannel = false;
        TriggerBitLength = 16;
        
        TriggerDecoder
    end
    
    properties (SetAccess = protected, GetAccess = protected)
        ReadBufferTimer
        Socket
        Words
        BufferIteration
    end
    
    methods
        % Constructor
        function obj = ActiviewInputBuffer(address, port, channelOption, exChannel, sensors, jazz, AIB, trigger, Frequency)
            if nargin == 9
                obj.Address = address;
                obj.Port = port;
                obj.ChannelOption = channelOption;
                obj.UsingEXChannel = exChannel;
                obj.UsingSensorsChannel = sensors;
                obj.UsingJazzChannel = jazz;
                obj.UsingAIBChannel = AIB;
                obj.UsingTriggerChannel = trigger;
                obj.ResolveChannelCount();
                obj.ResolveChannelLabel();
                obj.Frequency = Frequency;
                obj.Socket = tcpip(obj.Address, obj.Port, 'NetworkRole', 'Client');
                obj.Words = obj.ChannelCount * obj.Frequency;
                
                obj.TriggerDecoder = BioSemiTriggerDecoder();
                obj.TriggerDecoder.TriggerOffset = obj.TriggerBitLength;
            end
        end
        
        % Establish TCP/IP connection
        function obj = OpenSocket(obj)
            obj.Socket.InputBufferSize = obj.Words * 10;
            obj.Socket.Timeout = 5000;
            disp('Opening Actiview TCP/IP socket...');
            fopen(obj.Socket);
        end
        
        % Close TCP/IP connection
        function obj = CloseSocket(obj)
            try
                disp('Closing Actiview TCP/IP socket...');
                fclose(obj.Socket);
            catch
                disp('Cannot close Actiview TCP/IP socket.');
            end
        end
        
        function obj = set.Address(obj, address)
            obj.Address = address;
            obj = obj.UpdateSocketProperties();
        end
        
        function obj = set.Port(obj, port)
            obj.Port = port;
            obj = obj.UpdateSocketProperties();
        end
        
        function obj = set.Frequency(obj, frequency)
            obj.Frequency = frequency;
            obj = obj.UpdateSocketProperties();
        end
        
        function obj = set.ChannelOption(obj, channelOption)
            obj.ChannelOption = channelOption;
            obj = obj.UpdateActiviewParameters();
        end
        
        function obj = set.UsingEXChannel(obj, exChannel)
            obj.UsingEXChannel = exChannel;
            obj = obj.UpdateActiviewParameters();
        end
        function obj = set.UsingSensorsChannel(obj, sensors)
            obj.UsingSensorsChannel = sensors;
            obj = obj.UpdateActiviewParameters();
        end
        function obj = set.UsingJazzChannel(obj, jazz)
            obj.UsingJazzChannel = jazz;
            obj = obj.UpdateActiviewParameters();
        end
        function obj = set.UsingAIBChannel(obj, AIB)
            obj.UsingAIBChannel = AIB;
            obj = obj.UpdateActiviewParameters();
        end
        function obj = set.UsingTriggerChannel(obj, trigger)
            obj.UsingTriggerChannel = trigger;
            obj = obj.UpdateActiviewParameters();
        end
        function obj = set.TriggerBitLength(obj, triggerBitLength)
            obj.TriggerBitLength = triggerBitLength;
            obj = obj.UpdateTriggerOffset();
        end
        
        function obj = UpdateTriggerOffset(obj)
            obj.TriggerDecoder.TriggerOffset = obj.TriggerBitLength;
        end
        
        function obj = UpdateSocketProperties(obj)
            if (~isempty(obj.Address) && ~isempty(obj.Port))
                obj.Socket = tcpip(obj.Address, obj.Port, 'NetworkRole', 'Client');
            end
            
            if (~isempty(obj.ChannelCount) && ~isempty(obj.Frequency))
                obj.Words = obj.ChannelCount * obj.Frequency;
            end
        end
        
        function obj = UpdateActiviewParameters(obj)
            obj.ResolveChannelCount();
            obj.ResolveChannelLabel();
            obj.UpdateSocketProperties();
        end
        
        function obj = ResolveChannelLabel(obj)
            switch obj.ChannelOption
                case 1
                    obj.ChannelLabel = {};
                case 2
                    obj.ChannelLabel = strseq('A', 1:8);
                case 3
                    obj.ChannelLabel = strseq('A', 1:16);
                case 4
                    obj.ChannelLabel = strseq('A', 1:32);
                case 5
                    obj.ChannelLabel = vertcat(strseq('A', 1:32), strseq('B', 1:32));
                case 6
                    obj.ChannelLabel = vertcat(strseq('A', 1:32), strseq('B', 1:32), strseq('C', 1:32), strseq('D', 1:32));
                case 7
                    obj.ChannelLabel = vertcat(strseq('A', 1:32), strseq('B', 1:32), strseq('C', 1:32), ...
                        strseq('D', 1:32), strseq('E', 1:32));
                case 8
                    obj.ChannelLabel = vertcat(strseq('A', 1:32), strseq('B', 1:32), strseq('C', 1:32), ...
                        strseq('D', 1:32),  strseq('E', 1:32), strseq('F', 1:32), strseq('G', 1:32), strseq('H', 1:32));
            end
            
            if obj.UsingEXChannel
                obj.ChannelLabel = vertcat(obj.ChannelLabel, strseq('EX', 1:8));
            end
            
            if obj.UsingSensorsChannel
                obj.ChannelLabel = vertcat(obj.ChannelLabel, strseq('Sensors', 1:7));
            end
            
            if obj.UsingJazzChannel
                obj.ChannelLabel = vertcat(obj.ChannelLabel, strseq('Jazz', 1:9));
            end
            
            if obj.UsingAIBChannel
                obj.ChannelLabel = vertcat(obj.ChannelLabel, strseq('AIB', 1:32));
            end
            
            if obj.UsingTriggerChannel
                obj.ChannelLabel = vertcat(obj.ChannelLabel, 'TRIG');
            end
        end
        
        function obj = ResolveChannelCount(obj)
            switch obj.ChannelOption
                case 1
                    obj.ChannelCount = 0;
                case 2
                    obj.ChannelCount = 8;
                case 3
                    obj.ChannelCount = 16;
                case 4
                    obj.ChannelCount = 32;
                case 5
                    obj.ChannelCount = 64;
                case 6
                    obj.ChannelCount = 128;
                case 7
                    obj.ChannelCount = 160;
                case 8
                    obj.ChannelCount = 256;
            end
            
            if obj.UsingEXChannel
                obj.ChannelCount = obj.ChannelCount + 8;
            end
            
            if obj.UsingSensorsChannel
                obj.ChannelCount = obj.ChannelCount + 7;
            end
            
            if obj.UsingJazzChannel
                obj.ChannelCount = obj.ChannelCount + 9;
            end
            
            if obj.UsingAIBChannel
                obj.ChannelCount = obj.ChannelCount + 32;
            end
            
            if obj.UsingTriggerChannel
                obj.ChannelCount = obj.ChannelCount + 1;
            end
        end
        
        function signal = ResolveTriggerSignal(obj, triggerSignal)
            signal = obj.TriggerDecoder.Decode(triggerSignal);
        end
       
    end
    
end

