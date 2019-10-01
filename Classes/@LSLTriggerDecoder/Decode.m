function [Timepoints, Markers] = Decode(obj, rawSignal)
%Decode This function decode trigger signal into readable value.
%   This function decodes 32-bit BioSemi trigger signal into decimal value.
%   According to BioSemi specification, the trigger value is encoded at bit
%   8 to 23. The function first converts signal into binary then strip
%   unrelated bit off and finally convert the binary back into decimal.
%
%   The process to decode trigger signal is as follow:
%   1. Cast value to int32.
%   2. Left shift 8 bit to remove header bits.
%   3. Right shift 8 + 8 bit to remove tailer bits.
%   4. Apply XOR mask to mask out irrelavent bits.

[Timepoints, Markers] = obj.ExtractMarkers(rawSignal);

%% Simulated signal for debugging
% Timepoints = ceil(length(rawSignal)/3);
% Markers = rawSignal(Timepoints);

%%
if ~isempty(Markers)
	Markers = transpose(bi2de(de2bi(bitsrl(bitsll(typecast(int32(Markers), 'uint32'), obj.SignalBitLength - obj.TriggerOffset), obj.SignalBitLength - obj.TriggerOffset), 'left-msb'), 'left-msb'));
end
end

