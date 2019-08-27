classdef LSLInputBuffer < RECInputBuffer
    %LSLInputBuffer This class represent LSL Data Stream.
    %
    %   This class handle data reading from LSL Stream. Its properties are 
    %   parameters related to LSL connection setting.
    
    properties
		Frequency
		ChannelLabel
		ChannelCount
    end
    
    properties (SetAccess = protected, GetAccess = protected)
        ReadBufferTimer
        Lib
        Inlet
    end
    
    methods
        % Constructor
        function obj = LSLInputBuffer(signalType)
            try
            	disp('Loading LSL library...');
                obj.Lib = lsl_loadlib();
            catch
                disp('Unable to load LSL library');
            end
            
            if nargin == 1
            	try
            		disp('Opening an inlet...');
                	obj = obj.OpenInletType(signalType);
                catch
                	disp('Unable to open an inlet');
                end
            end
        end
        
        function obj = OpenInletType(obj, signalType)
            disp('Resolving LSL stream...');
            stream = {};
            stream = lsl_resolve_byprop(obj.Lib, 'type', signalType);
            disp('Registering stream to the inlet...');
            obj.Inlet = lsl_inlet(stream{1});
            obj.Frequency = obj.ResolveStreamFrequency();
            obj.ChannelCount = obj.ResolveChannelCount();
            obj.ChannelLabel = obj.ResolveChannelLabel();
        end
        
        function Fs = ResolveStreamFrequency(obj)
        	disp('Resolving inlet sampling rate...');
            Fs = obj.Inlet.info.nominal_srate();
            obj.Frequency = Fs;
        end
        
        function Ch = ResolveChannelCount(obj)
        	disp('Resolving inlet channel count...');
            Ch = obj.Inlet.info.channel_count();
            obj.ChannelCount = Ch;
        end
        
        function ChLb = ResolveChannelLabel(obj)
        	disp('Resolving inlet channel label...');
        	try
            	ChLb = cell(obj.Inlet.info.channel_count(), 1);
            	ch = obj.Inlet.info.desc().child('channels').child('channel');
            	for k = 1:obj.Inlet.info.channel_count()
%                 fprintf(['  ' ch.child_value('label') '\n']);
                	ChLb(k) = {ch.child_value('label')};
                	ch = ch.next_sibling();
            	end
            	obj.ChannelLabel = ChLb;
            catch
            	disp('Unable to resolve channel label from LSL inlet')
            end
            
            try
            	for i=1:length(ChLb)
            		if (isempty(ChLb(i)))
            			ME = MException('LSLInputBuffer:ChannelLabelMissing', ...
            				'Empty label found while resolving channel label from LSL inlet');
            		end
            	end
            catch
            	disp('Cannot properly resolve channel label from LSL inlet, assuming the label...')
            	switch obj.ChannelCount
            		case {185, 168}
            			obj.ChannelLabel = vertcat(strseq('A', 1:32), strseq('B', 1:32), ...
            				strseq('C', 1:32), strseq('D', 1:32), strseq('E', 1:32));
            		case {153, 136}
            			obj.ChannelLabel = vertcat(strseq('A', 1:32), strseq('B', 1:32), ...
            				strseq('C', 1:32), strseq('D', 1:32));
            		case {89, 72}
            			obj.ChannelLabel = vertcat(strseq('A', 1:32), strseq('B', 1:32));
            		case {57, 40}
            			obj.ChannelLabel = vertcat(strseq('A', 1:32));
            	end
            	
            	switch obj,ChannelCount
            		case {185, 153, 89, 57}
            			obj.ChannelLabel = vertcat(obj.ChannelLabel, strseq('EX', 1:8));
            			obj.ChannelLabel + vertcat(obj.ChannelLabel, strseq('Sensors', 1:7));
            			obj.ChannelLabel = vertcat(obj.ChannelLabel, strseq('Jazz', 1:9));
            			obj.ChannelLabel = vertcat(obj.ChannelLabel, strseq('Trig', 1));
            	end
            end
            
            try
            	if (obj.ChannelCount == length(obj.ChennelLabel))
            		ME = MException('LSLInputBuffer:channelCountMismatch', ...
            			'Channel count and number of label does not agree');
            	end
            catch
            	disp('Channel count mismatch')
            end
            
            try
            	if (isempty(find(strcmp('Trig1', ChLb))))
            		ME = MException('LSLInputBuffer:triggerChannelCannotBeIdentified', ...
            			'There is no trigger label presence in channel list');
            		throw(ME);	
            	end
            catch
            	
            end
        end
    end
    
end

