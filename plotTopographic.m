function plotTopographic(plotingAxes, data, profile, orientation, inflate, threshold, range)
%plotTopographic Plot current source topographic map
%   Plot current source topographic map to separate figure in real-time
%
%   Supat Saetia in collaboration with ATR (Nov 7, 2017)
%
%   Copyright (C) 2011, ATR All Rights Reserved.
%   License : New BSD License(see VBMEG_LICENSE.txt)

% orientation = 'LR';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load and plot model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% model = 'Inflate';
% model = 'Cortex';
% if strcmp(model, 'Inflate')
%     % Plot Inflate model
%     [V, F] = vb_load_cortex(brain_file, 'Inflate');
%     vb_plot_cortex_surf(brain_file, 'LR', 1);
% else
%     % Plot Cortex
%     [V, F] = vb_load_cortex(brain_file);
%     vb_plot_cortex_surf(brain_file, 'LR', 0);
%     camlight headlight;
% end
%% Set plotting axes
% axes(plotingAxes);

%% Plot cortex

V = profile.CorticalVertexCoordinates;
F = profile.CorticalSurfacePatchIndex;
% xx = profile.brain.xx;
inf_C = profile.InflatedGyrusColorProfile;

VDipoleCount   = size(V,1);
LDipoleCount  = F.NdipoleL;

switch orientation
    case 'L'
        f = F.F3L;
        Vmax = max(V(1:LDipoleCount,:));
        Vmin = min(V(1:LDipoleCount,:));
        ang = [-80 40];
    case 'R'
        f = F.F3R;
        Vmax = max(V(LDipoleCount+1:VDipoleCount,:));
        Vmin = min(V(LDipoleCount+1:VDipoleCount,:));
        ang = [80 40];
    otherwise
        f = F.F3;
        Vmax = max(V);
        Vmin = min(V);
        ang = [0 80];
end

if inflate
    cscale = -0.4;
	c0 = 0.8;
	colors = c0 * (inf_C * cscale + 1);
	colors = repmat(colors ,[1 3]);
	plotingPatch = patch(plotingAxes, 'Faces',f,'Vertices',V,'FaceColor','interp',...
		'EdgeColor','none','FaceVertexCData',colors);
else
    fclr = [0.8 0.8 0.8];
    plotingPatch = patch(plotingAxes, 'Faces',f,'Vertices',V,'FaceColor',fclr,...
          'FaceLighting','phong','EdgeColor','none');
    camlight headlight;
end

% material dull;
plotingPatch.AmbientStrength = 0.3;
plotingPatch.DiffuseStrength = 0.8;
plotingPatch.SpecularStrength = 0.0;
plotingPatch.SpecularExponent = 10.0;
plotingPatch.SpecularColorReflectance = 1.0;


plotingAxes.XLim = [Vmin(1) Vmax(1)];
plotingAxes.YLim = [Vmin(2) Vmax(2)];
plotingAxes.ZLim = [Vmin(3) Vmax(3)];

% axis equal
% axis tight
plotingAxes.DataAspectRatio = [1, 1, 1];
plotingAxes.PlotBoxAspectRatio = [3, 4, 4];
plotingAxes.XLimMode = 'auto';
plotingAxes.YLimMode = 'auto';
plotingAxes.ZLimMode = 'auto';
view(plotingAxes, ang)

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot activity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load current
%[Jinfo, Jact] = vb_load_current(curr_file);
Jinfo = profile.CCSInfo;
Jact = data;

% Prepare to plot activity
% h = []; % graphics handle of activity
activity = zeros(size(V,1), 1);
colorbar(plotingAxes);

% set color range(depends on your data)
caxis(plotingAxes, range);
colormap(plotingAxes, jet);

% update activity
% time_window_length = 1; % depends on your data
% for k=1:1:700 % [time_from: time_step: time_end]

% remove previous plot
% if ~isempty(h), delete(h); end 

% average current by time_window_length of Jact
%     current_J = abs(mean(Jact(:, k:k+time_window_length), 2));
current_J = abs(mean(Jact, 2));

% find current data to plot
%     threshold = 1e-6; % depends on your data
j_ix = find(current_J >= threshold);

% convert selected Jact index to vertex index
ix_vertex = Jinfo.ix_act_ex(j_ix);

% set activity to plot
activity(:) = 0;
activity(ix_vertex) = current_J(j_ix);

% plot activity
FF = vb_patch_select2(ix_vertex, F.F3, size(V,1));
plotingPatch = patch(plotingAxes, 'Faces',FF,'Vertices',V,'FaceColor','interp',...
          'FaceVertexCData',activity,'EdgeColor','none',...
          'FaceLighting','none');
      
% material dull;
plotingPatch.AmbientStrength = 0.3;
plotingPatch.DiffuseStrength = 0.8;
plotingPatch.SpecularStrength = 0.0;
plotingPatch.SpecularExponent = 10.0;
plotingPatch.SpecularColorReflectance = 1.0;

plotingAxes.XTick = [];
plotingAxes.XTickLabel = [];
plotingAxes.YTick = [];
plotingAxes.YTickLabel = [];
plotingAxes.ZTick = [];
plotingAxes.ZTickLabel = [];

%     pause(1);
drawnow;

% end

